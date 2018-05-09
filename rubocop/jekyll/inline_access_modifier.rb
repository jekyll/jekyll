# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module Jekyll
      class InlineAccessModifier < Cop
        MSG = "`%<access_modifier>s` should be inlined " \
          "in front of method definitions for clarity.".freeze

        def on_send(node)
          return unless node.access_modifier?
          return if access_modifier_is_inlined?(node)

          add_offense(node)
        end

        private def access_modifier_is_inlined?(node)
          node.arguments.any?
        end

        private def message(node)
          format(MSG, :access_modifier => node.loc.selector.source)
        end
      end
    end
  end
end
