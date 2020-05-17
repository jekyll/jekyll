# frozen_string_literal: true

module Jekyll
  module Drops
    class PageDrop < Drop
      extend Forwardable

      mutable false

      delegate_methods :content, :dir, :name, :path, :url
      private delegate_method_as :data, :fallback_data

      data_delegator "title"
    end
  end
end
