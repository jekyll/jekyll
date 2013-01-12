# coding: utf-8

require 'helper'

class TestUtils < Test::Unit::TestCase
  context ".parse_addr" do
    should "understand PORT only form" do
      assert_equal [nil, 4000], Jekyll.parse_addr("4000")
    end

    should "understand HOST:PORT form" do
      assert_equal ["127.0.0.1", 4000], Jekyll.parse_addr("127.0.0.1:4000")
      assert_equal ["::1", 4000], Jekyll.parse_addr("::1:4000")
    end

    should "raise error if invalid host given" do
      assert_raise(RuntimeError) { Jekyll.parse_addr("!:4000") }
    end

    should "raise error if host only given" do
      assert_raise(RuntimeError) { Jekyll.parse_addr("::1") }
      assert_raise(RuntimeError) { Jekyll.parse_addr("127.0.0.1:") }
    end

    should "raise error if invalid port given" do
      assert_raise(RuntimeError) { Jekyll.parse_addr("127.0.0.1:foobar") }
      assert_raise(RuntimeError) { Jekyll.parse_addr("127.0.0.1:0") }
      assert_raise(RuntimeError) { Jekyll.parse_addr("127.0.0.1:-1") }
    end
  end
end
