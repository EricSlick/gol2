# Gol2

An Implementation of the Game of Life with a few twists

## Installation

### pre-requisites:

This is a very early version and is quite rough.

You probably need to install some requisite files for Gosu. https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X

```
brew install sdl2
```

```ruby
gem 'gol2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gol2

## Usage

Right now, after a successful bundle, you can run it from the gol2 script in the bin folder
```
bin/gosu2
```

This brings up a Gosu Window and randomly places about 20 cell patterns to start. It's very basic atm.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/gol2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

