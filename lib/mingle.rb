require 'mingle/engine'
require 'mingle/configuration'
require "mingle/concerns"

require 'twitter'
require 'fb_graph'
require 'instagram'

require 'refile/rails'
require 'refile/image_processing'

module Mingle
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Mingle::Configuration.new
    end

    # Set temporary configuration options for the duration of the given block.
    #
    # options - A Hash describing temporary configuration options.
    def temporarily options = {}
      original = @config.dup

      options.each do |key, value|
        @config.send "#{key}=", value
      end

      yield
    ensure
      @config = original
    end
  end
end
