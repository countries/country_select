Country-Select

Provides a simple helper to get an HTML select list of countries.  The list of countries comes
from the ISO 3166 standard.  While it is a relatively neutral source of country names, it may
still offend some users.

Users are strongly advised to evaluate the suitability of this list given their user base.

## Installation

Install as a gem using

    gem install country-select

Or put the following in your Gemfile

    gem 'country-select'

## Example

Simple use supplying model and attribute as parameters:

    country_select("user", "country_name")

Supplying priority countries to be placed at the top of the list:

    country_select("user", "country_name", [ "United Kingdom", "France", "Germany" ])

Specifying which country to be selected:
United Kingdom will be selected.
country_select("user", "country_name", [ "+United Kingdom+", "France", "Germany" ])

Example in a Rails form:
Full list, with New Zealand Australia and United Kingdom prioritized (New Zealand selected
by default)
<%= country_select(:player, :nationality, [ "+New Zealand+", "Australia", "United Kingdom" ])
%>


Copyright (c) 2008 Michael Koziarski, released under the MIT license
