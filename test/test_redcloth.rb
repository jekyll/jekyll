require File.dirname(__FILE__) + '/helper'

class TestRedCloth < Test::Unit::TestCase

  context "RedCloth default (no explicit config) hard_breaks enabled" do
    setup do
      @textile = TextileConverter.new
    end
    
    should "preserve single line breaks in HTML output" do 
      assert_equal "<p>line1<br />\nline2</p>", @textile.convert("p. line1\nline2").strip
    end
  end

  context "Default hard_breaks enabled w/ redcloth section, no hard_breaks value" do
    setup do
      config = {
        'redcloth'      => {}
        }
      @textile = TextileConverter.new config
    end
    
    should "preserve single line breaks in HTML output" do 
      assert_equal "<p>line1<br />\nline2</p>", @textile.convert("p. line1\nline2").strip
    end
  end

  context "RedCloth with hard_breaks enabled" do
    setup do
      config = {
        'redcloth'      => {
          'hard_breaks' => true # default
        }
      }
      @textile = TextileConverter.new config
    end
    
    should "preserve single line breaks in HTML output" do 
      assert_equal "<p>line1<br />\nline2</p>", @textile.convert("p. line1\nline2").strip
    end
  end

  context "RedCloth with hard_breaks disabled" do
    setup do
      config = {
        'redcloth'      => {
          'hard_breaks' => false
        }
      }
      @textile = TextileConverter.new config
    end

    should "not generate break tags in HTML output" do
      assert_equal "<p>line1\nline2</p>", @textile.convert("p. line1\nline2").strip
    end
  end
end
