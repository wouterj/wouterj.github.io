module OpenGraphPlugin
  class OgImageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.posts.docs.each do |post|
        title = CGI.escapeHTML(post.data['title'])
        category = post.data['categories'].empty? ? '' : CGI.escapeHTML(post.data['categories'].first)
        read_time = [post.content.split.length / 200, 1].max
        time = post.date.strftime('%d %^B \'%y')

        svg = to_svg(title, category, read_time, time).gsub(/\n/, '').gsub(/'/, '\\\'')
        filename = "#{post.data['slug']}.png"

        unless File.file? "#{site.source}/img/og/#{filename}"
          `echo '#{svg}' | inkscape --pipe -o #{site.source}/img/og/#{filename}`

          site.static_files << Jekyll::StaticFile.new(site, site.source, '/img/og/', filename)
        end
      end
    end

    def to_svg(title, category, read_time, time)
      lines = title.split.reduce(['']) do |acc, word|
        last = acc.pop
        if (last + ' ' + word).length > 24
          acc.push(last)
          acc.push(word)
        else
          acc.push(last + ' ' + word)
        end

        acc
      end

      lines = lines.map.with_index do |line, i|
        if i == 0
          "<tspan y=\"100\" x=\"170\">#{line}</tspan>"
        else
          "<tspan dy=\"65\" x=\"170\">#{line}</tspan>"
        end
      end

      return <<-EOS
        <svg xmlns="http://www.w3.org/2000/svg" width="680" height="340" viewBox="0 0 680 340">
          <rect x="0" y="0" width="680" height="340" fill="#fdfdfd"/>
              <rect x="40" y="60" width="105" height="105" fill="#cc3333"/>
          <g xmlns="http://www.w3.org/2000/svg" fill="#333333" transform="matrix(4,0,0,4,-0.00500038,-0.007504)">
            <path d="m 21.209081,27.637629 0.728079,7.224786 h 0.28003 l 1.344147,-13.19877 h 1.493496 l -1.493496,14.692266 h -2.968323 l -0.72808,-7.224786 h -0.317368 l -0.728079,7.224786 H 15.851164 L 14.357668,21.663645 h 1.493496 l 1.344146,13.19877 h 0.280031 l 0.728079,-7.224786 z"/>
            <path d="m 32.204922,33.854306 q 0,0.541392 -0.205356,1.026778 -0.205356,0.466717 -0.560061,0.821423 -0.354705,0.336036 -0.840091,0.541392 -0.466718,0.205356 -0.989441,0.205356 h -1.530834 q -0.541392,0 -1.026778,-0.205356 -0.466718,-0.205356 -0.821423,-0.541392 -0.336037,-0.354706 -0.541392,-0.821423 -0.205356,-0.485386 -0.205356,-1.026778 v -2.688293 h 1.493496 v 2.688293 q 0,0.466717 0.317368,0.784085 0.317368,0.317368 0.784085,0.317368 h 1.530834 q 0.448048,0 0.765416,-0.317368 0.336037,-0.317368 0.336037,-0.784085 V 23.157141 l -0.560061,-0.186687 v -1.306809 h 2.053557 z"/>
          </g>

              <text x="40" y="170" style="font-family:Oswald;line-height:1.5;font-size:50px;fill:#323232;font-weight:500;">
            #{lines.join("\n")}
          </text>
          <g style="font-size:20px;line-height:1.25;font-family:Oswald;fill:#4d4d4d;">
              <text text-anchor="start" x="40" y="280">#{category}, #{read_time} min read</text>
              <text xmlns="http://www.w3.org/2000/svg" text-anchor="end" y="280" x="640">#{time}</text>
          </g>
        </svg>
      EOS
    end
  end
end
