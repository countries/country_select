require 'spec_helper'

require 'action_view'
require 'country_select'

module ActionView
  module Helpers

    describe CountrySelect do
      include TagHelper

      class Walrus
        attr_accessor :country_code
      end

      let(:walrus) { Walrus.new }

      let!(:template) { ActionView::Base.new }

      let(:select_tag) do
        "<select id=\"walrus_country_code\" name=\"walrus[country_code]\">"
      end

      let(:selected_us_option) do
        content_tag(:option, 'United States of America', selected: :selected, value: "US")
      end

      let(:builder) do
        FormBuilder.new(:walrus, walrus, template, {})
      end

      it "selects the value of country_code" do
        walrus.country_code = 'US'
        t = builder.country_select(:country_code)
        t.should include(selected_us_option)
      end

      describe "#priority_countries" do
        let(:tag) { builder.country_select(:country_code, ['US']) }

        it "puts the countries at the top" do
          tag.should include("#{select_tag}<option value=\"US")
        end

        it "inserts a divider" do
          tag.should include(">United States of America</option><option value=\"\" disabled=\"disabled\">-------------</option>")
        end

        it "does not mark two countries as selected" do
          walrus.country_code = "US"
          str = <<-EOS.strip
              </option>\n<option value="US" selected="selected">United States</option>
          EOS
          tag.should_not include(str)
        end
      end

      context "different language selected" do
        describe "'es' selected as the instance language" do
          let(:tag) { builder.country_select(:country_code, ['US'], locale: 'es') }

          it "displays spanish names" do
            tag.should include(">Estados Unidos</option><option value=\"\" disabled=\"disabled\">-------------</option>")
          end
        end
      end
    end

  end
end
