# frozen_string_literal: true

module Jekyll
  module Filters
    module DateFilters
      # Format a date in short format e.g. "27 Jan 2011".
      # Ordinal format is also supported, in both the UK
      # (e.g. "27th Jan 2011") and US ("e.g. Jan 27th, 2011") formats.
      # UK format is the default.
      #
      # date - the Time to format.
      # type - if "ordinal" the returned String will be in ordinal format
      # style - if "US" the returned String will be in US format.
      #         Otherwise it will be in UK format.
      #
      # Returns the formatting String.
      def date_to_string(date, type = nil, style = nil)
        stringify_date(date, "%b", type, style)
      end

      # Format a date in long format e.g. "27 January 2011".
      # Ordinal format is also supported, in both the UK
      # (e.g. "27th January 2011") and US ("e.g. January 27th, 2011") formats.
      # UK format is the default.
      #
      # date - the Time to format.
      # type - if "ordinal" the returned String will be in ordinal format
      # style - if "US" the returned String will be in US format.
      #         Otherwise it will be in UK format.
      #
      # Returns the formatted String.
      def date_to_long_string(date, type = nil, style = nil)
        stringify_date(date, "%B", type, style)
      end

      # Format a date for use in XML.
      #
      # date - The Time to format.
      #
      # Examples
      #
      #   date_to_xmlschema(Time.now)
      #   # => "2011-04-24T20:34:46+08:00"
      #
      # Returns the formatted String.
      def date_to_xmlschema(date)
        return date if date.to_s.empty?
        time(date).xmlschema
      end

      # Format a date according to RFC-822
      #
      # date - The Time to format.
      #
      # Examples
      #
      #   date_to_rfc822(Time.now)
      #   # => "Sun, 24 Apr 2011 12:34:46 +0000"
      #
      # Returns the formatted String.
      def date_to_rfc822(date)
        return date if date.to_s.empty?
        time(date).rfc822
      end

      private
      # month_type: Notations that evaluate to 'Month' via `Time#strftime` ("%b", "%B")
      # type: nil (default) or "ordinal"
      # style: nil (default) or "US"
      #
      # Returns a stringified date or the empty input.
      def stringify_date(date, month_type, type = nil, style = nil)
        return date if date.to_s.empty?
        time = time(date)
        if type == "ordinal"
          day = time.day
          ordinal_day = "#{day}#{ordinal(day)}"
          return time.strftime("#{month_type} #{ordinal_day}, %Y") if style == "US"
          return time.strftime("#{ordinal_day} #{month_type} %Y")
        end
        time.strftime("%d #{month_type} %Y")
      end

      private
      def ordinal(number)
        return "th" if (11..13).cover?(number)

        case number % 10
        when 1 then "st"
        when 2 then "nd"
        when 3 then "rd"
        else "th"
        end
      end

      private
      def time(input)
        date = Liquid::Utils.to_date(input)
        unless date.respond_to?(:to_time)
          raise Errors::InvalidDateError,
            "Invalid Date: '#{input.inspect}' is not a valid datetime."
        end
        date.to_time.dup.localtime
      end
    end
  end
end
