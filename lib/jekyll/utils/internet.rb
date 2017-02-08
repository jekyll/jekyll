module Jekyll
  module Utils
    module Internet

      # Public: Determine whether the present device has a connection to
      # the Internet. This allows plugin writers which require the outside
      # world to have a neat fallback mechanism for offline building.
      #
      # Example:
      #   if Internet.connected?
      #     Typhoeus.get("https://pages.github.com/versions.json")
      #   else
      #     Jekyll.logger.warn "Warning:", "Version check has been disabled."
      #     Jekyll.logger.warn "", "Connect to the Internet to enable it."
      #     nil
      #   end
      #
      # Returns true if a DNS call can successfully be made, or false if not.
      module_function
      def connected?
        !dns("google.com").nil?
      end

      private
      def dns(domain)
        Net::DNS.new do |resolver|
          resolver.get_address(domain)
        end
      rescue
        nil
      end

    end
  end
end
