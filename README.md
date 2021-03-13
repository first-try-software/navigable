<a target="top" href="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/navigable.png"><img alt="Navigable" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/header.png"></a>

# Navigable

Navigable is a stand-alone tool for isolating business logic from external interfaces and cross-cutting concerns. Navigable composes self-configured command and observer objects to allow you to extend your business logic without modifying it. Navigable is compatible with any Ruby-based application development framework, including Rails, Hanami, and Sinatra.

<br>

[![Gem Version](https://badge.fury.io/rb/navigable.svg)](https://badge.fury.io/rb/navigable) [![Build Status](https://travis-ci.org/first-try-software/navigable.svg?branch=main)](https://travis-ci.org/first-try-software/navigable) [![Maintainability](https://api.codeclimate.com/v1/badges/33ca28cb17e1b512e006/maintainability)](https://codeclimate.com/github/first-try-software/navigable/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/33ca28cb17e1b512e006/test_coverage)](https://codeclimate.com/github/first-try-software/navigable/test_coverage)

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

We built Navigable to help separate the web adapter and persistence layer from your actual business logic. And, we did it in a composable manner that allows for incredible flexibility. Here's a peek:

```ruby
# CreateAlert command
class CreateAlert
  extend Navigable::Command

  corresponds_to :create_alert
  corresponds_to :create_alert_and_notify

  def execute
    return failed_to_validate(new_alert) unless new_alert.valid?
    return failed_to_create(new_alert) unless created_alert.persisted?

    successfully created_alert
  end

  private

  def new_alert
    @new_alert ||= Alert.new(params)
  end

  def created_alert
    @created_alert ||= @new_alert.save
  end
end

# AllRecipientsNotifier observer
class AllRecipientsNotifier
  extend Navigable::Observer

  observes :create_alert_and_notify

  def on_success(alert)
    NotifyAllRecipientsWorker.perform_async(alert_id: alert.id)
  end
end
```

In these two classes, Navigable enables you to execute multiple use cases. You can create an alert:

```ruby
Navigable::Dispatcher.dispatch(:create_alert, params: alert_params)
```

Or, create an alert and notify all recipients:

```ruby
Navigable::Dispatcher.dispatch(:create_alert_and_notify, params: alert_params)
```

All without having to add conditional logic about the notifications to the `CreateAlert` class.

Similarly, you can add cross-cutting concerns to an application just as easily:

```ruby
# Monitor observer
class Monitor
  extend Navigable::Observer

  observes_all_commands

  def on_success(*args)
    increment_counter(observed_command_key, :success)
  end

  def on_failed_to_validate(*args)
    increment_counter(observed_command_key, :failed_to_validate)
  end

  def on_failed_to_create(*args)
    increment_counter(observed_command_key, :failed_to_create)
  end

  # ...
end
```
Here are a few things to look for in the code above:

* The DSL in the `execute` method of the `CreateAlert` class is built into Navigable. Methods like `successfully` tell Navigable the results of the command so that it can notify the observers.

* The two `corresponds_to` statements in `CreateAlert` tell Navigable to execute that command when either key is dispatched. You can register a command under as many different keys as you need.

* The single `observes` statement in `AllRecipientsNotifier` class tells Navigable to send a message to that class only when the `:create_alert_with_notifications` key is dispatched. One observer can observe as many commands as you need. And, many observers can observe the same command.

* Use the `observes_all_commands` statement (as shown in the `Monitor` class) for cross-cutting concerns. It tells Navigable to send messages to the observer no matter which command was executed.

For a deeper look at the core concepts introduced by Navigable, please have a look at our [wiki][wiki].

## Rails Usage

The code above can be integrated into Rails like this:

```ruby
# AlertsController
class AlertsController < ApplicationController
  # ...

  def create
    Navigable::Dispatcher.dispatch(:create_alert, params: alert_params)
  end

  # ...
end

# Alert model
class Alert < ApplicationRecord
  validates :title, presence: true
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/first-try-software/navigable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Navigable project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/first-try-software/navigable/blob/main/CODE_OF_CONDUCT.md).

[sandi]: https://thoughtbot.com/blog/sandi-metz-rules-for-developers
[srp]: https://en.wikipedia.org/wiki/Single-responsibility_principle
[ocp]: https://en.wikipedia.org/wiki/Open–closed_principle
[ddd]: https://en.wikipedia.org/wiki/Domain-driven_design
[mail]: mailto:navigable@firsttry.software
[wiki]: https://github.com/first-try-software/navigable/wiki
[navigable]: https://github.com/first-try-software/navigable
[router]: https://github.com/first-try-software/navigable-router
[server]: https://github.com/first-try-software/navigable-server
[graphql]: https://github.com/first-try-software/navigable-graphql
