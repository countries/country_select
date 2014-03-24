# encoding: utf-8

require 'spec_helper'

require 'action_view'
require 'country_select'

describe "CountrySelect" do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormOptionsHelper

  class Walrus
    attr_accessor :country_code
  end

  let(:walrus) { Walrus.new }
  let!(:template) { ActionView::Base.new }

  let(:builder) do
    if defined?(ActionView::Helpers::Tags::Base)
      ActionView::Helpers::FormBuilder.new(:walrus, walrus, template, {})
    else
      ActionView::Helpers::FormBuilder.new(:walrus, walrus, template, {}, Proc.new { })
    end
  end

  let(:select_tag) do
    <<-EOS.chomp.strip
      <select id="walrus_country_code" name="walrus[country_code]">
    EOS
  end

  it "selects the value of country_code" do
    tag = options_for_select([['United States of America', 'US']], 'US')

    walrus.country_code = 'US'
    t = builder.country_select(:country_code)
    expect(t).to include(tag)
  end

  it "uses the locale specified by I18n.locale" do
    tag = options_for_select([['Estados Unidos', 'US']], 'US')

    walrus.country_code = 'US'
    original_locale = I18n.locale
    begin
      I18n.locale = :es
      t = builder.country_select(:country_code)
      expect(t).to include(tag)
    ensure
      I18n.locale = original_locale
    end
  end

  it "accepts a locale option" do
    tag = options_for_select([['États-Unis', 'US']], 'US')

    walrus.country_code = 'US'
    t = builder.country_select(:country_code, locale: :fr)
    expect(t).to include(tag)
  end

  it "accepts priority countries" do
    tag = options_for_select(
      [
        ['Latvia','LV'],
        ['United States of America','US'],
        ['Denmark', 'DK'],
        ['-'*15,'-'*15]
      ],
      selected: 'US',
      disabled: '-'*15
    )

    walrus.country_code = 'US'
    t = builder.country_select(:country_code, priority_countries: ['LV','US','DK'])
    expect(t).to include(tag)
  end

  it "selects only the first matching option" do
    tag = options_for_select([["United States of America", "US"],["Uruguay", "UY"]], "US")
    walrus.country_code = 'US'
    t = builder.country_select(:country_code, priority_countries: ['LV','US'])
    expect(t).to_not include(tag)
  end

  it "displays only the chosen countries" do
    options = [["Denmark", "DK"],["Germany", "DE"]]
    tag = builder.select(:country_code, options)
    walrus.country_code = 'US'
    t = builder.country_select(:country_code, only: ['DK','DE'])
    expect(t).to eql(tag)
  end
end
