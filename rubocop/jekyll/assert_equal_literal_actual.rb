# frozen_string_literal: true

module RuboCop
  module Cop
    module Jekyll
      # Checks for `assert_equal(exp, act, msg = nil)` calls containing literal values as
      # second argument. The second argument should ideally be a method called on the tested
      # instance.
      #
      # @example
      #   # bad
      #   assert_equal @foo.bar, "foobar"
      #   assert_equal @alpha.beta, { "foo" => "bar", "lorem" => "ipsum" }
      #   assert_equal @alpha.omega, ["foobar", "lipsum"]
      #
      #   # good
      #   assert_equal "foobar", @foo.bar
      #
      #   assert_equal(
      #     { "foo" => "bar", "lorem" => "ipsum" },
      #     @alpha.beta
      #   )
      #
      #   assert_equal(
      #     ["foobar", "lipsum"],
      #     @alpha.omega
      #   )
      #
      class AssertEqualLiteralActual < Cop
        MSG = "Provide the 'expected value' as the first argument to `assert_equal`.".freeze

        SIMPLE_LITERALS = %i(
          true
          false
          nil
          int
          float
          str
          sym
          complex
          rational
          regopt
        ).freeze

        COMPLEX_LITERALS = %i(
          array
          hash
          pair
          irange
          erange
          regexp
        ).freeze

        def_node_matcher :literal_actual?, <<-PATTERN
          (send nil? :assert_equal $(send ...) $#literal?)
        PATTERN

        def_node_matcher :literal_actual_with_msg?, <<-PATTERN
          (send nil? :assert_equal $(send ...) $#literal? $#opt_msg?)
        PATTERN

        def on_send(node)
          return unless literal_actual?(node) || literal_actual_with_msg?(node)
          add_offense(node, location: :expression)
        end

        def autocorrect(node)
          lambda do |corrector|
            corrector.replace(node.loc.expression, replacement(node))
          end
        end

        private

        def opt_msg?(node)
          node&.source
        end

        # This is not implement using a NodePattern because it seems
        # to not be able to match against an explicit (nil) sexp
        def literal?(node)
          node && (simple_literal?(node) || complex_literal?(node))
        end

        def simple_literal?(node)
          SIMPLE_LITERALS.include?(node.type)
        end

        def complex_literal?(node)
          COMPLEX_LITERALS.include?(node.type) &&
            node.each_child_node.all?(&method(:literal?))
        end

        def replacement(node)
          _, _, first_param, second_param, optional_param = *node

          replaced_text = \
            if second_param.type == :hash
              replace_hash_with_variable(first_param.source, second_param.source)
            elsif second_param.type == :array && second_param.source != "[]"
              replace_array_with_variable(first_param.source, second_param.source)
            else
              replace_based_on_line_length(first_param.source, second_param.source)
            end

          return "#{replaced_text}, #{optional_param.source}" if optional_param
          replaced_text
        end

        def replace_based_on_line_length(first_expression, second_expression)
          result = "assert_equal #{second_expression}, #{first_expression}"
          return result if result.length < 80

          # fold long lines independent of Rubocop configuration for better readability
          <<~TEXT
            assert_equal(
              #{second_expression},
              #{first_expression}
            )
          TEXT
        end

        def replace_hash_with_variable(first_expression, second_expression)
          expect_expression = if second_expression.start_with?("{")
                                second_expression
                              else
                                "{#{second_expression}}"
                              end
          <<~TEXT
            expected = #{expect_expression}
            assert_equal expected, #{first_expression}
          TEXT
        end

        def replace_array_with_variable(first_expression, second_expression)
          expect_expression = if second_expression.start_with?("%")
                                second_expression
                              else
                                Array(second_expression)
                              end
          <<~TEXT
            expected = #{expect_expression}
            assert_equal expected, #{first_expression}
          TEXT
        end
      end
    end
  end
end
