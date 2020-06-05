module CountrySelect
  FORMATS = {}

  FORMATS[:default] = lambda do |country|
    country.translations&.dig(I18n.locale.to_s) || country.name
  end
end
