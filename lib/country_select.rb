# encoding: utf-8

require 'country_select/version'
require 'iso3166'

module ActionView
  module Helpers
    class FormBuilder
      def country_select(method, options = {}, html_options = {})
        @template.country_select(@object_name, method, objectify_options(options), @default_options.merge(html_options))
      end
    end

    module FormOptionsHelper
      def country_select(object, method, options = {}, html_options = {})
        Tags::CountrySelect.new(object, method, self, options, html_options).render
      end
    end

    module Tags
      class CountrySelect < Base
        def initialize(object_name, method_name, template_object, options, html_options)
          @html_options = html_options

          super(object_name, method_name, template_object, options)
        end

        def render
          select_content_tag(country_option_tags, @options, @html_options)
        end

        def country_option_tags
          option_tags_options = {
            :selected => @options.fetch(:selected) { value(@object) },
            :disabled => @options[:disabled]
          }

          if priority_countries.present?
            priority_countries_options = country_options_for(priority_countries)

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

        def country_options
          country_options_for(all_country_codes)
        end

        def all_country_codes
          codes = ISO3166::Country.all.map(&:last)

          if only_country_codes.present?
            codes & only_country_codes
          else
            codes
          end
        end

        def country_options_for(country_codes)
          I18n.with_locale(locale) do
            country_codes.map do |code|
              code = code.to_s.upcase
              country = ISO3166::Country.new(code)

              default_name = country.name
              localized_name = country.translations[I18n.locale.to_s]

              name = localized_name || default_name

              [name,code]
            end.sort
          end
        end

        def html_safe_newline
          "\n".html_safe
        end
      end
    end
  end
end
