# TablePrinter

[![Circle CI](https://circleci.com/gh/paul/table_printer.svg?style=svg)](https://circleci.com/gh/paul/table_printer)[!CodeClimate](https://d3s6mut3hikguw.cloudfront.net/github/paul/table_printer/badges/gpa.svg)

## Installation

Add this line to your application's Gemfile:

    gem 'table_printer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install table_printer

## Usage

### The Easy Way

Just pass in an array of arrays or hashes (symbol or string keys). The keys will become the column names, and any Numeric columns will be right-justified.

#### Example

```ruby
include TablePrinter

data = [{"user" => "paul", "repos" => 42, "pull_requests" => 17},
        {"user" => "pete", "repos" => 12, "pull_requests" => 11}]

puts print_table(data)
```

```
 user | repos | pull_requests
------+-------+---------------
 paul |    42 |            17
 pete |    12 |            11
```

### The Advanced Way

You may pass in a configuration block that will allow you to specify the order that columns will be displayed, as well as change the format and justification.

You also do not need to include the `TablePrinter` module, you can use the class directly.

#### Column options

 * `:format`: May be a String, Symbol or Proc:
   * String: will be used as a `printf`-style formatting string.
   * Symbol: can be `:percent`, `:bytes`, or `:time`
   * Proc: will be called with the value as an argument
 * `:justify`: One of `"left"`, `"right"` or `"center"`


#### Example

```ruby
table = TablePrinter::Table.new(data) do
  column :user, format: lambda { |name| ActiveSupport::Inflector.titleize(name) }
  column :repos, :pull_requests, format: "%0.1f"
end

puts table
```

```
 User | Repos | Pull Requests
------+-------+---------------
 paul |  42.0 |          17.0
 pete |  12.0 |          11.0

```

See the [examples folder](https://github.com/paul/table_printer/tree/master/examples) for more.

**Note** There's a common gotcha if you try to print and config the table in one line. Due to [ruby precedence rules with blocks](http://blog.plataformatec.com.br/2014/07/ruby-blocks-precedence/), you'll need to use braces instead of `do...end`. For example:

```ruby
puts print_table(data) {
  column :foo, :bar
}
```

Using `do...end` here **will not work** because the block gets passed to `puts` instead of `print_table`.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/table_printer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
