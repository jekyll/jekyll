require 'helper'
require 'minitest/autorun'


describe Jekyll::Utils do

  describe "hash" do

    describe "pluralized_array" do

      it "return empty array with no values" do
        data = {}
        [].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return empty array with no matching values" do
        data = { 'foo' => 'bar' }
        [].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return plural array with nil singular" do
        data = { 'foo' => 'bar', 'tag' => nil, 'tags' => ['dog', 'cat'] }
        ['dog', 'cat'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return single value array with matching singular" do
        data = { 'foo' => 'bar', 'tag' => 'dog', 'tags' => ['dog', 'cat'] }
        ['dog'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return single value array with matching singular with spaces" do
        data = { 'foo' => 'bar', 'tag' => 'dog cat', 'tags' => ['dog', 'cat'] }
        ['dog cat'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return empty array with matching nil plural" do
        data = { 'foo' => 'bar', 'tags' => nil }
        [].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return empty array with matching empty array" do
        data = { 'foo' => 'bar', 'tags' => [] }
        [].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return single value array with matching plural with single string value" do
        data = { 'foo' => 'bar', 'tags' => 'dog' }
        ['dog'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return multiple value array with matching plural with single string value with spaces" do
        data = { 'foo' => 'bar', 'tags' => 'dog cat' }
        ['dog', 'cat'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return single value array with matching plural with single value array" do
        data = { 'foo' => 'bar', 'tags' => ['dog'] }
        ['dog'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      it "return multiple value array with matching plural with multiple value array" do
        data = { 'foo' => 'bar', 'tags' => ['dog', 'cat'] }
        ['dog', 'cat'].must_equal Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

    end

  end


end
