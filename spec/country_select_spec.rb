require 'spec_helper'

require 'action_view'
require 'country_select'

module ActionView
  module Helpers

    describe CountrySelect do
      include TagHelper

      class Walrus
        attr_accessor :country_name
      end

      let(:walrus) { Walrus.new }

      let!(:template) { ActionView::Base.new }

      let(:select_tag) do
        "<select id=\"walrus_country_name\" name=\"walrus[country_name]\">"
      end

      let(:selected_us_option) do
        if defined?(Tags::Base)
          content_tag(:option, 'United States', :selected => :selected, :value => "United States")
        else
          "<option value=\"United States\" selected=\"selected\">United States</option>"
        end
      end

      let(:selected_iso_us_option) do
        if defined?(Tags::Base)
          content_tag(:option, 'United States', :selected => :selected, :value => 'us')
        else
          "<option value=\"us\" selected=\"selected\">United States</option>"
        end
      end

      let(:builder) do
        if defined?(Tags::Base)
          FormBuilder.new(:walrus, walrus, template, {})
        else
          FormBuilder.new(:walrus, walrus, template, {}, Proc.new { })
        end
      end

      context "iso codes disabled" do
        describe "#country_select" do
          let(:tag) { builder.country_select(:country_name) }

          it "creates a select tag" do
            tag.should include(select_tag)
          end

          it "creates option tags of the countries" do
            ::CountrySelect::COUNTRIES.each do |code,name|
              tag.should include(content_tag(:option, name, :value => name))
            end
          end

          it "selects the value of country_name" do
            walrus.country_name = 'United States'
            t = builder.country_select(:country_name)
            t.should include(selected_us_option)
          end
        end

        describe "#priority_countries" do
          let(:tag) { builder.country_select(:country_name, ['United States']) }

          it "puts the countries at the top" do
            tag.should include("#{select_tag}<option value=\"United States")
          end

          it "inserts a divider" do
            tag.should include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
          end

          it "does not mark two countries as selected" do
            walrus.country_name = "United States"
            str = <<-EOS.strip
              </option>\n<option value="United States" selected="selected">United States</option>
            EOS
            tag.should_not include(str)
          end
        end
      end

      context "iso codes enabled" do
        describe "#country_select" do
          let(:tag) { builder.country_select(:country_name, nil, :iso_codes => true) }

          it "creates a select tag" do
            tag.should include(select_tag)
          end

          it "creates option tags of the countries" do
            ::CountrySelect::COUNTRIES.each do |code,name|
              tag.should include(content_tag(:option, name, :value => code))
            end
          end

          it "selects the value of country_name" do
            walrus.country_name = 'us'
            t = builder.country_select(:country_name, nil, :iso_codes => true)
            t.should include(selected_iso_us_option)
          end
        end

        describe "#priority_countries" do
          let(:tag) { builder.country_select(:country_name, ['us'], :iso_codes => true) }

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
end
