module Jekyll
  # Public: Various methods for sorting Arrays according to specific data fields
  # and directions defined in a SQL-like user friendly order String.
  module Sorter

    # Internal: Integer maximum number of fields accepted in an order String.
    MAX_SORTING_FIELDS = 2

    # Internal: Integer maximum depth for nested fields accepted in an order String.
    MAX_NESTING_LEVEL = 2

    # Internal: Integer maximum length of an order String.
    MAX_ORDER_STRLEN = 200

    # Internal: Integer maximum number of distinct order method generater by the Sorter.
    # This should be a reasonable amount for normal Jekyll runs.
    MAX_ORDER_METHODS = 100

    # Internal: Array of Strings defining accepted directions in an order String.
    VALID_DIRECTIONS = %w(asc ASC desc DESC)

    # Internal: Array of Strings defining accepted NULLS order in an order String.
    VALID_NULLS = %w(first FIRST last LAST)

    # Internal: Regexp used to validate format of an order String.
    ARG_MATCHER = /^(?<field>[a-z_]\w*(\.\w+)*)( (?<dir>#{VALID_DIRECTIONS.join('|')})){0,1}( (nulls|NULLS) (?<nulls>#{VALID_NULLS.join('|')})){0,1}$/

    # Internal: Count distinct methods generated using Jekyll::Sorter.order[!]
    @@generated_methods = 0

    # Public: Sort an array according by one or more fields.
    #
    # array    - An array to sort
    # order_by - A formatted String describing the fields and directions to
    #            order by (format: '<field> <direction>[, <field> <direction>...]').
    #            :field     - The field within each object to sort by.
    #                         Nested fields are supported with 'field.subfield[.subfield...]'.
    #                         Supports up to Jekyll::Sorter::MAX_NESTING_LEVEL of nesting.
    #            :direction - The direction to order by (default: ASC).
    #                         See Jekyll::Sorter::VALID_DIRECTIONS for a list of
    #                         valid direction.
    #            You can compare a maximum of Jekyll::Sorter::MAX_SORTING_FIELDS fields
    #            separated by a comma (ie. field1 dir1, field2 dir2).
    # options  - A Hash of options used to modify or restrict the order method
    #            (default: {}).
    #            :allowed_fields  - The Array of fields used to restrict
    #                               allowed sorting if provided (default: nil).
    #            :nestable_fields - The Array of fields used to restrict
    #                               allowed nested sorting if provided (default: nil).
    #            :array_of_hashes - A Boolean that switch between considering fields
    #                               as attributes (of an Object) or as keys (of a Hash).
    #                               Set this to true if you want to order an Array
    #                               of Hashes (default: false).
    #            :allow_nil       - A Boolean that switch between accepting nil values
    #                               or raising exceptions (default: false).
    #            :in_liquid       - A Boolean that switch between directly accessing
    #                               the fields (faster), or extracting them from
    #                               objects available in Liquid (slower).
    #                               Set this to true if you want to use order in
    #                               a Liquid context (like a Filter) (default: false).
    #            :in_place        - A Boolean that switch between copy
    #                               and in_place! sorting (default: false).
    #
    # Examples
    #
    #   class O
    #     attr_accessor :data
    #     def initialize(date, slug)
    #       @data = {
    #         'date' => Time.parse(date),
    #         'slug' => slug
    #       }
    #     end
    #   end
    #
    #   a = O.new("2015-01-02T00:00:00Z", 'a')
    #   b = O.new("2015-01-01T00:00:00Z", 'b')
    #   c = O.new("2015-01-01T00:00:00Z", 'c')
    #
    #   Jekyll::Sorter.order([c,b,a], 'data.date DESC, data.slug')
    #   # => [#<O:0x007faabacd1f60 @data={"date"=>2015-01-02 00:00:00 UTC, "slug"=>"a"}>,
    #    #<O:0x007faaba559ff8 @data={"date"=>2015-01-01 00:00:00 UTC, "slug"=>"b"}>,
    #    #<O:0x007faaba510538 @data={"date"=>2015-01-01 00:00:00 UTC, "slug"=>"c"}>]
    #
    # Returns a sorted Array.
    def self.order(array, order_by, options = {})
      @cached_methods ||= {}
      options = {
        in_place: false,
        in_liquid: false,
        array_of_hashes: false,
      }.merge(options)

      raise ArgumentError, 'Cannot sort a null object.' if array.nil?
      raise ArgumentError, 'Cannot order by a null or empty field.' if order_by.nil? || order_by.empty?

      if @cached_methods[[order_by, options]]
        self.send(@cached_methods[[order_by, options]], array)
      else
        args = extract_args(order_by)

        sort_method = options[:in_place] ? 'sort!' : 'sort'
        count = @@generated_methods+=1

        raise ArgumentError, 'Too many order methods generated. Please create an issue describing your use case on ' \
                             'https://github.com/jekyll/jekyll/issues if you need this limit increased.' if count > MAX_ORDER_METHODS

        method_name = "_order_#{args.join('_')}_#{count}_#{sort_method}".gsub(/\W+/, '_')

        cmp_code = generate_comparison_code(args, options)

        # Internal: Sort the array by a specific data field name and direction. This method
        # will be available for each field and direction passed to the order method.
        #
        # array - The Array to sort.
        #
        # Returns a sorted Array.
        #
        # Signature
        #
        #   self._order_<field>_<direction>[_<field>_<direction>]_<id>_sort[!](array)
        #
        # field     - A field name.
        # direction - A sort direction.
        # id        - An Integer id generated internally to prevent name clashes.
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def self.#{method_name}(array)            # def self._order_date_desc_data_slug_asc_sort(array)
            array.#{sort_method} do |a,b|           #   array.sort do |a,b|
            #{cmp_code}                             #     cmp = 0
                                                    #     cmp = b.date <=> a.date
                                                    #     if cmp == 0
                                                    #       cmp = a.data['slug'] <=> b.data['slug']
                                                    #     end
                                                    #     cmp
            end                                     #   end
          end                                       # end
        RUBY

        @cached_methods[[order_by, options]] = method_name
        self.send(method_name, array)
      end
    end

    # Public: Sort an array in place according by one or more fields.
    #
    # See ::order for a list of supported parameters and options.
    #
    # Returns a sorted Array.
    def self.order!(array, order_by, options = {})
      options[:in_place] = true
      order(array, order_by, options)
    end


    # Internal: Extract and validate args from an order string.
    #
    # order_by - A string to extract args from
    #                (format: '<field> <direction>[, <field> <direction>]').
    #
    # Example
    #
    #  Jekyll::Sorter.extract_args('date DESC, data.slug asc')
    #  # => [["date", "desc"], ["slug", "asc"]]
    #
    # Return an array of validated [field, direction].
    def self.extract_args(order_by)
      raise ArgumentError, "Maximum order string size is #{MAX_ORDER_STRLEN}." \
                           if order_by.length > MAX_ORDER_STRLEN

      args = order_by.split(',').map(&:strip)
      raise ArgumentError, "Can't order by more than #{MAX_SORTING_FIELDS} fields." \
                           if args.size > MAX_SORTING_FIELDS

      args.map! do |arg|
        m = arg.match(ARG_MATCHER)
        raise ArgumentError, "Invalid order argument. Valid arguments are: '<field> <direction> [NULLS <position>], " \
                             "with <direction> in: #{VALID_DIRECTIONS.inspect} and <position> in: #{VALID_NULLS.inspect}." if m.nil?
        [m[:field], m[:dir], m[:nulls]]
      end
    end

    # Internal: Generate code that compare elements of an Array according to an Array of [field, direction]
    #
    # args    - An Array of [field, direction].
    # options - A Hash of options used to validate the args
    #           (default: {}).
    #           :allowed_fields  - The Array of fields used to restrict
    #                              allowed sorting if provided (default: nil).
    #           :nestable_fields - The Array of fields used to restrict
    #                              allowed nested sorting if provided (default: nil).
    #           :array_of_hashes - A Boolean that switch between considering fields
    #                              as attributes (of an Object) or as keys (of a Hash).
    #                              Set this to true if you want to order an Array
    #                              of Hashes (default: false).
    #           :in_liquid       - A Boolean that switch between directly accessing
    #                              the fields (faster), or extracting them from
    #                              objects available in Liquid (slower).
    #                              Set this to true if you want to use order in
    #                              a Liquid context (like a Filter) (default: false).
    #
    # Return a String containing the code to compare elements of an Array.
    def self.generate_comparison_code(args, options = {})
      options = {
        in_liquid: false,
        array_of_hashes: false,
      }.merge(options)

      str = "cmp = 0\n"

      args.each_with_index.map do |arg, i|
        field, dir, nulls = arg
        dir = (dir || 'asc').downcase
        nulls = (nulls || (dir == 'asc' ? 'first' : 'last')).downcase
        levels = field.split('.')

        raise ArgumentError, "Maximum depth allowed for sorting is #{MAX_NESTING_LEVEL} " \
                             "and the field: '#{field}' is #{levels.size - 1} levels depth." \
                             if levels.size - 1 > MAX_NESTING_LEVEL
        field_access = nil

        if levels.size == 1
          raise ArgumentError, "Can't order by '#{field}' (in '#{field} #{dir}')." \
                               if options[:allowed_fields] && !options[:allowed_fields].include?(field)

          if !options[:in_liquid]
            if options[:array_of_hashes]
              field_access = "fetch('#{field}', nil)"
            else
              field_access = field
            end
          end
        else
          attribute = levels.shift
          raise ArgumentError, "Can't order by '#{field}' (in '#{field} #{dir}')." \
                               if options[:allowed_fields] && !options[:nestable_fields].include?(attribute)

          if !options[:in_liquid]
            if options[:array_of_hashes]
              if options[:allow_nil]
                attribute = "fetch('#{attribute}', {})"
              else
                attribute = "fetch('#{attribute}', nil)"
              end
            end

            if options[:allow_nil]
              field_access = %Q{#{attribute}.fetch('#{levels.join("', {}).fetch('")}', nil)}
            else
              field_access = %Q{#{attribute}['#{levels.join("']['")}']}
            end
          end
        end

        if options[:in_liquid]
          field_access = []
          field.split('.').each do |property|
            if options[:allow_nil]
              field_access << "item = if item.respond_to?(:to_liquid)"
              field_access << "  item.to_liquid && item.to_liquid['#{property}']"
              field_access << "elsif item.respond_to?(:data)"
              field_access << "  item.data && item.data['#{property}']"
              field_access << "else"
              field_access << "  item && item['#{property}']"
              field_access << "end"
            else
              field_access << "item = if item.respond_to?(:to_liquid)"
              field_access << "  item.to_liquid['#{property}']"
              field_access << "elsif item.respond_to?(:data)"
              field_access << "  item.data['#{property}']"
              field_access << "else"
              field_access << "  item['#{property}']"
              field_access << "end"
            end
          end
        end

        cmp_line = if dir == 'asc'
          "cmp = a_prop <=> b_prop"
        else
          "cmp = b_prop <=> a_prop"
        end

        tab = ''

        if i != 0
          str << "\nif cmp == 0\n"
          tab = '  '
        end

        if options[:in_liquid]
          str << %Q{#{tab}item = a#{options[:allow_nil] ? ' || {}' : ''}\n}
          str << %Q{#{tab}#{field_access.join("\n#{tab}")}\n}
          str << %Q{#{tab}a_prop = item\n\n}

          str << %Q{#{tab}item = b#{options[:allow_nil] ? ' || {}' : ''}\n}
          str << %Q{#{tab}#{field_access.join("\n#{tab}")}\n}
          str << %Q{#{tab}b_prop = item\n\n}
        else
          if options[:allow_nil]
            str << %Q{#{tab}a_prop = a.nil? ? nil : a.#{field_access}\n}
            str << %Q{#{tab}b_prop = b.nil? ? nil : b.#{field_access}\n}
          else
            str << %Q{#{tab}a_prop = a.#{field_access}\n}
            str << %Q{#{tab}b_prop = b.#{field_access}\n}
          end
        end

        if options[:allow_nil]
          str << "#{tab}if !a_prop.nil? && b_prop.nil?\n"
          str << "#{tab}  cmp = #{nulls == 'first' ? "1" : "-1"}\n"
          str << "#{tab}elsif a_prop.nil? && !b_prop.nil?\n"
          str << "#{tab}  cmp = #{nulls == 'first' ? "-1" : "1"}\n"
          str << "#{tab}else\n"
          str << "#{tab}  #{cmp_line}\n"
          str << "#{tab}end\n"
        else
          str << "#{tab}#{cmp_line}\n"
        end

        str << "end\n" if i != 0

        str
      end.join
      str << "\ncmp\n"

      str
    end
  end
end
