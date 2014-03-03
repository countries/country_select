module ActionView
  module Helpers
    class FormBuilder
      def country_select(method, options = {}, html_options = {})
        @template.country_select(@object_name, method, objectify_options(options), @default_options.merge(html_options))
      end
    end

    module FormOptionsHelper
      def country_select(object, method, options = {}, html_options = {})
        CountrySelect.new(object, method, self, options.delete(:object)).render(options, html_options)
      end
    end

    class CountrySelect < InstanceTag
      include ::CountrySelect::TagHelper

      def render(options, html_options)
        @options = options
        @html_options = html_options

        select_content_tag(country_option_tags, @options, @html_options)
      end
    end
  end
end
