module Jekyll
    module Filters
        def site_specific(content)
            content = content.sub('<p>', '<p class="post__intro">')
            content = content.sub('</p>', '</p><div class="cf"></div>')

            content = content.gsub('<pre>', '<pre class="prettyprint  linenums">')
            content = content.gsub('<img', '<img class="img--stripe"')

            content = content.gsub(/<p class='post-side'>(.*?): (.*?)<\/p>/, '<aside class="post-side" data-type="\\1"><p>\\2</p></aside>')

            content
        end
    end
end
