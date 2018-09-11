# frozen_string_literal: true

module Jekyll
  module Drops
    class LocaleDrop < Drop
      extend Forwardable

      mutable false
      private def_delegator :@obj, :data, :fallback_data
    end
  end
end
