#!/usr/bin/env ruby
require "liquid"
require "benchmark/ips"
require "jekyll"

puts "Ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
puts "Liquid #{Liquid::VERSION}"

module Testing
  class PostUrlAlways < Liquid::Tag
    include Jekyll::Filters::URLFilters

    def initialize(tag_name, post, tokens)
      super
      @orig_post = post.strip
    end

    def render(context)
      @context = context
      liquid_solved_orig_post = Liquid::Template.parse(@orig_post).render(context)
      return liquid_solved_orig_post
    end
  end
  class PostUrlNever < Liquid::Tag
    include Jekyll::Filters::URLFilters

    def initialize(tag_name, post, tokens)
      super
      @orig_post = post.strip
    end

    def render(context)
      @context = context
      return @orig_post
    end
  end

  class PostUrlConditional < Liquid::Tag
    include Jekyll::Filters::URLFilters

    def initialize(tag_name, post, tokens)
      super
      @orig_post = post.strip
    end

    def render(context)
      @context = context
      content = @orig_post

      return content if content.nil? || content.empty?
      return content unless content.include?("{%") || content.include?("{{")

      liquid_solved_orig_post = Liquid::Template.parse(content).render(context)
      return liquid_solved_orig_post
    end
  end
end

Liquid::Template.register_tag("post_urlish_always", Testing::PostUrlAlways)
Liquid::Template.register_tag("post_urlish_never", Testing::PostUrlNever)
Liquid::Template.register_tag("post_urlish_conditional", Testing::PostUrlConditional)

template1 = '{% post_urlish_always       foo{{bar}}  %}'
template2 = '{% post_urlish_always       foo42       %}'
template3 = '{% post_urlish_never        foo42       %}'
template4 = '{% post_urlish_conditional  foo{{bar}}  %}'
template5 = '{% post_urlish_conditional  foo42       %}'

def render(template)
  Liquid::Template.parse(template).render("bar" => "42")
end

puts render(template1)
puts render(template2)
puts render(template3)
puts render(template4)
puts render(template5)

Benchmark.ips do |x|
  x.report('post_urlish_always, with liquid tag') { render(template1) }
  x.report('post_urlish_always, no liquid tag') { render(template2) }
  x.report('post_urlish_never')  { render(template3) }
  x.report('post_urlish_conditional, with liquid tag')  { render(template4) }
  x.report('post_urlish_conditional, no liquid tag')  { render(template5) }
end
