module Jekyll
  module Traits
    module Dated

      CLEANSED_FILENAME_MATCHER = /\/(\d+-\d+-\d+)-(.*)$/.freeze
      DATE_FILENAME_MATCHER = /^(.+\/)*(\d+-\d+-\d+)-(.*)(\.[^.]+)$/.freeze

      @@date_matched_cache = {}
      @@date_cleansed_matched_cache = {}

      def self.matched_dated_filename(path)
        @@date_matched_cache[path] ||= path.match(DATE_FILENAME_MATCHER)
      end

      def self.dated_filename?(path)
        !!(matched_dated_filename(path))
      end

      def self.matched_dated_cleaned_filename(path)
        @@date_cleansed_matched_cache[path] ||= path.match(CLEANSED_FILENAME_MATCHER)
      end

      def self.dated_cleansed_filename?(path)
        !!(matched_dated_cleaned_filename(path))
      end

      def self.url_template(permalink_style)
        case permalink_style
        when :pretty
          "/:categories/:year/:month/:day/:title/"
        when :none
          "/:categories/:title.html"
        when :date
          "/:categories/:year/:month/:day/:title.html"
        when :ordinal
          "/:categories/:year/:y_day/:title.html"
        else
          permalink_style.to_s
        end
      end

      def date
        @date ||= if data.key?('date')
          Utils.parse_date(data["date"].to_s, "Post '#{relative_path}' does not have a valid date in the YAML front matter.")
        elsif Dated::dated_filename?(relative_path)
          matched = Dated.matched_dated_filename(relative_path)
          Utils.parse_date(
            matched[2],
            "Post '#{relative_path}' does not have a valid date in the filename."
          )
        else
          false
        end
      end

      def date_url_placeholders
        if date
          {
            # Date stuff.
            :year        => date.strftime("%Y"),
            :month       => date.strftime("%m"),
            :day         => date.strftime("%d"),
            :hour        => date.strftime("%H"),
            :minute      => date.strftime("%M"),
            :second      => date.strftime("%S"),
            :i_day       => date.strftime("%-d"),
            :i_month     => date.strftime("%-m"),
            :short_month => date.strftime("%b"),
            :short_year  => date.strftime("%y"),
            :y_day       => date.strftime("%j"),
          }
        else
          Hash.new
        end
      end

    end
  end
end
