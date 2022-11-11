# Occasionally

It's a pain setting up crontab for Rails projects in container environments. Occasionally makes it possible to occasionally run Ruby code once `every x seconds` and embed it in your Rails application via a `fork`.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add occasionally

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install occasionally

## Usage

Create the following file in `./config/initializers/occasionally.rb`

```ruby
Occassionally.schedule do
  every 60 do
    puts "hey! Its #{Time.now}"
  end

  every 5 do
    puts "Looks like another 5 seconds have passed"
  end

  logger Rails.logger

  run if true # Or more likely `run if ENV.key? "PRIMARY_NODE"`
end
```

Then boot your Rails application and behold! Occasionally some jobs will run.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bradgessler/occasionally. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bradgessler/occasionally/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Occasionally project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bradgessler/occasionally/blob/main/CODE_OF_CONDUCT.md).
