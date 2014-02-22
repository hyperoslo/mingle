require 'mingle/engine'

require 'twitter'
require 'fb_graph'
require 'instagram'

begin
  require 'sidekiq'
rescue LoadError
end

module Mingle
end
