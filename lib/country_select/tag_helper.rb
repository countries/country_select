# frozen_string_literal: true

module CountrySelect
  class CountryNotFoundError < StandardError; end

  module TagHelper
    unless respond_to?(:options_for_select)
      include ActionView::Helpers::FormOptionsHelper
      include ActionView::Helpers::Tags::SelectRenderer if defined?(ActionView::Helpers::Tags::SelectRenderer)
    end

    def country_option_tags
      # In Rails 5.2+, `value` accepts no arguments and must also be called
      # with parens to avoid the local variable of the same name
      # https://github.com/rails/rails/pull/29791
      selected_option = @options.fetch(:selected) do
        if self.method(:value).arity.zero?
          value()
        else
          value(@object)
        end
      end

      option_tags_options = {
        selected: selected_option,
        disabled: @options[:disabled]
      }

      if priority_countries.present?
        options_for_select_with_priority_countries(country_options, option_tags_options)
      else
        options_for_select(country_options, option_tags_options)
      end
    end

    private

    def locale
      @options.fetch(:locale, ::CountrySelect::DEFAULTS[:locale])
    end

    def priority_countries
      @options.fetch(:priority_countries, ::CountrySelect::DEFAULTS[:priority_countries])
    end

    def only_country_codes
      @options.fetch(:only, ::CountrySelect::DEFAULTS[:only])
    end

    def except_country_codes
      @options.fetch(:except, ::CountrySelect::DEFAULTS[:except])
    end

    def format
      @options.fetch(:format, ::CountrySelect::DEFAULTS[:format])
    end

    def icons
      @options.fetch(:icons, ::CountrySelect::DEFAULTS[:icons])
    end

    def country_options
      codes = ISO3166::Country.codes

      if only_country_codes.present?
        codes = only_country_codes & codes
        sort = @options.fetch(:sort_provided, ::CountrySelect::DEFAULTS[:sort_provided])
      else
        codes -= except_country_codes if except_country_codes.present?
        sort = true
      end

      country_options_for(codes, sorted: sort)
    end

    def country_options_for(country_codes, sorted: true)
      I18n.with_locale(locale) do
        country_list = country_codes.map { |code_or_name| get_formatted_country(code_or_name) }

        country_list.sort_by! { |name, _|
          transliterated_name = I18n.transliterate(name.to_s)
          if transliterated_name.include?('?') # For languages that cannot be transliterated (e.g. languages with non-Latin scripts)
            [name, name] # If transliteration fails, duplicate the original name to maintain a consistent two-element array structure.
          else
            [transliterated_name, name]
          end
        } if sorted
        country_list = append_icons(country_list) if icons
        country_list
      end
    end

    def append_icons(country_list)
      country_list.map do |name, code|
        ["#{name} #{country_icon(code)}", code]
      end
    end

    def options_for_select_with_priority_countries(country_options, tags_options)
      sorted = @options.fetch(:sort_provided, ::CountrySelect::DEFAULTS[:sort_provided])
      priority_countries_options = country_options_for(priority_countries, sorted:)

      option_tags = priority_options_for_select(priority_countries_options, tags_options)

      tags_options[:selected] = Array(tags_options[:selected]).delete_if do |selected|
        priority_countries_options.map(&:second).include?(selected)
      end

      option_tags += "\n".html_safe + options_for_select(country_options, tags_options)

      option_tags
    end

    def priority_options_for_select(priority_countries_options, tags_options)
      options_for_select(priority_countries_options, tags_options) + "\n<hr>".html_safe
    end

    def get_formatted_country(code_or_name)
      country = ISO3166::Country.new(code_or_name) ||
                ISO3166::Country.find_country_by_any_name(code_or_name)

      raise(CountryNotFoundError, "Could not find Country with string '#{code_or_name}'") unless country.present?

      code = country.alpha2
      formatted_country = ::CountrySelect::FORMATS[format].call(country)

      if formatted_country.is_a?(Array)
        formatted_country
      else
        [formatted_country, code]
      end
    end

    def country_icon(code)
      {
        ad: "🇦🇩", ae: "🇦🇪", af: "🇦🇫", ag: "🇦🇬", ai: "🇦🇮", al: "🇦🇱", am: "🇦🇲", ao: "🇦🇴",
        aq: "🇦🇶", ar: "🇦🇷", as: "🇦🇸", at: "🇦🇹", au: "🇦🇺", aw: "🇦🇼", ax: "🇦🇽", az: "🇦🇿",
        ba: "🇧🇦", bb: "🇧🇧", bd: "🇧🇩", be: "🇧🇪", bf: "🇧🇫", bg: "🇧🇬", bh: "🇧🇭", bi: "🇧🇮",
        bj: "🇧🇯", bl: "🇧🇱", bm: "🇧🇲", bn: "🇧🇳", bo: "🇧🇴", bq: "🇧🇶", br: "🇧🇷", bs: "🇧🇸",
        bt: "🇧🇹", bv: "🇧🇻", bw: "🇧🇼", by: "🇧🇾", bz: "🇧🇿", ca: "🇨🇦", cc: "🇨🇨", cd: "🇨🇩",
        cf: "🇨🇫", cg: "🇨🇬", ch: "🇨🇭", ci: "🇨🇮", ck: "🇨🇰", cl: "🇨🇱", cm: "🇨🇲", cn: "🇨🇳",
        co: "🇨🇴", cr: "🇨🇷", cu: "🇨🇺", cv: "🇨🇻", cw: "🇨🇼", cx: "🇨🇽", cy: "🇨🇾", cz: "🇨🇿",
        de: "🇩🇪", dj: "🇩🇯", dk: "🇩🇰", dm: "🇩🇲", do: "🇩🇴", dz: "🇩🇿", ec: "🇪🇨", ee: "🇪🇪",
        eg: "🇪🇬", eh: "🇪🇭", er: "🇪🇷", es: "🇪🇸", et: "🇪🇹", fi: "🇫🇮", fj: "🇫🇯", fk: "🇫🇰",
        fm: "🇫🇲", fo: "🇫🇴", fr: "🇫🇷", ga: "🇬🇦", gb: "🇬🇧", gd: "🇬🇩", ge: "🇬🇪", gf: "🇬🇫",
        gg: "🇬🇬", gh: "🇬🇭", gi: "🇬🇮", gl: "🇬🇱", gm: "🇬🇲", gn: "🇬🇳", gp: "🇬🇵", gq: "🇬🇶",
        gr: "🇬🇷", gs: "🇬🇸", gt: "🇬🇹", gu: "🇬🇺", gw: "🇬🇼", gy: "🇬🇾", hk: "🇭🇰", hm: "🇭🇲",
        hn: "🇭🇳", hr: "🇭🇷", ht: "🇭🇹", hu: "🇭🇺", id: "🇮🇩", ie: "🇮🇪", il: "🇮🇱", im: "🇮🇲",
        in: "🇮🇳", io: "🇮🇴", iq: "🇮🇶", ir: "🇮🇷", is: "🇮🇸", it: "🇮🇹", je: "🇯🇪", jm: "🇯🇲",
        jo: "🇯🇴", jp: "🇯🇵", ke: "🇰🇪", kg: "🇰🇬", kh: "🇰🇭", ki: "🇰🇮", km: "🇰🇲", kn: "🇰🇳",
        kp: "🇰🇵", kr: "🇰🇷", kw: "🇰🇼", ky: "🇰🇾", kz: "🇰🇿", la: "🇱🇦", lb: "🇱🇧", lc: "🇱🇨",
        li: "🇱🇮", lk: "🇱🇰", lr: "🇱🇷", ls: "🇱🇸", lt: "🇱🇹", lu: "🇱🇺", lv: "🇱🇻", ly: "🇱🇾",
        ma: "🇲🇦", mc: "🇲🇨", md: "🇲🇩", me: "🇲🇪", mf: "🇲🇫", mg: "🇲🇬", mh: "🇲🇭", mk: "🇲🇰",
        ml: "🇲🇱", mm: "🇲🇲", mn: "🇲🇳", mo: "🇲🇴", mp: "🇲🇵", mq: "🇲🇶", mr: "🇲🇷", ms: "🇲🇸",
        mt: "🇲🇹", mu: "🇲🇺", mv: "🇲🇻", mw: "🇲🇼", mx: "🇲🇽", my: "🇲🇾", mz: "🇲🇿", na: "🇳🇦",
        nc: "🇳🇨", ne: "🇳🇪", nf: "🇳🇫", ng: "🇳🇬", ni: "🇳🇮", nl: "🇳🇱", no: "🇳🇴", np: "🇳🇵",
        nr: "🇳🇷", nu: "🇳🇺", nz: "🇳🇿", om: "🇴🇲", pa: "🇵🇦", pe: "🇵🇪", pf: "🇵🇫", pg: "🇵🇬",
        ph: "🇵🇭", pk: "🇵🇰", pl: "🇵🇱", pm: "🇵🇲", pn: "🇵🇳", pr: "🇵🇷", ps: "🇵🇸", pt: "🇵🇹",
        pw: "🇵🇼", py: "🇵🇾", qa: "🇶🇦", re: "🇷🇪", ro: "🇷🇴", rs: "🇷🇸", ru: "🇷🇺", rw: "🇷🇼",
        sa: "🇸🇦", sb: "🇸🇧", sc: "🇸🇨", sd: "🇸🇩", se: "🇸🇪", sg: "🇸🇬", sh: "🇸🇭", si: "🇸🇮",
        sj: "🇸🇯", sk: "🇸🇰", sl: "🇸🇱", sm: "🇸🇲", sn: "🇸🇳", so: "🇸🇴", sr: "🇸🇷", ss: "🇸🇸",
        st: "🇸🇹", sv: "🇸🇻", sx: "🇸🇽", sy: "🇸🇾", sz: "🇸🇿", tc: "🇹🇨", td: "🇹🇩", tf: "🇹🇫",
        tg: "🇹🇬", th: "🇹🇭", tj: "🇹🇯", tk: "🇹🇰", tl: "🇹🇱", tm: "🇹🇲", tn: "🇹🇳", to: "🇹🇴",
        tr: "🇹🇷", tt: "🇹🇹", tv: "🇹🇻", tw: "🇹🇼", tz: "🇹🇿", ua: "🇺🇦", ug: "🇺🇬", um: "🇺🇲",
        us: "🇺🇸", uy: "🇺🇾", uz: "🇺🇿", va: "🇻🇦", vc: "🇻🇨", ve: "🇻🇪", vg: "🇻🇬", vi: "🇻🇮",
        vn: "🇻🇳", vu: "🇻🇺", wf: "🇼🇫", ws: "🇼🇸", xk: "🇽🇰", ye: "🇾🇪", yt: "🇾🇹", za: "🇿🇦",
        zm: "🇿🇲", zw: "🇿🇼"
      }[code.downcase.to_sym]
    end
  end
end
