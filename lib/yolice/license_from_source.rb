module Yolice

  class LicenseFromSource
    attr_reader :source_text

    def initialize(gem_name)
      puts "Looking for #{gem_name}..."
      get_uri_base(gem_name)
      @source_text = @uri_base ? get_source_file : false
    end

    def has_source_license?
      return @source_text
    end

    private
      def get_uri_base(gem_name)
        generate_uri_base(match_uri(get_gem_source_uri(gem_name)))
      end

      def get_gem_source_uri(gem_name)
        info = Gems.info(gem_name)
        puts "in get_gem_source_uri"
        info.has_key?('source_code_uri') && !info['source_code_uri'].nil? ? info['source_code_uri'] : nil
      end

      def match_uri(uri)
        puts "in match_uri"
        /^http(s){,1}:\/\/github.com\/(?<user>\w+)\/(?<repo>\w+)(\/){,1}$/.match uri
      end

      def generate_uri_base(match_obj)
        puts "in generate_uri_base"
        @uri_base = match_obj.nil? ? false : "https://raw.github.com/#{match_obj[:user]}/#{match_obj[:repo]}/master/"
        puts "uri_base = #{@uri_base}"
      end

      def get_source_file
        puts "in get_source_file"
        ['LICENSE', 'LICENSE.md', 'LICENSE.markdown'].each do |suffix|
          puts "#{@uri_base+suffix}"
          res = Net::HTTP.get_response(@uri_base+suffix)
          return res.body if res.code == '200'
        end
        false
      end

  end
end