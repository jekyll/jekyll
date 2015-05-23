module Jekyll
  class Classification
    attr_accessor :collection, :label, :metadata

    # FIXME: Document this
    # Create a new Classification.
    #
    # label    -
    # metadata -
    #
    # Returns nothing.
    def initialize(collection, label, metadata = {})
      @collection = collection
      @label      = label
      @metadata   = metadata
    end

    # Fetch the Documents in this collection filtered by the indexed classification.
    # Defaults to an empty array if no documents have been read in.
    #
    # Returns an array of Jekyll::Document objects.
    def docs(index)
      collection.docs.select do |doc|
        singular_data = Array(doc.data[::ActiveSupport::Inflector.singularize(label)])
        plural_data   = Array(doc.data[label])
        singular_data.include?(index) || plural_data.include?(index)
      end
    end

    def indexes
      collection.docs.map(&:data).map do |data|
        Utils.pluralized_array_from_hash(data, ::ActiveSupport::Inflector.singularize(label), label)
      end.flatten.uniq
    end

    def full_access_indexed_docs
      LiquidHashWithValues[indexes.map {|index| [index, {'label' => index, 'docs' => docs(index)}]}]
    end

    def fast_access_indexed_docs
      LiquidHashWithKeys[indexes.map {|index| [index, docs(index)]}]
    end

    # Create a Liquid-understandable version of this Classification.
    #
    # Returns a Hash representing this Document's data.
    def to_liquid
      LiquidHashWithValues[metadata.merge({
        "label"   => label,
        "indexes" => full_access_indexed_docs,
      })]
    end
  end
end
