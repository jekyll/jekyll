# coding: utf-8

require 'helper'

class TestFilters < JekyllUnitTest
  class JekyllSortable
    attr_accessor :data, :title
    def initialize(date, slug)
      @title = slug
      @data = {
        'date' => Time.parse(date),
        'slug' => slug
      }
    end
    def to_liquid
      {
        'title' => title
      }.merge(@data)
    end
  end

  context "sorter" do
    setup do
      @sorter = Jekyll::Sorter
      @max_sorting_fields = Jekyll::Sorter::MAX_SORTING_FIELDS
      @max_nesting_level  = Jekyll::Sorter::MAX_NESTING_LEVEL
      @max_order_strlen   = Jekyll::Sorter::MAX_ORDER_STRLEN
      @max_order_methods  = Jekyll::Sorter::MAX_ORDER_METHODS
      @i1 = JekyllSortable.new("2015-01-02T00:00:00Z", 'a')
      @i2 = JekyllSortable.new("2015-01-01T00:00:00Z", 'b')
      @i3 = JekyllSortable.new("2015-01-01T00:00:00Z", 'c')
      @i4 = JekyllSortable.new("2015-01-01T00:00:00Z", nil)
      @array_of_objects = [ @i3, @i1, @i2 ]
      @array_with_nils  = [ @i3, @i2, @i4, nil, @i1 ]
    end

    context "order string" do
      context "validations" do
        should "raise Exception when ordering by more than Jekyll::Sorter::MAX_SORTING_FIELDS" do
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'data.date, data.slug, title')
          end
          assert_equal "Can't order by more than #{@max_sorting_fields} fields.", err.message
        end
        should "raise Exception when nesting by more than Jekyll::Sorter::MAX_NESTING_LEVEL" do
          err1 = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'data.date.time.start')
          end
          err2 = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'title, data.date.time.start')
          end
          msg = "Maximum depth allowed for sorting is #{@max_nesting_level} and the field: 'data.date.time.start' is 3 levels depth."
          assert_equal msg, err1.message
          assert_equal msg, err2.message
        end
        should "raise Exception when order string size is more than Jekyll::Sorter::MAX_ORDER_STRLEN" do
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'a'*(@max_order_strlen+1))
          end
          assert_equal "Maximum order string size is #{@max_order_strlen}.", err.message
        end
        should "raise Exception when order string doesn't match authorized RegExp" do
          ["1", "&", "title, data..time.start", "Date", ";", "title DESX", ", title", "title DESC NULLS frist"].each do |order_string|
            err = assert_raises ArgumentError do
              @sorter.order(@array_of_objects, order_string)
            end
            msg = %q(Invalid order argument. Valid arguments are: '<field> <direction> [NULLS <position>], with <direction> in: ["asc", "ASC", "desc", "DESC"] and <position> in: ["first", "FIRST", "last", "LAST"].)
            assert_equal msg, err.message
          end
        end
        should "raise Exception when order is called on more than Jekyll::Sorter::MAX_ORDER_METHODS times with differents parameters" do
          count = Jekyll::Sorter.class_variable_get('@@generated_methods')
          @sorter.order(@array_of_objects, 'data.test_generated_methods')
          Jekyll::Sorter.class_variable_set('@@generated_methods', @max_order_methods)
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'data.test_raise_generated_methods')
          end
          msg = 'Too many order methods generated. Please create an issue describing your use case on ' \
                'https://github.com/jekyll/jekyll/issues if you need this limit increased.'
          assert_equal msg, err.message
          Jekyll::Sorter.class_variable_set('@@generated_methods', count+1)
        end
        should "raise Exception when ordering by a restricted field" do
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'title', allowed_fields: %w(name data))
          end
          assert_equal "Can't order by 'title' (in 'title asc').", err.message
        end
        should "raise Exception when using nesging on a 'non nestable' field" do
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, 'title, data.name DESC', allowed_fields: %w(title data), nestable_fields: %w(name))
          end
          assert_equal "Can't order by 'data.name' (in 'data.name desc').", err.message
        end
        should "raise Exception when array is nil" do
          err = assert_raises ArgumentError do
            @sorter.order(nil, 'data.date DESC')
          end
          assert_equal "Cannot sort a null object.", err.message
        end
        should "raise Exception when order_by is nil" do
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, nil)
          end
          assert_equal "Cannot order by a null or empty field.", err.message
        end
        should "raise Exception when order_by is empty" do
          err = assert_raises ArgumentError do
            @sorter.order(@array_of_objects, "")
          end
          assert_equal "Cannot order by a null or empty field.", err.message
        end
      end

      context "generated comparison code" do
        should "handle simple field strings" do
          code = "cmp = 0\na_prop = a.date\nb_prop = b.date\ncmp = b_prop <=> a_prop\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(date desc)])
        end
        should "handle simple nested field strings" do
          code = "cmp = 0\na_prop = a.date['time']\nb_prop = b.date['time']\ncmp = b_prop <=> a_prop\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(date.time desc)])
        end
        should "handle multiple fields strings" do
          code = "cmp = 0\na_prop = a.title\nb_prop = b.title\ncmp = b_prop <=> a_prop\n\nif cmp == 0\n  a_prop = a.date['time']\n  b_prop = b.date['time']\n  cmp = b_prop <=> a_prop\nend\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(title desc), %w(date.time desc)])
        end
        should "use ASC direction by default" do
          code = "cmp = 0\na_prop = a.title\nb_prop = b.title\ncmp = a_prop <=> b_prop\n\nif cmp == 0\n  a_prop = a.date['time']\n  b_prop = b.date['time']\n  cmp = a_prop <=> b_prop\nend\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(title), %w(date.time)])
        end
        should "use Hash#fetch when ordering an Array of Hashes" do
          code = "cmp = 0\na_prop = a.fetch('date', nil)\nb_prop = b.fetch('date', nil)\ncmp = b_prop <=> a_prop\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(date desc)], array_of_hashes: true)
        end
        should "use specific code to access item properties when in liquid" do
          code = "cmp = 0\nitem = a\nitem = if item.respond_to?(:to_liquid)\n  item.to_liquid['date']\nelsif item.respond_to?(:data)\n  item.data['date']\nelse\n  item['date']\nend\na_prop = item\n\nitem = b\nitem = if item.respond_to?(:to_liquid)\n  item.to_liquid['date']\nelsif item.respond_to?(:data)\n  item.data['date']\nelse\n  item['date']\nend\nb_prop = item\n\ncmp = b_prop <=> a_prop\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(date desc)], in_liquid: true)
        end
        should "order null values at the beginning when allowing nil and using ASC" do
          code = "cmp = 0\na_prop = a.nil? ? nil : a.title\nb_prop = b.nil? ? nil : b.title\nif !a_prop.nil? && b_prop.nil?\n  cmp = 1\nelsif a_prop.nil? && !b_prop.nil?\n  cmp = -1\nelse\n  cmp = a_prop <=> b_prop\nend\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(title asc)], allow_nil: true)
        end
        should "order null values at the end when allowing nil and using DESC" do
          code = "cmp = 0\na_prop = a.nil? ? nil : a.title\nb_prop = b.nil? ? nil : b.title\nif !a_prop.nil? && b_prop.nil?\n  cmp = -1\nelsif a_prop.nil? && !b_prop.nil?\n  cmp = 1\nelse\n  cmp = b_prop <=> a_prop\nend\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(title desc)], allow_nil: true)
        end
        should "order null values at the beginning when allowing nil, using DESC and NULLS FIRST" do
          code = "cmp = 0\na_prop = a.nil? ? nil : a.title\nb_prop = b.nil? ? nil : b.title\nif !a_prop.nil? && b_prop.nil?\n  cmp = 1\nelsif a_prop.nil? && !b_prop.nil?\n  cmp = -1\nelse\n  cmp = b_prop <=> a_prop\nend\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(title desc first)], allow_nil: true)
        end
        should "order null values at the end when allowing nil, using ASC and NULLS LAST" do
          code = "cmp = 0\na_prop = a.nil? ? nil : a.title\nb_prop = b.nil? ? nil : b.title\nif !a_prop.nil? && b_prop.nil?\n  cmp = -1\nelsif a_prop.nil? && !b_prop.nil?\n  cmp = 1\nelse\n  cmp = b_prop <=> a_prop\nend\n\ncmp\n"
          assert_equal code, @sorter.generate_comparison_code([%w(title desc last)], allow_nil: true)
        end
      end
    end

    context "order" do
      should "return sorted arrays" do
        assert_equal [@i1, @i2, @i3], @sorter.order([@i3, @i1, @i2], "data.date desc, title")
      end
      should "raise Exception when input doesn't respond_to field" do
        err = assert_raises NoMethodError do
          @sorter.order(@array_of_objects, 'datas')
        end
      end
      should "use nil when input doesn't respond_to nested field" do
        assert_equal @array_of_objects, @sorter.order(@array_of_objects, 'data.i_dont_exists')
      end
      should "order array with null values when allowing nil" do
        assert_equal [@i1, @i2, @i3, @i4, nil], @sorter.order(@array_with_nils, 'title NULLS LAST, data.date NULLS LAST', allow_nil: true)
      end
      should "order array with null values when allowing nil and in liquid" do
        assert_equal [@i1, @i2, @i3, @i4, nil], @sorter.order(@array_with_nils, 'title NULLS LAST, date NULLS LAST', allow_nil: true, in_liquid: true)
      end
      should "allow valid restricted input" do
        assert_equal [@i1, @i2, @i3], @sorter.order([@i3, @i1, @i2], "data.date desc, title", allowed_fields: %w(title), nestable_fields: %w(data))
      end
      should "increase internal method counter when generating new methods" do
        count = Jekyll::Sorter.class_variable_get('@@generated_methods')
        @sorter.order(@array_of_objects, 'data.test_incr_generated_methods')
        assert_equal count+1, Jekyll::Sorter.class_variable_get('@@generated_methods')
      end
    end

  end
end
