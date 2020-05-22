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
    def number_of_words(input, mode = nil)
      cjk_charset = '\p{Han}\p{Katakana}\p{Hiragana}\p{Hangul}'
      cjk_regex = %r![#{cjk_charset}]!o
      word_regex = %r![^#{cjk_charset}\s]+!o

      case mode
      when "cjk"
        input.scan(cjk_regex).length + input.scan(word_regex).length
      when "auto"
        cjk_count = input.scan(cjk_regex).length
        cjk_count.zero? ? input.split.length : cjk_count + input.scan(word_regex).length
      else
        input.split.length
      end
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
    # input    - the object array.
    # property - the property within each object to filter by.
    # value    - the desired value.
    #            Cannot be an instance of Array nor Hash since calling #to_s on them returns
    #            their `#inspect` string object.
    #
    # Returns the filtered array of objects
    def where(input, property, value)
      return input if !property || value.is_a?(Array) || value.is_a?(Hash)
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
          compare_property_vs_target(item_property(object, property), value)
        end.to_a
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

    # Search an array of objects and returns the first object that has the queried attribute
    # with the given value or returns nil otherwise.
    #
    # input    - the object array.
    # property - the property within each object to search by.
    # value    - the desired value.
    #            Cannot be an instance of Array nor Hash since calling #to_s on them returns
    #            their `#inspect` string object.
    #
    # Returns the found object or nil
    #
    # rubocop:disable Metrics/CyclomaticComplexity
    def find(input, property, value)
      return input if !property || value.is_a?(Array) || value.is_a?(Hash)
      return input unless input.respond_to?(:find)

      input    = input.values if input.is_a?(Hash)
      input_id = input.hash

      # implement a hash based on method parameters to cache the end-result for given parameters.
      @find_filter_cache ||= {}
      @find_filter_cache[input_id] ||= {}
      @find_filter_cache[input_id][property] ||= {}

      # stash or retrive results to return
      # Since `enum.find` can return nil or false, we use a placeholder string "<__NO MATCH__>"
      #   to validate caching.
      result = @find_filter_cache[input_id][property][value] ||= begin
        input.find do |object|
          compare_property_vs_target(item_property(object, property), value)
        end || "<__NO MATCH__>"
      end
      return nil if result == "<__NO MATCH__>"

      result
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    # Searches an array of objects against an expression and returns the first object for which
    # the expression evaluates to true, or returns nil otherwise.
    #
    # input - the object array
    # variable - the variable to assign each item to in the expression
    # expression - a Liquid comparison expression passed in as a string
    #
    # Returns the found object or nil
    def find_exp(input, variable, expression)
      return input unless input.respond_to?(:find)

      input = input.values if input.is_a?(Hash)

      condition = parse_condition(expression)
      @context.stack do
        input.find do |object|
          @context[variable] = object
          condition.evaluate(@context)
        end
      end
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

    # `where` filter helper
    #
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def compare_property_vs_target(property, target)
      case target
      when NilClass
        return true if property.nil?
      when Liquid::Expression::MethodLiteral # `empty` or `blank`
        target = target.to_s
        return true if property == target || Array(property).join == target
      else
        target = target.to_s
        if property.is_a? String
          return true if property == target
        else
          Array(property).each do |prop|
            return true if prop.to_s == target
          end
        end
      end

      false
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def item_property(item, property)
      @item_property_cache ||= {}
      @item_property_cache[property] ||= {}
      @item_property_cache[property][item] ||= begin
        property = property.to_s
        property = if item.respond_to?(:to_liquid)
                     read_liquid_attribute(item.to_liquid, property)
                   elsif item.respond_to?(:data)
                     item.data[property]
                   else
                     item[property]
                   end

        parse_sort_input(property)
      end
    end

    def read_liquid_attribute(liquid_data, property)
      return liquid_data[property] unless property.include?(".")

      property.split(".").reduce(liquid_data) do |data, key|
        data.respond_to?(:[]) && data[key]
      end
    end

    FLOAT_LIKE   = %r!\A\s*-?(?:\d+\.?\d*|\.\d+)\s*\Z!.freeze
    INTEGER_LIKE = %r!\A\s*-?\d+\s*\Z!.freeze
    private_constant :FLOAT_LIKE, :INTEGER_LIKE

    # return numeric values as numbers for proper sorting
    def parse_sort_input(property)
      stringified = property.to_s
      return property.to_i if INTEGER_LIKE.match?(stringified)
      return property.to_f if FLOAT_LIKE.match?(stringified)

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

    # -----------   The following set of code was *adapted* from Liquid::If
    # -----------   ref: https://git.io/vp6K6

    # Parse a string to a Liquid Condition
    def parse_condition(exp)
      parser    = Liquid::Parser.new(exp)
      condition = parse_binary_comparison(parser)

      parser.consume(:end_of_string)
      condition
    end

    # Generate a Liquid::Condition object from a Liquid::Parser object additionally processing
    # the parsed expression based on whether the expression consists of binary operations with
    # Liquid operators `and` or `or`
    #
    #  - parser: an instance of Liquid::Parser
    #
    # Returns an instance of Liquid::Condition
    def parse_binary_comparison(parser)
      condition = parse_comparison(parser)
      first_condition = condition
      while (binary_operator = parser.id?("and") || parser.id?("or"))
        child_condition = parse_comparison(parser)
        condition.send(binary_operator, child_condition)
        condition = child_condition
      end
      first_condition
    end

    # Generates a Liquid::Condition object from a Liquid::Parser object based on whether the parsed
    # expression involves a "comparison" operator (e.g. <, ==, >, !=, etc)
    #
    #  - parser: an instance of Liquid::Parser
    #
    # Returns an instance of Liquid::Condition
    def parse_comparison(parser)
      left_operand = Liquid::Expression.parse(parser.expression)
      operator     = parser.consume?(:comparison)

      # No comparison-operator detected. Initialize a Liquid::Condition using only left operand
      return Liquid::Condition.new(left_operand) unless operator

      # Parse what remained after extracting the left operand and the `:comparison` operator
      # and initialize a Liquid::Condition object using the operands and the comparison-operator
      Liquid::Condition.new(left_operand, operator, Liquid::Expression.parse(parser.expression))
    end
  end
end

Liquid::Template.register_filter(
  Jekyll::Filters
)
