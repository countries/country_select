# frozen_string_literal: true

module CountrySelect
  FORMATS = {}

  FORMATS[:default] = lambda do |country|
    country.translations[I18n.locale.to_s] || country.name
  end
end
