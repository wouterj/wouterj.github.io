module Jekyll
  module Filters
    def excerpt(content)
      content.match('<!--more-->') ? content.split('<!--more-->').first : content
    end
  end
end
