module ActionView
  module Helpers
    class FormBuilder
      def country_select(method, priority_or_options = {}, options = {}, html_options = {})
        if Hash === priority_or_options
          html_options = options
          options = priority_or_options
        else
          options[:priority_countries] = priority_or_options
        end

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

        if self.respond_to?(:select_content_tag)
          select_content_tag(country_option_tags, @options, @html_options)
        else
          html_options = @html_options.stringify_keys
          add_default_name_and_id(html_options)
          options[:include_blank] ||= true unless options[:prompt] || select_not_required?(html_options)
          value = options.fetch(:selected) { value(object) }
          content_tag(:select, add_options(country_option_tags, options, value), html_options)
        end
      end

      def value(object)
        object.send @method_name if object
      end

      def select_not_required?(html_options)
        !html_options["required"] || html_options["multiple"] || html_options["size"].to_i > 1
      end

      def add_options(option_tags, options, value=nil)
        if options[:include_blank]
          option_tags = content_tag_string('option', options[:include_blank].kind_of?(String) ? options[:include_blank] : nil, :value => '') + "\n" + option_tags
        end

        if value.blank? && options[:prompt]
          option_tags = content_tag_string('option', prompt_text(options[:prompt]), :value => '') + "\n" + option_tags
        end
        option_tags
      end

      def prompt_text(text)
        text.kind_of?(String) ? text : I18n.translate('helpers.select.prompt', default: 'Please select')
      end
    end
  end
end
