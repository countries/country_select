# Rails – Country Select
[![Build Status](https://travis-ci.org/stefanpenner/country_select.png?branch=master)](https://travis-ci.org/stefanpenner/country_select)

Provides a simple helper to get an HTML select list of countries using the
[ISO 3166-1 standard](https://en.wikipedia.org/wiki/ISO_3166-1).

It is also configurable to use countries'
[ISO 3166-1 alpha-2 codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
as values and
[ISO 3166-1 names](https://en.wikipedia.org/wiki/ISO_3166-1)
as display strings.

While the ISO 3166 standard is a relatively neutral source of country
names, it may still offend some users. Developers are strongly advised
to evaluate the suitability of this list given their user base.

## Installation

Install as a gem using

```shell
gem install country_select
```
Or put the following in your Gemfile

```ruby
gem 'country_select'
```

## Example

Simple use supplying model and attribute as parameters:

```ruby
country_select("user", "country")
```

Supplying priority countries to be placed at the top of the list:

```ruby
country_select("user", "country", [ "Great Britain", "France", "Germany" ])
```

### Using ISO 3166-1 alpha-2 codes as values
You can have the `option` tags use ISO 3166-1 alpha-2 codes as values
and the country names as display strings. For example, the United States
would appear as `<option value="us">United States</option>`

If you're starting a new project, this is the recommended way to store
your country data since it will be more resistant to country names
changing.

```ruby
country_select("user", "country_code", nil, iso_codes: true)
```

```ruby
country_select("user", "country_code", [ "gb", "fr", "de" ], iso_codes: true)
```

#### Getting the Country from ISO codes

```ruby
class User < ActiveRecord::Base

  # Assuming country_select is used with User attribute `country_code`
  def country_name
    ::CountrySelect::COUNTRIES[country_code]
  end

end
```

## Tests

```shell
bundle
bundle exec rspec
```

### Running with multiple versions of actionpack

```shell
bundle exec appraisal
```

Copyright (c) 2008 Michael Koziarski, released under the MIT license
