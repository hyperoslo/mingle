require 'mingle/engine'
require 'mingle/configuration'

require 'twitter'
require 'fb_graph'
require 'instagram'

module Mingle
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Mingle::Configuration.new
    end
  end
end
