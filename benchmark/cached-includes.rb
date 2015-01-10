require 'benchmark/ips'
require 'jekyll'

site = Jekyll::Site.new(Jekyll.configuration({
  'source' => File.expand_path('../site', __dir__),
  'destination' => File.expand_path('../site/_site', __dir__)
}))
payload = Jekyll::Utils.deep_merge_hashes(
  site.site_payload,
  { 'site' => {'page' => site.pages.first.to_liquid } }
)
info = {
  filters:   [Jekyll::Filters],
  registers: { :site => site, :page => payload['page'] }
}

class WithoutCacheInclude < Jekyll::Tags::IncludeTag
  def source(file, context)
    File.read(file, file_read_opts(context))
  end
end

Liquid::Template.register_tag('include_woc', WithoutCacheInclude)

def parse(tag, payload, info)
  Liquid::Template.parse("{% #{tag} footer.html %}").render!(payload, info)
end

Benchmark.ips do |x|
  x.report('cached')   { parse 'include', payload, info }
  x.report('uncached') { parse 'include_woc', payload, info }
end
