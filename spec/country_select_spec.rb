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
          content_tag(:option, 'United States of America', :selected => :selected, :value => "United States of America")
        else
          "<option value=\"United States of America\" selected=\"selected\">United States of America</option>"
        end
      end

      let(:selected_iso_us_option) do
        if defined?(Tags::Base)
          content_tag(:option, 'United States of America', :selected => :selected, :value => 'US')
        else
          "<option value=\"US\" selected=\"selected\">United States of America</option>"
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
            ::CountrySelect::countries("en").each do |code,name|
              tag.should include(content_tag(:option, name, :value => name))
            end
          end

          it "selects the value of country_name" do
            walrus.country_name = 'United States of America'
            t = builder.country_select(:country_name)
            t.should include(selected_us_option)
          end
        end

        describe "#priority_countries" do
          let(:tag) { builder.country_select(:country_name, ['United States of America']) }

          it "puts the countries at the top" do
            tag.should include("#{select_tag}<option value=\"United States of America")
          end

          it "inserts a divider" do
            tag.should include(">United States of America</option><option value=\"\" disabled=\"disabled\">-------------</option>")
          end

          it "does not mark two countries as selected" do
            walrus.country_name = "United States of America"
            str = <<-EOS.strip
              </option>\n<option value="United States of America" selected="selected">United States of America</option>
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
            ::CountrySelect::countries("en").each do |code,name|
              tag.should include(content_tag(:option, name, :value => code))
            end
          end

          it "selects the value of country_name" do
            walrus.country_name = 'US'
            t = builder.country_select(:country_name, nil, :iso_codes => true)
            t.should include(selected_iso_us_option)
          end
        end

        describe "#country_select with global option" do
          before do
            ::CountrySelect.use_iso_codes = true
          end

          after do
            ::CountrySelect.use_iso_codes = false
          end

          let(:tag) { builder.country_select(:country_name, nil) }

          it "creates option tags of the countries" do
            ::CountrySelect::countries("en").each do |code,name|
              tag.should include(content_tag(:option, name, :value => code))
            end
          end

          it "selects the value of country_name" do
            walrus.country_name = 'US'
            t = builder.country_select(:country_name)
            t.should include(selected_iso_us_option)
          end
        end

        describe "#priority_countries" do
          let(:tag) { builder.country_select(:country_name, ['US'], :iso_codes => true) }

          it "puts the countries at the top" do
            tag.should include("#{select_tag}<option value=\"US")
          end

          it "inserts a divider" do
            tag.should include(">United States of America</option><option value=\"\" disabled=\"disabled\">-------------</option>")
          end

          it "does not mark two countries as selected" do
            walrus.country_name = "US"
            str = <<-EOS.strip
              </option>\n<option value="US" selected="selected">United States of America</option>
            EOS
            tag.should_not include(str)
          end
        end
      end
      context "different language selected" do
        describe "'es' selected as the instance language"
          let(:tag) { builder.country_select(:country_name, ['US'], {:iso_codes => true, :locale => 'es'}) }

          it "displays spanish names" do
            tag.should include(">Estados Unidos</option><option value=\"\" disabled=\"disabled\">-------------</option>")
          end
        end

        describe "localization selected with global option" do
          before do
            ::CountrySelect.locale = 'es'
          end

          after do
            ::CountrySelect.locale = 'en'
          end

          let(:tag) { builder.country_select(:country_name, ['US'], :iso_codes => true) }

          it "displays spanish names" do
            tag.should include(">Estados Unidos</option><option value=\"\" disabled=\"disabled\">-------------</option>")
          end
        end
      end
  end
end
