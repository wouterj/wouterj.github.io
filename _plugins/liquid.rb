module Jekyll
    module Filters
        def site_specific(content)
            content = content.sub('<p>', '<p class="post__intro">')
            content = content.sub('</p>', '</p><div class="cf"></div>')

            content = content.gsub('<pre>', '<pre class="prettyprint  linenums">"')
            content = content.gsub('<img', '<img class="img--stripe"')

            content
        end
    end
end
