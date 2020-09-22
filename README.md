<a target="top" href="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/navigable.png"><img alt="Navigable" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/header.png"></a>

# Navigable

[![Gem Version](https://badge.fury.io/rb/navigable.svg)](https://badge.fury.io/rb/navigable) [![Build Status](https://travis-ci.org/first-try-software/navigable.svg?branch=main)](https://travis-ci.org/first-try-software/navigable) [![Maintainability](https://api.codeclimate.com/v1/badges/33ca28cb17e1b512e006/maintainability)](https://codeclimate.com/github/first-try-software/navigable/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/33ca28cb17e1b512e006/test_coverage)](https://codeclimate.com/github/first-try-software/navigable/test_coverage)

Navigable is a family of gems that together provide all the tools you need to build fast, testable, and reliable JSON and/or GraphQL based APIs with isolated, composable business logic. The gems include:

<table style="margin: 20px 0">
<tr height="140">
<td width="130"><img alt="Clipper Ship" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/clipper.png"></td>
<td>

**[Navigable][navigable]**<br>
A stand-alone tool for isolating business logic from external interfaces and cross-cutting concerns. Navigable composes self-configured command and observer objects to allow you to extend your business logic without modifying it. Navigable is compatible with any Ruby-based application development framework, including Rails, Hanami, and Sinatra.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Compass" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/sextant.png"></td>
<td>

**[Navigable Router][router]** *(coming soon)*<br>
A simple, highly-performant, Rack-based router.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Compass" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/compass.png"></td>
<td>

**[Navigable Server][server]** *(coming soon)*<br>
A Rack-based server for building Ruby and Navigable web applications.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Telescope" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/telescope.png"></td>
<td>

**Navigable API** *(coming soon)*<br>
An extension of Navigable Server for building restful JSON APIs.

</td>
</tr>
<tr height="140">
<td width="130"><img alt="Map" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/map.png"></td>
<td>

**Navigable GraphQL** *(coming soon)*<br>
An extension of Navigable Server for building GraphQL APIs.

</td>
</tr>
</table>

<br><br>

<img style="width: 600px; display: block; margin: 0 auto;" alt="Lighthouse" src="https://raw.githubusercontent.com/first-try-software/navigable/main/assets/lighthouse.png">

# The Navigable Charter

We hold these truths to be self-evident, that not all objects are created equal, that poorly structured code leads to poorly tested code, and that poorly tested code leads to rigid software and fearful engineers.

We believe a framework should break free of this tyranny. It should be simple, testable, and fast. It can be opinionated. But, it should leverage SOLID principles to guide us toward well structured, well tested, maleable code that is truly navigable.

## Who We Are

We are professional Rubyists. We could write software in any language, but we choose to work in Ruby because it is so beautiful and expressive. We love Ruby.

We are test-oriented developers. We always write tests for our code, often before we've written the code. And, despite the conventional wisdom that investing in tests produces diminishing returns as you approach 100% coverage, we prefer the confidence we get with full coverage.

We are also students of software architecture. We apply SOLID object-oriented design principles like the [Single Responsibility][srp] and [Open/Closed][ocp] Principles to everything we build. And, we follow [Sandi Metz's Rules][sandi] as much as possible. This leads us to write small, loosely coupled, highly cohesive classes.

## Why We Wrote Navigable

Besides being Rubyists, we are also seasoned Rails developers. Most of our experience with Ruby has involved Rails. We've also built applications in Sinatra, and dabbled with Hanami. And, while they all have strengths, we're not completely satisfied with any of them.

### Rails

In our experience, Rails is a fantastic tool for building complex web applications. But, too often, we see engineers let Rails constrain them into thinking that all of their business logic belongs in models (and controllers, and even views!). This leads to overly complex classes with too many responsibilities that are difficult to test. It also reduces the reusability of any one bit of business logic to have it burried in a 5,000 line file. (Yes, we've seen 5,000 line models and controllers, and much worse!) Rails is also a bit of a large toolbox when all you want to do is build a JSON and/or GraphQL API.

### Hanami

In dabbling with Hanami, we feel it has a great deal of promise. As proponents of [Domain Driven Design][ddd], we agree with many of the decisions that went into the framework. But, given that it uses convention as much as Rails, and given the lack of a dedicated home for business logic, we worry that Hanami applications will fall prey to the same problem many large Rails apps face: bloated models/entities and controller actions.

### Sinatra

In our experience, Sinatra is a great tool for small, simple applications. But, it's too slow to be of much use with larger, enterprise applications. So, we've limited our use to very specific types of applications with limited scope.

### And, finally...

All three of these frameworks take a central role in the organization of an application. We've worked on Rails applications in multiple different domains. They all looked like Rails applications. You had to dig into them to discover the core concepts of each specific domain. We believe software should be more reflective of the problem space than it is of the framework used to solve the problem.

## How is Navigable Different?

So, we built Navigable to help separate the web adapter (controller) and persistence layer (model) from your actual business logic. And, we did it in a composable manner that allows for incredible flexibility. Here's a peek:

```ruby
class CreateAlert
  extend Navigable::Command

  corresponds_to :create_alert
  corresponds_to :create_alert_with_notifications

  def execute
    return failed_to_validate(new_alert) unless new_alert.valid?
    return failed_to_create(new_alert) unless created_alert.persisted?

    successfully created_alert
  end

  # ...
end

class AllRecipientsNotifier
  extend Navigable::Observer

  observes :create_alert_with_notifications

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
Navigable::Dispatcher.dispatch(:create_alert_with_notifications, params: alert_params)
```

All without having to add conditional logic about the notifications to the `CreateAlert` class.

Similarly, you can add cross-cutting concerns to an application just as easily:

```ruby
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

## Feedback

We are really excited about Navigable! We think it solves the problem of seperating business logic from the web interface, persistence layer, and even cross-cutting concerns in an elegant and simple way.

We're thrilled you're checking out Navigable! If you have any questions or comments, please feel free to reach out to [navigable@firsttry.software][mail].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'navigable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install navigable

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

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