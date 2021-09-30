# BarBack

<p align="center"><img alt="BarBack logo: Martini glass with Bs on its side displayed as a neon sign" src="./logo.png" width=200px height=200px /></p>

BarBack is the Rails console you can share with non technical people.

BarBack is simple and bullshit free by design: features are limited in scope and dependencies kept to the minimum. In other words, it's easier to use and less buggy than the alternatives.

BarBack enables you to (with HTTP basic authentication):

- execute an ActiveRecord or SQL read query;
- save an ActiveRecord or SQL read query for later;
- view the query result and update or create records;
- share the query result with anybody via a link that contains a random UUID;
- export the query result to CSV.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bar_back'
```

And then execute:

```bash
$ bundle
$ bin/rails generator bar_back:install
```

## Usage

### Mounted Path

BarBack by default is mounted at `/bar_back` in `config/routes.rb`:

```ruby
mount BarBack::Engine => "/bar_back"
```

### HTTP Basic Authentication

HTTP basic authentication is enabled by default in `config/initializers/bar_back.rb`:

```ruby
BarBack.http_basic_enabled = true
BarBack.http_basic_username = "#{SecureRandom.alphanumeric(10)}"
BarBack.http_basic_password = "#{SecureRandom.alphanumeric(10)}"
```

## Tests

```bash
$ bin/rails test test/
```

## Contributing

Contributions are more than welcome, but I'd love to keep BarBack simple and bullshit free.

Please let's discuss in an issue before submitting a pull request.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
