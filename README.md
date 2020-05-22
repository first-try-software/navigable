# Navigable

Navigable is an opinionated extension of [Hanami::Router](https://github.com/hanami/router) that uses convention and auto-loading to connect restful URIs to [Command](https://en.wikipedia.org/wiki/Command_pattern) classes. When a command class is loaded into memory, it automatically registers a corresponding route with the router. When a request is received, Navigable instantiates and executes the associated Command, which renders the appropriate response to the client.

## TODO

* Warn when overriding `root` route
* Add a rake task to display routes: `rake routes`
* Consider adding a generator
  - new app
* Support .json or .html from url
* Provide headers to client in case they need them (like for auth)
* Allow people to add their own middleware
* Think about whether or not resources are singular or plural
  - Should `posts_id` be `post_id`?
* Modules extend Navigable::Namespace to become namespaces with URL params
  - url_param :post_id
* named command parameters?
* Add to CI
* Add to CodeClimate
* Rewrite README

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'navigable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install navigable

## Usage

To create a Navigable application, run:

    $ navigable new app_name

This will create a new Navigable application in the specified folder with the following structure:
```
/app_name
  config.ru         # Rackup file to start application
  /commands
    command.rb      # Base command class
    root.rb         # Root command class
```

To add functionality to your application, just add commands. Say you wanted to see all the entries in a blog. Just create `/app_name/commands/posts/index.rb` and add this code:

```ruby
module Posts
  class Index < Command
    attr_reader :search

    def initialize(params)
      @search = params[:search]
    end

    def execute
      posts = fetch_posts(filter: search)

      render json: posts
    end

    private

    def fetch_posts(filter:)
      # Fetch data however you want
    end
  end
end
```

Now, when you run your application and `/posts/index.rb` is loaded, Navigable will automatically register this route: `GET /posts  =>  Posts::Index`.

By convention, command classes must be named `Index`, `Show`, `Create`, `Update`, or `Delete`. Each command class automatically registers an appropriate route when the file is loaded. You can add all five commands, or a subset. To leave one out, just don't define the command class. Additionally, `Root` is a special command class that adds the root route: `GET /  =>  Root`.

Navigable automatically loads all the files in the `commands` folder. When it does, it creates the following route structure (where `resource` is the name of the module in which the class is defined, like `posts` in the example above):
```
Root        #    GET /
Index       #    GET /resource
Show        #    GET /resource/:id
Create      #   POST /resource
Update      #    PUT /resource/:id
Delete      # DELETE /resource/:id
```

Inside the command classes, you must define an initializer that accepts `params`, and an `execute` method that calls `render`. `params` is a hash that includes all of the meaningful parameters in the request, including parsed JSON from the body of the request, multi-part form data, and query string key/value pairs. It's up to you how you to handle those parameters. But, we recommend that you only capture the parameters that your command needs, like `@search` in the example above. However you handle them, do NOT pass the entire parameters hash into a database query.

The `execute` method can run any code you want. But, we recommend that you keep your command classes small by leveraging common design patterns to offload things like data access and template rendering. Once your command has fetched data and created a response, the `execute` method must call `render` in order to send the repsonse to the client. `render` takes the following parameters: `status:`, `headers:`, `json:`, `html:`, `text:`, and `body:`.

```ruby
render                              # Returns status: 200, with an empty string in the body
render status: 404                  # 200 is the default
render json: {a: 1, b: 2}.to_json   # Sets content type to application/json and returns JSON
render html: '<html>...</html>'     # Sets content type to text/html and returns HTML
render text: 'word'                 # Sets content type to text/plain and returns the text
render body: 'any string'           # Returns the string without setting content type

render headers: { 'Content-Type' => 'image/png' }, body: File.read('http://placekitten.com/300/300')    # Returns a random kitten image
```






YOU ARE HERE!!!








Any parameters sent with the request - whether from JSON in the request body, from multi-part form data, or from the query string - will be in the params hash used to initialize your command. This allows your command class to determine which params it cares about and ignore the others.

(NOTE: `fetch_posts` is a fictional method used here to illustrate a typical use case. You can use whatever data access technology you want with Navigable.)









To add a route to your application, create a new Command class.




By convention, command classes are expected to be named `Root`, `Index`, `Show`, `Create`, `Update`, or `Delete`. They may be namespaced


Classes in the `commands` folder must follow a convention. They must be named `Root`, `Index`, `Show`, `Create`, `Update`, or `Delete`. These classes will be registered as route handlers when the files are loaded, which happens automatically when the application starts.
```
     GET /            =>   Root
     GET /posts       =>   Posts::Index
     GET /posts/:id   =>   Posts::Show
    POST /posts       =>   Posts::Create
     PUT /posts/:id   =>   Posts::Update
  DELETE /posts/:id   =>   Posts::Delete
```



Then, declare the Posts Commands. Each command requires an `execute` method that calls `render` to respond to the request:

```ruby
module Posts
  class Index < Command
    attr_reader :search

    def initialize(params)
      @search = params[:search]
    end

    def execute
      posts = fetch_posts(filter: search)

      render json: posts
    end
  end

  class Show < Command
    attr_reader :id

    def initialize(params)
      @id = params[:id]
    end

    def execute
      post = fetch_post(id)

      if post
        render json: post
      else
        render status: 404, json: {}
      end
    end
  end

  class Create < Command
    attr_reader :title, :body

    def initialize(params)
      @title = params[:title]
      @body = params[:body]
    end

    def execute
      post = create_post(title, body)

      if post
        render status: 201, json: post
      else
        render status: 400, json: {}
      end
    end
  end

  class Update < Command
    attr_reader :id, :title, :body

    def initialize(params)
      @id = params[:id]
      @title = params[:title]
      @body = params[:body]
    end

    def execute
      post = update_post(id, title, body)

      render json: post
    end
  end

  class Delete < Command
    attr_reader :id

    def initialize(params)
      @id = params[:id]
    end

    def execute
      deleted_post = delete_post(id)

      if deleted_post
        render json: deleted_post
      else
        render status: 404, json: {}
      end
    end
  end
end
```

NOTE: The data read and write operations in the examples are for illustrative purposes only. They are beyond the scope of Navigable.

You can also declare namespaces with nested resources:

```ruby
Navibable.resources do
  add :posts

  namespace :posts do
    add :comments
  end
end
```

This will declare five more routes. View them by running `rake resources`:

```
     GET /posts                          =>   Posts::Index
     GET /posts/:id                      =>   Posts::Show
    POST /posts                          =>   Posts::Create
     PUT /posts/:id                      =>   Posts::Update
  DELETE /posts/:id                      =>   Posts::Delete
     GET /posts/:posts_id/comments       =>   Posts::Comments::Index  (missing)
     GET /posts/:posts_id/comments/:id   =>   Posts::Comments::Show   (missing)
    POST /posts/:posts_id/comments       =>   Posts::Comments::Create (missing)
     PUT /posts/:posts_id/comments/:id   =>   Posts::Comments::Update (missing)
  DELETE /posts/:posts_id/comments/:id   =>   Posts::Comments::Delete (missing)
```

This nests the resources. Therefore, the Command objects must be nested, too:

```ruby
module Posts
  module Comments
    class Show < Command
      attr_reader :id

      def initialize(params)
        @posts_id = params[posts_id]
        @id = params[:id]
      end

      def execute
        post = fetch_post(id)

        if post
          render json: post
        else
          render status: 404, json: {}
        end
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/first-try-software/navigable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/first-try-software/navigable/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Navigable project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/first-try-software/navigable/blob/master/CODE_OF_CONDUCT.md).
