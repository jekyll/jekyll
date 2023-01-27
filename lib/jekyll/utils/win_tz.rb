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
      def calculate(timezone, now = Time.now)
        External.require_with_graceful_fail("tzinfo") unless defined?(TZInfo)
        tz = TZInfo::Timezone.get(timezone)

        #
        # Use period_for_utc and utc_total_offset instead of
        # period_for and observed_utc_offset for compatibility with tzinfo v1.
        offset = tz.period_for_utc(now.getutc).utc_total_offset

        #
        # POSIX style definition reverses the offset sign.
        #   e.g. Eastern Standard Time (EST) that is 5Hrs. to the 'west' of Prime Meridian
        #   is denoted as:
        #     EST+5 (or) EST+05:00
        # Reference: https://www.gnu.org/software/libc/manual/html_node/TZ-Variable.html
        sign = offset.positive? ? "-" : "+"

        rational_hours = offset.abs.to_r / 3600
        hours = rational_hours.to_i
        minutes = ((rational_hours - hours) * 60).to_i

        #
        # Format the hours and minutes as two-digit numbers.
        time = format("%<hours>02d:%<minutes>02d", :hours => hours, :minutes => minutes)

        Jekyll.logger.debug "Timezone:", "#{timezone} #{sign}#{time}"
        #
        # Note: The 3-letter-word below doesn't have a particular significance.
        "WTZ#{sign}#{time}"
      end
    end
  end
end
