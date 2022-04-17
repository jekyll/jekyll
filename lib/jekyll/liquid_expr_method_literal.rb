# frozen_string_literal: true

module Liquid
  class Expression
    class MethodLiteral
      attr_reader :method_name, :to_s
      alias_method :to_liquid, :to_s

      def initialize(method_name, to_s)
        @method_name = method_name
        @to_s = to_s
      end
    end

    PATCHED_LITERALS = Liquid::Expression::LITERALS.dup.tap do |obj|
      obj["blank"] = MethodLiteral.new(:blank?, "").freeze
      obj["empty"] = MethodLiteral.new(:empty?, "").freeze
    end

    remove_const :LITERALS
    LITERALS = PATCHED_LITERALS.freeze

    remove_const :PATCHED_LITERALS
  end
end
