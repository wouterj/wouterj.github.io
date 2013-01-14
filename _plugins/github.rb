require 'github_api'

module Jekyll
    class GithubRepoTag < Liquid::Tag

        def initialize(tag_name, username, tokens)
            @username = username
        end

        def parseApi()
            repos = Github.repos.list user: 'WouterJ'
            repos = repos.select { |r|
                r.fork
            }
            @repos = repos.map { |r|
                "<a href=\"#{ r.html_url }\">#{r.name}</a>"
            }
        end

        def render(context)
            if nil == @repos
                self.parseApi
            end

            @repos.shuffle.take(10).join(", ")
        end

    end
end

Liquid::Template.register_tag('github_user', Jekyll::GithubRepoTag)
