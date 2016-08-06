# encoding: UTF-8

module Jekyll
  module Drops
    class DataDrop < Drop
      mutable false

      # Created a nested hash of data files namespaced by sub directory
      def fallback_data
        @fallback_data ||= begin
          # Create a new, emtpy hash for any key that doesn't exist
          hash = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }

          # Propegate the hash with our data files
          @obj.docs.each do |doc|
            subhash = doc.subdirs.inject(hash, :[])
            slug = doc.basename_without_ext.gsub(%r![^\w\s-]+!, "")
              .gsub(%r!(^|\b\s)\s+($|\s?\b)!, '\\1\\2')
              .gsub(%r!\s+!, "_")
            subhash[slug] = doc.data
          end

          hash
        end
      end
    end
  end
end
