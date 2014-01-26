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
          content_tag(:option, 'United States', :selected => :selected, :value => 'US')
        else
          "<option value=\"US\" selected=\"selected\">United States</option>"
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

        context "with priority_countries" do
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

          describe "#only_priority_countries" do
            let(:tag) { builder.country_select(:country_name, ['United States'], {:only_priority_countries => true}) }

            it "puts the countries at the top" do
              tag.should include("#{select_tag}<option value=\"United States")
            end

            it "does not inserts a divider" do
              tag.should_not include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
            end

            it "does not add the rest of the countries" do
              select_with_only_priority_countries = <<-EOS.strip
                <select id="walrus_country_name" name="walrus[country_name]"><option value="United States">United States</option></select>
              EOS
              tag.should include(select_with_only_priority_countries)
              tag.length.should equal(select_with_only_priority_countries.length)
            end
          end
        end

        context "without priority_countries" do
          describe "#only_priority_countries has no effect" do
            let(:tag) { builder.country_select(:country_name, {:only_priority_countries => true}) }

            it "does not put the countries at the top" do
              tag.should_not include("#{select_tag}<option value=\"United States")
            end

            it "does not inserts a divider" do
              tag.should_not include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
            end

            it "does add the rest of the countries" do
              select_with_only_priority_countries = <<-EOS.strip
                <select id="walrus_country_name" name="walrus[country_name]"><option value="United States">United States</option></select>
              EOS
              tag.should_not include(select_with_only_priority_countries)
              tag.length.should be > select_with_only_priority_countries.length
            end
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
            ::CountrySelect::COUNTRIES.each do |code,name|
              tag.should include(content_tag(:option, name, :value => code))
            end
          end

          it "selects the value of country_name" do
            walrus.country_name = 'US'
            t = builder.country_select(:country_name)
            t.should include(selected_iso_us_option)
          end
        end

        context "with priority_countries" do
          describe "#priority_countries" do
            let(:tag) { builder.country_select(:country_name, ['US'], :iso_codes => true) }

            it "puts the countries at the top" do
              tag.should include("#{select_tag}<option value=\"US")
            end

            it "inserts a divider" do
              tag.should include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
            end

            it "does not mark two countries as selected" do
              walrus.country_name = "US"
              str = <<-EOS.strip
                </option>\n<option value="US" selected="selected">United States</option>
              EOS
              tag.should_not include(str)
            end
          end

          describe "#only_priority_countries" do
            let(:tag) { builder.country_select(:country_name, ['US'], {:iso_codes => true, :only_priority_countries => true}) }

            it "puts the countries at the top" do
              tag.should include("#{select_tag}<option value=\"US")
            end

            it "does not inserts a divider" do
              tag.should_not include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
            end

            it "does not add the rest of the countries" do
              select_with_only_priority_countries = <<-EOS.strip
                <select id="walrus_country_name" name="walrus[country_name]"><option value="US">United States</option></select>
              EOS
              tag.should include(select_with_only_priority_countries)
              tag.length.should equal(select_with_only_priority_countries.length)
            end
          end
        end

        context "without priority_countries" do
          describe "#only_priority_countries has no effect" do
            let(:tag) { builder.country_select(:country_name, {:iso_codes => true, :only_priority_countries => true}) }

            it "does not put the countries at the top" do
              tag.should_not include("#{select_tag}<option value=\"US")
            end

            it "does not inserts a divider" do
              tag.should_not include(">United States</option><option value=\"\" disabled=\"disabled\">-------------</option>")
            end

            it "does add the rest of the countries" do
              select_with_only_priority_countries = <<-EOS.strip
                <select id="walrus_country_name" name="walrus[country_name]"><option value="US">United States</option></select>
              EOS
              tag.should_not include(select_with_only_priority_countries)
              tag.length.should be > select_with_only_priority_countries.length
            end
          end
        end
      end
    end
  end
end
