class Game < Window
  attr_reader :space
  
  def initialize
    super(WIDTH, HEIGHT, false, 16)
    self.caption = "Pong FingerZ"
    
    background = Magick::ImageList.new( "media/Space.png").adaptive_resize(WIDTH, HEIGHT)
    @background_image = Image.new(self, background, true) # turn the rmagick image into a Gosu one
    
    @tuio = TuioClient.new
    @tuio.start
    manage_tuio_events
    
    @ball = Ball.new(self)
    @player1 = Player.new(self)
    @player2 = Player.new(self)
    @font = Font.new(self, Gosu::default_font_name, 20)
    
    @space = CP::Space.new
    @space.iterations = 3
    @space.elastic_iterations = 3
    @space.gravity = CP::Vec2.new(0,0)    
    @space.damping = 1.0
    @space.add_object(@ball)
    @dt = (1.0/60.0) # @dt is the amount of time between each physic substep.
  end
  
  def update
    @ball.update
    
    if @ball.body.p.x < 0 
      @player2.score += 1
      @ball.start
    end
    
    if @ball.body.p.x > WIDTH
      @player1.score += 1
      @ball.start
    end
    @space.step(@dt)
  end
  
  def manage_tuio_events
    #
    @tuio.on_cursor_creation do | cursor |
      @player1.add_cursor( cursor ) if cursor.x_pos < 0.5
      @player2.add_cursor( cursor ) if cursor.x_pos > 0.5
      @space.rehash_static
    end
    # If the cursor go away from player area then destroyed
    # else updated to the right player cursors list
    @tuio.on_cursor_update do | cursor |
      if cursor.x_pos < 0.5
        @player1.update_cursor( cursor ) if @player1.has_cursor? cursor
        @player2.remove_cursor( cursor ) if @player2.has_cursor? cursor
      end
      if cursor.x_pos > 0.5
        @player2.update_cursor( cursor ) if @player2.has_cursor? cursor
        if @player1.has_cursor? cursor
          @player1.remove_cursor( cursor ) 
        end
      end
      @space.rehash_static
    end
    #    
    @tuio.on_cursor_removal do | cursor |
      @player1.remove_cursor( cursor ) if cursor.x_pos < 0.5
      @player2.remove_cursor( cursor ) if cursor.x_pos > 0.5
      @space.rehash_static
    end
  end
  
  
  def draw
  
    @background_image.draw(0, 0, ZOrder::Background)
    
    @white = Color.new(200,255,255,255)
    
    
    draw_line(CENTER_X, 0, @white, CENTER_X, HEIGHT, @white, ZOrder::Background)
    
    @ball.draw
    @player1.draw
    @player2.draw
    @font.draw("#{@player1.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    @font.draw("#{@player2.score}", WIDTH - 20, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end
end

