module Jekyll
 
  class FeaturedPostBlock < Liquid::Block
    include Liquid::StandardFilters
 
    def initialize(tag_name, markup, tokens)
      super
      @limit = markup.to_i - 1
    end
 
    def render(context)
      featured = context.registers[:site].posts.dup.sort_by { |p| -p.date.to_f }.delete_if { |p| !p.data.key?('featured') || p.data['featured'] == false }
      result = []
      
      context.stack do
        for post in featured[0..@limit] do
          context['post'] = post
          result << render_all(@nodelist, context)
        end
      end
    
      result
    end
 
  end
 
end
 
Liquid::Template.register_tag('featured_posts', Jekyll::FeaturedPostBlock)
