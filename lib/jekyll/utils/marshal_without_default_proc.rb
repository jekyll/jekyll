# frozen_string_literal: true

module Jekyll
  module Utils
    module MarshalWithoutDefaultProc

      def marshal_dump
        data.default_proc = nil
        attr_hash = instance_variables.map do |attr|
          { attr => instance_variable_get(attr) }
        end.inject(:merge!)
        attr_hash.merge!(:@data => attr_hash[:@data].clone)
      ensure
        reset_default_proc
      end

      def marshal_load(marshalled_data)
        marshalled_data.each { |key, value| instance_variable_set(key, value) }
        reset_default_proc
      end

      private
      def reset_default_proc
        return unless self.respond_to?(:data) && data
        data.default_proc = data_default_proc
      end
    end
  end
end
