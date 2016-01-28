# encoding: UTF-8

module Jekyll
  class Page < Document
    # Post-read step: don't try to force title for pages
    def post_read
      title = data['title']
      super
      data['title'] = title
    end
  end
end
