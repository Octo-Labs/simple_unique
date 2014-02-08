# SimpleUnique 

A simple gem to add `validates_uniqueness_of` to `AWS::Record::Model`
supplied by `aws-sdk`.

[![Gem Version](https://badge.fury.io/rb/simple_unique.png)](http://badge.fury.io/rb/simple_unique)
[![Code Climate](https://codeclimate.com/repos/52f5dc34695680672d00c3b6/badges/3944be4831afc37624e9/gpa.png)](https://codeclimate.com/repos/52f5dc34695680672d00c3b6/feed)


## Installation

Add this line to your application's Gemfile:

    gem 'simple_unique'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_unique 

## Usage

```ruby
    def Person < AWS::Record::Model
      string_attr :name
      validates_uniqueness_of :name
    end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
