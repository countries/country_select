# encoding: utf-8
require 'countries'

module CountrySelect
  def self.use_iso_codes
    Thread.current[:country_select_use_iso_codes] ||= false
  end

  def self.use_iso_codes=(val)
    Thread.current[:country_select_use_iso_codes] = val
  end

  def self.locale
    I18n.locale
  end

  #Localized Countries list
  def self.countries(with_locale=nil)
    with_locale ||= locale

    ISO3166::Country.all.inject({}) do |hash,country_pair|
      default_name = country_pair.first
      code = country_pair.last
      country = Country.new(code)
      localized_name = country.translations[with_locale.to_s]

      # Codes should not be downcased, but they were previous to 1.3
      # which means they should continue to be until 2.0 is released in
      # order to prevent breakage with existing implementations
      hash[code.downcase] = localized_name || default_name
      hash
    end
  end
end
