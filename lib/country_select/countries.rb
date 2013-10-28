# encoding: utf-8
require 'countries'

module CountrySelect
  @@use_iso_codes = false
  def self.use_iso_codes
    @@use_iso_codes
  end
  def self.use_iso_codes=(use_iso_codes)
    @@use_iso_codes = use_iso_codes
  end
  
  unless const_defined?("COUNTRIES")
    COUNTRIES =  ISO3166::Country.all.inject({}) do |r,s| 
        r.merge!({s[1] => s[0]})
    end
  end

  ISO_COUNTRIES_FOR_SELECT = COUNTRIES.invert unless const_defined?("ISO_COUNTRIES_FOR_SELECT")
  COUNTRIES_FOR_SELECT = COUNTRIES.values unless const_defined?("COUNTRIES_FOR_SELECT")
end
