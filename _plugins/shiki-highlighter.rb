require "shellwords"
require 'digest/sha1'

module Kramdown::Converter
  module SyntaxHighlighter
    module Shiki
      VERSION = '0.1.0'
      @@cacheDir = File.join(__dir__, '..', '.shiki-cache')
      Dir::mkdir(@@cacheDir, 0700) unless File.exists? @@cacheDir

      def self.call(converter, text, lang, type, call_opts)
        if type == :span
          CGI::escapeHTML(text)
        else
          self.render_shiki(text, lang)
        end
      end

      def self.render_shiki(text, lang)
        hash = Digest::SHA1.hexdigest "#{text}-#{lang}"
        cacheFile = File.join(@@cacheDir, hash)
        if File.exists? cacheFile
          return File.read cacheFile
        end

        highlighted = self.call_shiki(text, lang)
        File.write(cacheFile, highlighted)
        highlighted
      end

      def self.call_shiki(text, lang)
          text = Shellwords.shellescape(text)
          `node _plugins/shiki.js #{text} #{lang}`
      end
    end
  end

  add_syntax_highlighter(:shiki, SyntaxHighlighter::Shiki)
end
