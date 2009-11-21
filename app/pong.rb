require 'config/environment.rb'

WIDTH = 800
HEIGHT = 600
CENTER_X = WIDTH / 2.0
CENTER_Y = HEIGHT / 2.0

module ZOrder
  Background, Objects, UI = *0..3
end

Game.new.show
