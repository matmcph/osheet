require 'enumeration'

module Osheet::Format

  class Number
    include Enumeration

    attr_accessor :decimal_places, :comma_separator
    enum :negative_numbers, [:black, :black_parenth, :red, :red_parenth]

    def initialize(opts={})
      self.decimal_places = opts[:decimal_places] || 0
      self.comma_separator = opts[:comma_separator] || false
      self.negative_numbers = opts[:negative_numbers] || :black
    end

    def type
      :number
    end

    def decimal_places=(value)
      if !value.kind_of?(::Fixnum) || value < 0
        raise ArgumentError, ":decimal_places must be a positive Fixnum."
      end
      @decimal_places = value
    end

    def comma_separator=(value)
      @comma_separator = !!value
    end

    def style
      negative_numbers_style
    end

    private

    def decimal_places_style
      "#{comma_separator_style}0#{'.'+'0'*@decimal_places if @decimal_places > 0}"
    end

    def comma_separator_style
      @comma_separator ? '#,##' : ''
    end

    def negative_numbers_style
      case @negative_numbers
      when :black
        decimal_places_style
      when :red
        "#{decimal_places_style};[Red]#{decimal_places_style}"
      when :black_parenth
        "#{decimal_places_style}_);\(#{decimal_places_style}\)"
      when :red_parenth
        "#{decimal_places_style}_);[Red]\(#{decimal_places_style}\)"
      end
    end

  end
end
