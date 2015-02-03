module CountrySelect
  class CountryNotFoundError < StandardError;end
  module TagHelper
    def country_option_tags
      option_tags_options = {
        :selected => @options.fetch(:selected) { value(@object) },
        :disabled => @options[:disabled]
      }

      if priority_countries.present?
        priority_countries_options = country_options_for(priority_countries, false)

        option_tags = options_for_select(priority_countries_options, option_tags_options)
        option_tags += html_safe_newline + options_for_select([priority_countries_divider], disabled: priority_countries_divider)

        if priority_countries.include?(option_tags_options[:selected])
          option_tags_options[:selected] = nil
        end

        option_tags += html_safe_newline + options_for_select(country_options, option_tags_options)
      else
        option_tags = options_for_select(country_options, option_tags_options)
      end
    end

    private
    def locale
      @options[:locale]
    end

    def priority_countries
      @options[:priority_countries]
    end

    def priority_countries_divider
      @options[:priority_countries_divider] || "-"*15
    end

    def only_country_codes
      @options[:only]
    end

    def except_country_codes
      @options[:except]
    end

    def format
      @options[:format] || :default
    end

    def country_options
      country_options_for(all_country_codes, true)
    end

    def all_country_codes
      codes = ISO3166::Country.all.map(&:last)

      if only_country_codes.present?
        codes & only_country_codes
      elsif except_country_codes.present?
        codes - except_country_codes
      else
        codes
      end
    end

    def country_options_for(country_codes, sorted=true)
      I18n.with_locale(locale) do
        country_list = country_codes.map do |code_or_name|
          if country = ISO3166::Country.new(code_or_name)
            code = country.alpha2
          elsif country = ISO3166::Country.find_by_name(code_or_name)
            code = country.first
            country = ISO3166::Country.new(code)
          end

          unless country.present?
            msg = "Could not find Country with string '#{code_or_name}'"
            raise CountryNotFoundError.new(msg)
          end

          name = ::CountrySelect::FORMATS[format].call(country)

          [name,code]
        end

        if sorted
          country_list.sort_alphabetical
        else
          country_list
        end
      end
    end

    def html_safe_newline
      "\n".html_safe
    end
  end
end

