require 'helper'

class TestDraft < Test::Unit::TestCase
  def setup_draft(file)
    Draft.new(@site, source_dir, '', file)
  end

  context "A Draft" do
    setup do
      clear_dest
      @site = Site.new(site_configuration)
    end

    should "ensure valid drafts are valid" do
      assert Draft.valid?("2008-09-09-foo-bar.textile")
      assert Draft.valid?("foo/bar/2008-09-09-foo-bar.textile")
      assert Draft.valid?("lol2008-09-09-foo-bar.textile")

      assert !Draft.valid?("blah")
    end

    should "make properties accessible through #[]" do
      draft = setup_draft('draft-properties.text')
      # ! need to touch the file! Or get its timestamp
      date = File.mtime(File.join(source_dir, '_drafts', 'draft-properties.text'))
      ymd = date.strftime("%Y/%m/%d")

      attrs = {
        categories: %w(foo bar baz),
        content: "All the properties.\n\nPlus an excerpt.\n",
        date: date,
        dir: "/foo/bar/baz/#{ymd}",
        excerpt: "All the properties.\n\n",
        foo: 'bar',
        id: "/foo/bar/baz/#{ymd}/draft-properties",
        layout: 'default',
        name: nil,
        path: "_drafts/draft-properties.text",
        permalink: nil,
        published: nil,
        tags: %w(ay bee cee),
        title: 'Properties Draft',
        url: "/foo/bar/baz/#{ymd}/draft-properties.html"
      }

      attrs.each do |attr, val|
        attr_str = attr.to_s
        result = draft[attr_str]
        assert_equal val, result, "For <draft[\"#{attr_str}\"]>:"
      end
    end

  end

end
