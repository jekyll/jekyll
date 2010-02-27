module Jekyll
  class Pager
    attr_reader :page, :per_page, :posts, :total_posts, :total_pages, :previous_page, :next_page
    
    def self.calculate_pages(all_posts, per_page)
      num_pages = all_posts.size / per_page.to_i
      num_pages = num_pages + 1 if all_posts.size % per_page.to_i != 0
      num_pages
    end
    
    def self.pagination_enabled?(config, file)
      file == 'index.html' && !config['paginate'].nil?
    end
    
    def initialize(config, page, all_posts, num_pages = nil)
      @page = page
      @per_page = config['paginate'].to_i
      @total_pages = num_pages || Pager.calculate_pages(all_posts, @per_page)
      
      if @page > @total_pages
        raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
      end
      
      init = (@page - 1) * @per_page
      offset = (init + @per_page - 1) >= all_posts.size ? all_posts.size : (init + @per_page - 1)
      
      @total_posts = all_posts.size
      @posts = all_posts[init..offset]
      @previous_page = @page != 1 ? @page - 1 : nil
      @next_page = @page != @total_pages ? @page + 1 : nil
    end
    
    def to_liquid
      {
        'page' => page, 
        'per_page' => per_page, 
        'posts' => posts, 
        'total_posts' => total_posts,
        'total_pages' => total_pages,
        'previous_page' => previous_page,
        'next_page' => next_page
      }
    end
  end
end
