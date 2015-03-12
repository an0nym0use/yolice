require 'yaml'
require 'ostruct'
require 'colorize'

class String
  alias_method :forbidden, :red
  alias_method :permitted, :green
  alias_method :required, :yellow
end

module Yolice

  class YoLicense
    attr_reader   :license_features
    attr_reader   :licenses
    attr_reader   :raw_licenses
    attr_reader   :features

    def initialize
      get_raw_licenses
      @licenses = []
      @features = {}
      @license_features = OpenStruct.new.marshal_load(load_license_config)
    end

    def match_licenses
      @raw_licenses.each do |gem_license|
        @licenses << fetch_most_likely(compare_to_licenses(gem_license))
      end
      self
    end

    def col_features
      @licenses.each do |l|
        @license_features["licenses"][l].each do |f|
          unless @features.include? f["feature"] && @features[f["feature"]] == "forbidden"
            @features[f["feature"]] = f["permission"]
          end
        end
      end
      self
    end

    def print_explanations
      puts "Here is your license situation: "
      puts "=" * 20
      @features.each do |f|
        puts "#{@license_features["features"][f[0]]["name"]} - #{@license_features["features"][f[0]][f[1]]}".send f[1]
      end
    end

    private
      def load_license_config
        YAML.load_file(File.join File.dirname(__FILE__), 'licenses', 'license_features.yml')
      end

      def get_raw_licenses
        @raw_licenses = []
        Gem::Specification.each do |g|
          if g.licenses.count > 0
            @raw_licenses << g.licenses
          end
        end
        @raw_licenses.flatten!.uniq!
      end

      def preprocess_raw_license(raw_text)
        raw_text.downcase.gsub(/[\.\-\s]/, "_")
      end

      def compare_to_licenses(gem_license)
        map_results @license_features["licenses"].keys.map {|license_name| SorensenIndex.index(preprocess_raw_license(gem_license), license_name)}
      end

      def map_results(results)
        Hash[@license_features["licenses"].keys.flatten.zip results]
      end

      def fetch_most_likely(result_hash)
        result_hash.max_by {|k,v| v}[0]
      end
  end

end

