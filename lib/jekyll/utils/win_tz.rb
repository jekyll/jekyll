# frozen_string_literal: true

module Jekyll
  module Utils
    module WinTZ
      extend self

      # Public: Calculate the Timezone for Windows when the config file has a defined
      #         'timezone' key.
      #
      # timezone - the IANA Time Zone specified in "_config.yml"
      #
      # Returns a string that ultimately re-defines ENV["TZ"] in Windows
      def calculate(timezone)
        External.require_with_graceful_fail("tzinfo")
        tz = TZInfo::Timezone.get(timezone)
        difference = Time.now.to_i - tz.now.to_i
        #
        # POSIX style definition reverses the offset sign.
        #   e.g. Eastern Standard Time (EST) that is 5Hrs. to the 'west' of Prime Meridian
        #   is denoted as:
        #     EST+5 (or) EST+05:00
        # Reference: http://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html
        sign = difference < 0 ? "-" : "+"
        offset = sign == "-" ? "+" : "-" unless difference.zero?
        #
        # convert the difference (in seconds) to hours, as a rational number, and perform
        # a modulo operation on it.
        modulo = modulo_of(rational_hour(difference))
        #
        # Format the hour as a two-digit number.
        # Establish the minutes based on modulo expression.
        hh = format("%02d", absolute_hour(difference).ceil)
        mm = modulo.zero? ? "00" : "30"

        Jekyll.logger.debug "Timezone:", "#{timezone} #{offset}#{hh}:#{mm}"
        #
        # Note: The 3-letter-word below doesn't have a particular significance.
        "WTZ#{sign}#{hh}:#{mm}"
      end

      private

      # Private: Convert given seconds to an hour as a rational number.
      #
      # seconds - supplied as an integer, it is converted to a rational number.
      # 3600 - no. of seconds in an hour.
      #
      # Returns a rational number.
      def rational_hour(seconds)
        seconds.to_r / 3600
      end

      # Private: Convert given seconds to an hour as an absolute number.
      #
      # seconds - supplied as an integer, it is converted to its absolute.
      # 3600 - no. of seconds in an hour.
      #
      # Returns an integer.
      def absolute_hour(seconds)
        seconds.abs / 3600
      end

      # Private: Perform a modulo operation on a given fraction.
      #
      # fraction - supplied as a rational number, its numerator is divided
      #            by its denominator and the remainder returned.
      #
      # Returns an integer.
      def modulo_of(fraction)
        fraction.numerator % fraction.denominator
      end
    end
  end
end
