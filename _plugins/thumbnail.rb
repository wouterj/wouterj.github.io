module Jekyll

    class Post

        alias_method :to_liquid_org, :to_liquid
        def to_liquid
            vars = to_liquid_org

            if vars.has_key?('thumbnail')
                date = Date.parse(vars['date'].to_s).to_s.split('-')
                vars['thumbnail_url'] = '/' + File.join('img', date[0], date[1], vars['thumbnail'])
            end

            vars
        end

    end

    class Page
    
        alias_method :to_liquid_org, :to_liquid
        def to_liquid
            vars = to_liquid_org

            if vars.has_key?('thumbnail')
                date = Date.parse(vars['date'].to_s).to_s.split('-')
                vars['thumbnail_url'] = '/' + File.join('img', date[0], date[1], vars['thumbnail'])
            end

            vars
        end

    end

end
