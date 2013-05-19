# Rails – Country Select
[![Build Status](https://travis-ci.org/stefanpenner/country_select.png?branch=master)](https://travis-ci.org/stefanpenner/country_select)

Provides a simple helper to get an HTML select list of countries with
their [ISO 3166-1 alpha-2 codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
as values and [ISO 3166-1 names](https://en.wikipedia.org/wiki/ISO_3166-1)
as display strings. While it is a relatively neutral source of country
names, it may still offend some users.

Users are strongly advised to evaluate the suitability of this list
given their user base.

## Installation

Install as a gem using

```shell
gem install country_select
```
Or put the following in your Gemfile

```ruby
gem 'country_select'
```

## Tests

```shell
bundle
bundle exec rspec
```

## Example

Simple use supplying model and attribute as parameters:

```ruby
country_select("user", "country")
```

Supplying priority countries to be placed at the top of the list:

```ruby
country_select("user", "country", [ "gb", "fr", "de" ])
```

Copyright (c) 2008 Michael Koziarski, released under the MIT license
