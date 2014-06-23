# TablePrinter

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'table_printer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install table_printer

## Usage

### The Easy Way

```ruby
data = [{"user" => "paul", "repos" => 42, "pull_requests" => 17},
        {"user" => "pete", "repos" => 12, "pull_requests" => 11}]

puts TablePrinter.new(data)
```

```
 user | repos | pull_requests
------+-------+---------------
 paul |    42 |            17
 pete |    12 |            11
```

### The Advanced Way

```ruby
table = TablePrinter.new(data) do
  column :user, format: lambda { |name| ActiveSupport::Inflector.titleize(name) }
  column :repos, :pull_requests, format: lambda { |count| "%0.1f" % count }
end

puts table
```

```
 User | Repos | Pull Requests
------+-------+---------------
 paul |  42.0 |          17.0
 pete |  12.0 |          11.0

```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/table_printer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
