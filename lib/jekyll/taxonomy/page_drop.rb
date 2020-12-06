# frozen_string_literal: true

module Jekyll
  module Taxonomy
    class PageDrop < Drops::Drop
      mutable false

      delegate_method_as :relative_path, :path
      private delegate_method_as :data, :fallback_data

      delegate_methods :content, :relative_path, :url, :docs
    end
  end
end
