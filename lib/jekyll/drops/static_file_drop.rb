# frozen_string_literal: true

module Jekyll
  module Drops
    class StaticFileDrop < Drop
      extend Forwardable
      delegate_methods   :name, :extname, :modified_time, :basename
      delegate_method_as :relative_path, :path
      delegate_method_as :type, :collection

      private delegate_method_as :data, :fallback_data
    end
  end
end
