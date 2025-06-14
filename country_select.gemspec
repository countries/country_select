# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'country_select/version'

Gem::Specification.new do |s|
  s.name        = 'country_select'
  s.version     = CountrySelect::VERSION
  s.licenses    = ['MIT']
  s.authors     = ['Stefan Penner']
  s.email       = ['stefan.penner@gmail.com']
  s.homepage    = 'https://github.com/countries/country_select'
  s.summary     = 'Country Select Plugin'
  s.description = 'Provides a simple helper to get an HTML select list of countries. \
                   The list of countries comes from the ISO 3166 standard. \
                   While it is a relatively neutral source of country names, it will still offend some users.'

  s.metadata      = { 'bug_tracker_uri' => 'http://github.com/countries/country_select/issues',
                      'changelog_uri' => 'https://github.com/countries/country_select/blob/master/CHANGELOG.md',
                      'source_code_uri' => 'https://github.com/countries/country_select',
                      'rubygems_mfa_required' => 'true' }

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 3.2'

  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'simplecov', '~> 0.22'

  s.add_dependency 'countries', '> 6.0', '< 9.0'
end
