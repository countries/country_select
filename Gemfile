source 'https://rubygems.org'

# Specify your gem's dependencies in country_select.gemspec
gemspec

# Duplicating this in Gemfile until thoughtbot pushes latest version
# that supports Bundler `platform` directive for rbx support in travis-ci
# Once appraisal 1.0.0 is released, this line can be removed
gem 'appraisal', :github => 'thoughtbot/appraisal', :ref => '6d599f'

platforms :rbx do
  gem 'racc'
  gem 'rubysl', '~> 2.0'
  gem 'psych'
end
