# encoding: utf-8
require 'countries'

module CountrySelect
  # Global ISO Code variable
  @@use_iso_codes = false
  def self.use_iso_codes
    @@use_iso_codes
  end
  def self.use_iso_codes=(use_iso_codes)
    @@use_iso_codes = use_iso_codes
  end

  #Global Locale Code variable
  @@locale = "en"
  def self.locale
    @@locale
  end
  def self.locale=(locale)
    @@locale = locale
  end

  #Localized Countries list
  def self.countries(use_locale = @@locale)
    locale = use_locale ||= @@locale
    @countries = ISO3166::Country.all.inject({}) do |r,s|
        name = Country.new(s[1]).translations[locale]
        r.merge!({s[1] => name.nil? ? s[0] : name})
    end
  end
end
