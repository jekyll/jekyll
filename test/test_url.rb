require 'minitest/autorun'

describe Jekyll::URL do
  describe "The URL class" do

    it "throw an exception if neither permalink or template is specified" do
      proc {URL.new(:placeholders => {})}.must_raise ArgumentError
    end

    it "replace placeholders in templates" do
      "/foo/bar".must_equal URL.new(
        :template => "/:x/:y",
        :placeholders => {:x => "foo", :y => "bar"}
      ).to_s
    end

    it "return permalink if given" do
      "/le/perma/link".must_equal URL.new(
        :template => "/:x/:y",
        :placeholders => {:x => "foo", :y => "bar"},
        :permalink => "/le/perma/link"
      ).to_s
    end

  end
end
