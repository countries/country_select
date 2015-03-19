## 2.2.0 2015-03-19

  * #101 - Update countries gem to ~> v0.11.0

## 2.1.1 2015-02-02

  * #94 - Prevent usage of countries v0.10.0 due to poor performance

## 2.1.0 2014-09-29

  * #70 - Allow custom formats for option tag text – See README.md

## 2.0.1 2014-09-18

  * #72 - Fixed `include_blank` and `prompt` in Rails 3.2
  * #75 - Raise `CountrySelect::CountryNotFound` error when given a country
    name or code that is not found in https://github.com/hexorx/countries

## 2.0.0 2014-08-10

  * Removed support for Ruby < 1.9.3
  * ISO-3166 alpha-2 codes are now on by default, stored in uppercase
    (e.g., US)
  * Localization is always on
    * The `country_select` method will always attempt to localize
      country names based on the value of `I18n.locale` via translations
      stored in the `countries` gem
  * Priority countries should now be set via the `priority_countries` option
    * The original 1.x syntax is still available
  * The list of countries can now be limited with the `only` and
    `except` options
  * Add best-guess support for country names when codes aren't provided
    in options (e.g., priority_countries)

## 1.2.0 2013-07-06

  * Country names have been synced with UTF-8 encoding to the list of
    countries on [Wikipedia's page for the ISO-3166 standard](https://en.wikipedia.org/wiki/ISO_3166-1).
    * NOTE: This could be a breaking change with some of the country
      names that have been fixed since the list was last updated.
    * For more information you can checkout all country mappings with
      `::CountrySelect::COUNTRIES`

  * You can now store your country values using the
    [ISO-3166 Alpha-2 codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
    with the `iso_codes` option. See the README.md for details.
    * This should help alleviate the problem of country names
      in ISO-3166 being changed and/or corrected.
