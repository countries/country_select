require 'spec_helper'

require 'action_view'
require 'country_select'

module ActionView
  module Helpers

    describe CountrySelect do
      class Walrus
        attr_accessor :country_name
      end

      let(:walrus) { Walrus.new }

      let!(:template) { ActionView::Base.new }

      let(:select_tag) do
        "<select id=\"walrus_country_name\" name=\"walrus[country_name]\">"
      end

      let(:builder) do
        FormBuilder.new(:walrus, walrus, template, {}, Proc.new { })
      end

      describe "#country_select" do
        let(:tag) { builder.country_select(:country_name) }

        it "creates a select tag" do
          tag.should include(select_tag)
        end

        it "creates option tags of the countries" do
          ::CountrySelect::COUNTRIES.each do |code,name|
            name.gsub!(/'/,'&#x27;')
            tag.should include("<option value=\"#{code}\">#{name}</option>")
          end
        end

        it "selects the value of country_name" do
          walrus.country_name = 'us'
          t = builder.country_select(:country_name)
          t.should include("<option value=\"us\" selected=\"selected\">United States</option>")
        end
      end

      describe "#priority_countries" do
        let(:tag) { builder.country_select(:country_name, ['us']) }

        it "puts the countries at the top" do
          tag.should include("#{select_tag}<option value=\"us")
        end

        it "inserts a divider" do
          tag.should include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
        end

        it "does not mark two countries as selected" do
          walrus.country_name = "us"
          str = <<-EOS.strip
            </option>\n<option value="us" selected="selected">United States</option>
          EOS
          tag.should_not include(str)
        end
      end
    end
  end
end
