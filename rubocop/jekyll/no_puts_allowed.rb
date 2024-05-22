# frozen_string_literal: true

module RuboCop
  module Cop
    module Jekyll
      class NoPutsAllowed < Base
        MSG = "Avoid using `puts` to print things. Use `Jekyll.logger` instead."
        RESTRICT_ON_SEND = %i[puts].freeze

        def_node_search :puts_called?, <<-PATTERN
          (send nil? :puts _)
        PATTERN

        def on_send(node)
          if puts_called?(node)
            add_offense(node.loc.selector)
          end
        end
      end
    end
  end
end
