module Jekyll

    class ArchivePage < Page

        def initialize site, base, dir
            @site = site
            @base = base
            @dir = '/' + dir
            @name = ''

            self.process(@name)
            self.read_yaml(File.join(base, '_layouts'), 'list.html')

            self.data['title'] = "Archief"
        end

    end

    class ListPager < Pager

        def base_url= url
            @base_url = url
        end

        def initialize(config, page, all_posts, per_page = nil, num_pages = nil)
            @page = page
            @per_page = per_page.to_i || config['paginate'].to_i
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

        alias_method :org_to_liquid, :to_liquid
        def to_liquid
            vars = org_to_liquid

            if nil == @base_url
                vars['base_url'] = ''
            else
                vars['base_url'] = @base_url
            end

            vars
        end
        
    end

    class Site

        def write_archive(archive_dir)
            posts = self.posts.sort_by {|post| post.date}.reverse
            pages = ListPager.calculate_pages(posts, self.config['archive_paginate'].to_i)
            index = nil

            (1..pages).each do |page_num|
                pager = ListPager.new(self.config, page_num, posts, self.config['archive_paginate'], pages)
                pager.base_url = "/#{archive_dir}"

                page = ArchivePage.new(self, self.source, archive_dir)
                page.pager = pager

                if page_num == 1
                    self.pages << page.clone
                end

                page.dir = '/' + File.join(archive_dir, "page/#{page_num}")

                self.pages << page
            end
        end

    end

    class ArchiveGenerator < Generator

        def generate(site)
            site.write_archive('archive')
        end

    end

end
