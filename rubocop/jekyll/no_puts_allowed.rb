# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module Jekyll
      class NoPutsAllowed < Cop
        MSG = "Avoid using `puts` to print things. Use `Jekyll.logger` instead.".freeze

        def_node_search :puts_called?, <<-PATTERN
        (send nil? :puts _)
        PATTERN

        def on_send(node)
          if puts_called?(node)
            add_offense(node, :location => :selector)
          end
        end
      end
    end
  end
end
