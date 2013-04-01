require 'helper'

class TestLiquidEncoder < Test::Unit::TestCase
  context "LiquidEncoder" do
    context "#initialize" do

      should "give an empty LiquidEncoder without a string" do
        encoder = Jekyll::LiquidEncoder.new
        assert_equal(encoder.encoded_content, nil)
        assert_equal(encoder.salt.length, 6)
      end

      should "give a populated LiquidEncoder with a string" do
        encoder = Jekyll::LiquidEncoder.new('foo string')
        assert_not_equal(encoder.encoded_content, nil)
      end
    end

    context "#encode" do
      should "raise an error if asked to encode a string when it's already encoded a string" do
        encoder = Jekyll::LiquidEncoder.new('foo string')
        assert_raise(RuntimeError){ encoder.encode 'bar string' }
      end

      should "overwrite old string if second argument is +true+" do
        encoder = Jekyll::LiquidEncoder.new('foo string')
        old_string = encoder.encoded_content
        new_string = encoder.encode 'bar string', true
        assert_not_equal(old_string, new_string)
      end

      should "replace liquid tags with HTML" do
        encoder = Jekyll::LiquidEncoder.new('This is a {{sample}} string with {%liquid%} content.')
        assert_nil(encoder.encoded_content.index('{{'))
        assert_nil(encoder.encoded_content.index('{%'))
        assert_match(encoder.decoder_regexp,encoder.encoded_content)
      end

      should "keep liquid tags within raw tags" do
        encoder = Jekyll::LiquidEncoder.new('This is a {%raw%}test of {{raw}} content{%endraw%} - {{end}}.')
        str = encoder.encoded_content

        assert !str.include?('{{end}}')
        assert !str.include?('{%raw%}')
        assert !str.include?('{%endraw%}')
        assert str.include?('{{raw}}')
      end
    end

    context "#decode" do

      should "decode correctly" do
        encoder = Jekyll::LiquidEncoder.new('Sample {{text}}')
        decoded_string = encoder.decode(encoder.encoded_content*3)
        assert_equal('Sample {{text}}Sample {{text}}Sample {{text}}', decoded_string)
      end
    end
  end
end