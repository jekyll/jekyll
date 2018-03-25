# frozen_string_literal: true

module Jekyll
  module Utils
    module MarshalWithoutDefaultProc

      private
      def marshal_dump
        data_clone = data.clone
        data_clone.default = nil # clear the default_proc
        attr_hash = (instance_variables - [:@data]).map do |attr|
          { attr => instance_variable_get(attr) }
        end
        attr_hash.push(:@data => data_clone).inject(:merge)
      end

      private
      def marshal_load(marshalled_data)
        marshalled_data.each { |key, value| instance_variable_set(key, value) }
        set_default_proc
      end
    end
  end
end
