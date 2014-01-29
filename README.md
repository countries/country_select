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

## Usage

Simple use supplying model and attribute as parameters:

```ruby
country_select("user", "country")
```

Supplying priority countries to be placed at the top of the list:

```ruby
country_select("user", "country", [ "Great Britain", "France", "Germany" ])
```

### Using Country Name Localization
Country names are automatically localized based on the value of
`I18n.locale` thanks to the wonderful
[countries gem](https://github.com/hexorx/countries/).

Current translations include:
en, it, de, fr, es, ja, nl, but may not be complete. In the event a translation is 
not available, it will revert to the globally assigned locale (by default, "en").

The locale can be overridden locally:
```ruby
country_select(:country_name, ['US'], {:iso_codes => true, :locale => 'es'}) 
```

### Using ISO 3166-1 alpha-2 codes as values
You can have the `option` tags use ISO 3166-1 alpha-2 codes as values
and the country names as display strings. For example, the United States
would appear as `<option value="US">United States</option>`

If you're starting a new project, this is the recommended way to store
your country data since it will be more resistant to country names
changing.

```ruby
country_select("user", "country_code", nil, iso_codes: true)
```

```ruby
country_select("user", "country_code", [ "GB", "FR", "DE" ], iso_codes: true)
```

#### Global configuration to always use ISO codes
Add the following configuration to an initializer.

```ruby
::CountrySelect.use_iso_codes = true
```

#### Getting the Country from ISO codes

```ruby
class User < ActiveRecord::Base

  # Assuming country_select is used with User attribute `country_code`
  # This will attempt to translate the country name and use the default
  # (usually English) name if no translation is available
  def country_name
    country = Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

end
```
## Example Application

An example Rails application demonstrating the different options is available at [scudco/country_select_test](https://github.com/scudco/country_select_test). The relevant view file lives [here](https://github.com/scudco/country_select_test/blob/master/app/views/welcome/index.html.erb).

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
