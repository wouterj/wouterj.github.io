require 'octokit'
require 'digest/sha1'
require 'json'

module OssList
  class OssListGenerator < Jekyll::Generator
    def initialize(config = {})
      @client = Octokit::Client.new()
      @@cacheDir = File.join(__dir__, '..', '.gh-cache')
      Dir::mkdir(@@cacheDir, 0700) unless File.exists? @@cacheDir
    end

    def generate(site)
      site.data['oss'] = site.data['oss'].map do |issue|
        if issue.key?('nr')
          issue = issue.merge(fetchInfo(issue['repo'], issue['nr']))
        else
          issue['url'] = "https://github.com/#{issue['repo']}"
          issue
        end
      end
    end

    def fetchInfo(repo, id)
      hash = Digest::SHA1.hexdigest "#{repo}-#{id}"
      cacheFile = File.join(@@cacheDir, hash)
      if File.exists? cacheFile
        return JSON.parse(File.read cacheFile)
      end

      ghInfo = @client.issue(repo, id)
      info = {
        'url' => ghInfo.html_url,
        'title' => ghInfo.title.gsub(/^\[.+\] /, '').capitalize
      }

      File.write(cacheFile, JSON.dump(info))

      return info
    end
  end
end
