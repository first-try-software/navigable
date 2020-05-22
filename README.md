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

To create a Navigable application:
```
$ navigable new app_name
```

This will create the following project structure:
```
/app_name
  config.ru
  /commands
    command.rb
    root.rb
```

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


This will declare five routes. View them by running `rake resources`:

```
     GET /posts       =>   Posts::Index  (missing)
     GET /posts/:id   =>   Posts::Show   (missing)
    POST /posts       =>   Posts::Create (missing)
     PUT /posts/:id   =>   Posts::Update (missing)
  DELETE /posts/:id   =>   Posts::Delete (missing)
```

Next, declare the five missing classes listed above...

First, extend `Navigable::Command` in a base class:

```ruby
class Command
  extend Navigable::Command
end
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
