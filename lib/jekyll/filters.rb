# frozen_string_literal: true

require_all "jekyll/filters"

module Jekyll
  module Filters
    include URLFilters
    include GroupingFilters
    include DateFilters

    # Convert a Markdown string into HTML output.
    #
    # input - The Markdown String to convert.
    #
    # Returns the HTML formatted String.
    def markdownify(input)
      @context.registers[:site].find_converter_instance(
        Jekyll::Converters::Markdown
      ).convert(input.to_s)
    end

    # Convert quotes into smart quotes.
    #
    # input - The String to convert.
    #
    # Returns the smart-quotified String.
    def smartify(input)
      @context.registers[:site].find_converter_instance(
        Jekyll::Converters::SmartyPants
      ).convert(input.to_s)
    end

    # Convert a Sass string into CSS output.
    #
    # input - The Sass String to convert.
    #
    # Returns the CSS formatted String.
    def sassify(input)
      @context.registers[:site].find_converter_instance(
        Jekyll::Converters::Sass
      ).convert(input)
    end

    # Convert a Scss string into CSS output.
    #
    # input - The Scss String to convert.
    #
    # Returns the CSS formatted String.
    def scssify(input)
      @context.registers[:site].find_converter_instance(
        Jekyll::Converters::Scss
      ).convert(input)
    end

    # Slugify a filename or title.
    #
    # input - The filename or title to slugify.
    # mode - how string is slugified
    #
    # Returns the given filename or title as a lowercase URL String.
    # See Utils.slugify for more detail.
    def slugify(input, mode = nil)
      Utils.slugify(input, :mode => mode)
    end

    # XML escape a string for use. Replaces any special characters with
    # appropriate HTML entity replacements.
    #
    # input - The String to escape.
    #
    # Examples
    #
    #   xml_escape('foo "bar" <baz>')
    #   # => "foo &quot;bar&quot; &lt;baz&gt;"
    #
    # Returns the escaped String.
    def xml_escape(input)
      input.to_s.encode(:xml => :attr).gsub(%r!\A"|"\Z!, "")
    end

    # CGI escape a string for use in a URL. Replaces any special characters
    # with appropriate %XX replacements.
    #
    # input - The String to escape.
    #
    # Examples
    #
    #   cgi_escape('foo,bar;baz?')
    #   # => "foo%2Cbar%3Bbaz%3F"
    #
    # Returns the escaped String.
    def cgi_escape(input)
      CGI.escape(input)
    end

    # URI escape a string.
    #
    # input - The String to escape.
    #
    # Examples
    #
    #   uri_escape('foo, bar \\baz?')
    #   # => "foo,%20bar%20%5Cbaz?"
    #
    # Returns the escaped String.
    def uri_escape(input)
      Addressable::URI.normalize_component(input)
    end

    # Replace any whitespace in the input string with a single space
    #
    # input - The String on which to operate.
    #
    # Returns the formatted String
    def normalize_whitespace(input)
      input.to_s.gsub(%r!\s+!, " ").strip
    end

    # Count the number of words in the input string.
    #
    # input - The String on which to operate.
    #
    # Returns the Integer word count.
    def number_of_words(input)
      input.split.length
    end

    # Join an array of things into a string by separating with commas and the
    # word "and" for the last one.
    #
    # array - The Array of Strings to join.
    # connector - Word used to connect the last 2 items in the array
    #
    # Examples
    #
    #   array_to_sentence_string(["apples", "oranges", "grapes"])
    #   # => "apples, oranges, and grapes"
    #
    # Returns the formatted String.
    def array_to_sentence_string(array, connector = "and")
      case array.length
      when 0
        ""
      when 1
        array[0].to_s
      when 2
        "#{array[0]} #{connector} #{array[1]}"
      else
        "#{array[0...-1].join(", ")}, #{connector} #{array[-1]}"
      end
    end

    # Convert the input into json string
    #
    # input - The Array or Hash to be converted
    #
    # Returns the converted json string
    def jsonify(input)
      as_liquid(input).to_json
    end

    # Filter an array of objects
    #
    # input - the object array
    # property - property within each object to filter by
    # value - desired value
    #
    # Returns the filtered array of objects
    def where(input, property, value)
      return input if property.nil? || value.nil?
      return input unless input.respond_to?(:select)

      input    = input.values if input.is_a?(Hash)
      input_id = input.hash

      # implement a hash based on method parameters to cache the end-result
      # for given parameters.
      @where_filter_cache ||= {}
      @where_filter_cache[input_id] ||= {}
      @where_filter_cache[input_id][property] ||= {}

      # stash or retrive results to return
      @where_filter_cache[input_id][property][value] ||= begin
        input.select do |object|
          Array(item_property(object, property)).map!(&:to_s).include?(value.to_s)
        end || []
      end
    end

    # Filters an array of objects against an expression
    #
    # input - the object array
    # variable - the variable to assign each item to in the expression
    # expression - a Liquid comparison expression passed in as a string
    #
    # Returns the filtered array of objects
    def where_exp(input, variable, expression)
      return input unless input.respond_to?(:select)

      input = input.values if input.is_a?(Hash) # FIXME

      condition = parse_condition(expression)
      @context.stack do
        input.select do |object|
          @context[variable] = object
          condition.evaluate(@context)
        end
      end || []
    end

    # Convert the input into integer
    #
    # input - the object string
    #
    # Returns the integer value
    def to_integer(input)
      return 1 if input == true
      return 0 if input == false

      input.to_i
    end

    # Sort an array of objects
    #
    # input - the object array
    # property - property within each object to filter by
    # nils ('first' | 'last') - nils appear before or after non-nil values
    #
    # Returns the filtered array of objects
    def sort(input, property = nil, nils = "first")
      raise ArgumentError, "Cannot sort a null object." if input.nil?

      if property.nil?
        input.sort
      else
        if nils == "first"
          order = - 1
        elsif nils == "last"
          order = + 1
        else
          raise ArgumentError, "Invalid nils order: " \
            "'#{nils}' is not a valid nils order. It must be 'first' or 'last'."
        end

        sort_input(input, property, order)
      end
    end

    def pop(array, num = 1)
      return array unless array.is_a?(Array)

      num = Liquid::Utils.to_integer(num)
      new_ary = array.dup
      new_ary.pop(num)
      new_ary
    end

    def push(array, input)
      return array unless array.is_a?(Array)

      new_ary = array.dup
      new_ary.push(input)
      new_ary
    end

    def shift(array, num = 1)
      return array unless array.is_a?(Array)

      num = Liquid::Utils.to_integer(num)
      new_ary = array.dup
      new_ary.shift(num)
      new_ary
    end

    def unshift(array, input)
      return array unless array.is_a?(Array)

      new_ary = array.dup
      new_ary.unshift(input)
      new_ary
    end

    def sample(input, num = 1)
      return input unless input.respond_to?(:sample)

      num = Liquid::Utils.to_integer(num) rescue 1
      if num == 1
        input.sample
      else
        input.sample(num)
      end
    end

    # Convert an object into its String representation for debugging
    #
    # input - The Object to be converted
    #
    # Returns a String representation of the object.
    def inspect(input)
      xml_escape(input.inspect)
    end

    private

    # Sort the input Enumerable by the given property.
    # If the property doesn't exist, return the sort order respective of
    # which item doesn't have the property.
    # We also utilize the Schwartzian transform to make this more efficient.
    def sort_input(input, property, order)
      input.map { |item| [item_property(item, property), item] }
        .sort! do |a_info, b_info|
          a_property = a_info.first
          b_property = b_info.first

          if !a_property.nil? && b_property.nil?
            - order
          elsif a_property.nil? && !b_property.nil?
            + order
          else
            a_property <=> b_property || a_property.to_s <=> b_property.to_s
          end
        end
        .map!(&:last)
    end

    def item_property(item, property)
      if item.respond_to?(:to_liquid)
        property.to_s.split(".").reduce(item.to_liquid) do |subvalue, attribute|
          parse_sort_input(subvalue[attribute])
        end
      elsif item.respond_to?(:data)
        parse_sort_input(item.data[property.to_s])
      else
        parse_sort_input(item[property.to_s])
      end
    end

    # return numeric values as numbers for proper sorting
    def parse_sort_input(property)
      number_like = %r!\A\s*-?(?:\d+\.?\d*|\.\d+)\s*\Z!
      return property.to_f if property =~ number_like

      property
    end

    def as_liquid(item)
      case item
      when Hash
        pairs = item.map { |k, v| as_liquid([k, v]) }
        Hash[pairs]
      when Array
        item.map { |i| as_liquid(i) }
      else
        if item.respond_to?(:to_liquid)
          liquidated = item.to_liquid
          # prevent infinite recursion for simple types (which return `self`)
          if liquidated == item
            item
          else
            as_liquid(liquidated)
          end
        else
          item
        end
      end
    end

    # Parse a string to a Liquid Condition
    def parse_condition(exp)
      parser = Liquid::Parser.new(exp)
      left_expr = parser.expression
      operator = parser.consume?(:comparison)
      condition =
        if operator
          Liquid::Condition.new(Liquid::Expression.parse(left_expr),
                                operator,
                                Liquid::Expression.parse(parser.expression))
        else
          Liquid::Condition.new(Liquid::Expression.parse(left_expr))
        end
      parser.consume(:end_of_string)

      condition
    end
  end
end

Liquid::Template.register_filter(
  Jekyll::Filters
)
