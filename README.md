<img src="splash.png">

# Navigable

Navigable is an opinionated extension of [Hanami::Router](https://github.com/hanami/router) that uses convention and auto-loading to connect restful URIs to [Command](https://en.wikipedia.org/wiki/Command_pattern) classes. When a command class is loaded into memory, it automatically registers a corresponding route with the router. When a request is received, Navigable instantiates and executes the associated Command, which renders the appropriate response to the client.

## TODO

* Feels weird managing both extension and inheritance in command.rb
* Add `rake routes` once Hanami::Router 2.0 supports it
* Support `.json` or `.html` formats in URL
* Provide headers to client in case they need them (like for auth)
* Allow people to add their own middleware
* Think about whether or not resources are singular or plural
  - Should `posts_id` be `post_id`?
* Modules extend Navigable::Namespace to become namespaces with URL params
  - url_param :post_id
* named command parameters?
  - param permitting
* Add documenation comments & generate docs
* Add to CI
* Add to CodeClimate

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

Run this command to create a Navigable application:

    $ navigable new app_name

This will create a new Navigable application in the specified folder with the following structure:
```
/app_name
  config.ru         # Rackup file to start application
  /commands
    command.rb      # Base command class
    root.rb         # Root command class
```

To add functionality to your application, just add commands. Say you wanted to see all the entries in a blog. Just add this code to `/app_name/commands/posts/index.rb`:

```ruby
module Posts
  class Index < Command
    attr_reader :search

    def initialize(params)
      @search = params[:search]
    end

    def execute
      posts = posts

      render json: posts
    end

    private

    def posts
      # Fetch data using search parameter
    end
  end
end
```

Now, when you run your application, every file in the `/commands` folder will be auto-loaded. When `/posts/index.rb` loads, Navigable will register this route: `GET /posts  =>  Posts::Index` for you. So, there's no need for a routes file.

By convention, command classes must be named `Index`, `Show`, `Create`, `Update`, or `Delete`. Each command class automatically registers an appropriate route when the file is loaded. You can add all five commands for a resource, or only a subset. To add one, simply create the appropriate command class. To leave one out, just don't define the command class. Additionally, `Root` is a special command class that adds the root route: `GET /  =>  Root`.

Here's a summary of the routes that each command class registers for the `Posts` resource:
```
     GET /            =>   Root
     GET /posts       =>   Posts::Index
     GET /posts/:id   =>   Posts::Show
    POST /posts       =>   Posts::Create
     PUT /posts/:id   =>   Posts::Update
  DELETE /posts/:id   =>   Posts::Delete
```

You can even create namespaced routes by wrapping a command class in additional modules, like this:
```ruby
module Posts
  module Comments
    class Index
      attr_reader :posts_id, :search

      def initialize(params)
        @posts_id = params[:posts_id]
        @search = params[:search]
      end

      def execute
        render json: comments
      end

      private

      def comments
        # Fetch data using posts_id and search parameter
      end
    end
  end
end
```

Which will create this route:

    GET /posts/:posts_id/comments  =>  Posts::Comments::Index

Inside a command class, you must define an initializer that accepts `params`, and create an `execute` method that returns a `Navigable::Response`.

`params` is a hash that includes all of the meaningful parameters in the request, including parsed JSON from the body of the request, multi-part form data, and query string key/value pairs.

The `execute` method needs to create a `Navigable::Response` object to return to the client. The simplest way to do that is to call `render`. The `render` method takes a hash containing zero or more of the following attributes: `status:`, `headers:`, `json:`, `html:`, `text:`, and `body:`.

```ruby
render                              # Returns status: 200, with an empty string in the body
render status: 404                  # 200 is the default
render json: {a: 1, b: 2}.to_json   # Sets content type to application/json and returns JSON
render html: '<html>...</html>'     # Sets content type to text/html and returns HTML
render text: 'word'                 # Sets content type to text/plain and returns the text
render body: 'any string'           # Returns the string without setting content type

# Returns a random kitten image
render headers: { 'Content-Type' => 'image/png' }, body: File.read('http://placekitten.com/300/300')
```
> Note: It's up to you how you to handle the parameters injected into your command object. But, we recommend that you only capture the parameters that your command needs, like `@search` in the examples above. However you handle them, do NOT pass the entire parameters hash into a database query.

> Note: We recommend that you keep your command classes small by leveraging common design patterns to offload things like data access and template rendering. We also recommend the use of dependency injection when defining external collaborators, like this:

```ruby
module Posts
  class Show
    attr_reader :id

    def initialize(params, template = ShowPost, repository = PostsRepository)
      @id = params[:id]
      @template = template
      @repository = repository
    end

    def execute
      return render(status: 404) if post.nil?

      render html: body
    end

    private

    def body
      template.new(post).render
    end

    def post
      @repository.find(id)
    end
  end
end

Rspec.describe Posts::Show do
  subject(:command) { described_class.new(params, template, repository) }

  let(:params) { { id: 42 } }
  let(:template) { instance_double(ShowPost, render: body) }
  let(:body) { nil }
  let(:repository) { instance_double(PostsRepository, find: post) }
  let(:post) { nil }

  before do
    allow(ShowPost).to receive(:new).and_return(template)
    allow(PostsRepository).to receive(:new).and_return(repository)
  end

  describe '#execute' do
    subject(:execute) { command.execute }

    before do
      allow(command).to receive(:render)

      execute
    end

    context 'when the post is NOT found' do
      let(:post) { nil }

      it 'renders 404' do
        expect(command).to receive(:render).with(status: 404)
      end
    end

    context 'when the post is found' do
      let(:post) { instance_double(Post) }
      let(:body) { '<html><body>Post 42</body></html>' }

      it 'renders the post' do
        expect(command).to receive(:render).with(html: body)
      end
    end
  end
end
```

## Command Line Interface
```
Commands:
  navigable help [COMMAND]  # Describe available commands or one specific command
  navigable new APP_NAME    # Generates a new Navigable application
  navigable open            # Opens the current navigable application in the browser
  navigable server          # Starts the Navigable server
  navigable start           # Starts the Navigable server daemon
  navigable stop            # Stops the Navigable server daemon
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
