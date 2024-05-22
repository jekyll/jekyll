# frozen_string_literal: true

module RuboCop
  module Cop
    module Jekyll
      class NoPAllowed < Base
        MSG = "Avoid using `p` to print things. Use `Jekyll.logger` instead."
        RESTRICT_ON_SEND = %i[p].freeze

        def_node_search :p_called?, <<-PATTERN
          (send _ :p _)
        PATTERN

        def on_send(node)
          if p_called?(node)
            add_offense(node.loc.selector)
          end
        end
      end
    end
  end
end
