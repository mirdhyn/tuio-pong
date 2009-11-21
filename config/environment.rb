require 'rubygems'
require 'gosu'
require 'chipmunk'
require 'tuio-ruby'
require 'RMagick'
require 'gl'
require 'glu'

require 'lib/dependencity/dependencity.rb'
require 'lib/ext.rb'
require 'lib/chipmunk_object.rb'

include Gosu
include CP::Object
include Gl
include Glu

loader = Dependencity.new
loader.add_dir "app"
loader.process_directories

