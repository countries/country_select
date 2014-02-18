# encoding: utf-8
require 'iso3166'

module CountrySelect
  # Localized Countries list
  def self.countries(locale=nil)
    I18n.with_locale(locale) do
      ISO3166::Country.all.inject({}) do |hash,country_pair|
        default_name = country_pair.first
        code = country_pair.last
        country = ISO3166::Country.new(code)
        localized_name = country.translations[I18n.locale.to_s]

        hash[code] = localized_name || default_name
        hash
      end
    end
  end
end
