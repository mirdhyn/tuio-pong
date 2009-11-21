class Ball
  include CP::Object
  attr_reader :body, :shape

  def initialize(window)
    @window = window
    @image = Gosu::Image.new(window, "media/ball.png", false)
    @radius = 15.0
    @mass = 20.0
    @body = CP::Body.new(@mass,Float::INFINITY)
    @shape = CP::Shape::Circle.new(@body, @radius, CP::Vec2.new(0.0, 0.0))
    @shape.e = 1.0  # Elasticity
    @shape.u = 0.0  # Friction
    @shape.collision_type = :ball
    init_chipmunk_object(@body,@shape)
    start
  end
  
  def start
  # Start the ball : Set to the center, randomize angle and apply impulsion.
    @body.p = CP::Vec2.new(CENTER_X, CENTER_Y) # position
    @body.v = CP::Vec2.new(0.0, 0.0)
    @body.a = random_radian
    @body.apply_impulse((@body.a.radians_to_vec2 * 3000), CP::Vec2.new(0.0, 0.0))
  end
  
  def update
    # Manage collisions with walls (up and down)
    @body.v.y = -@body.v.y if ( (@body.p.y - @radius) < 0 || (@body.p.y + @radius) > HEIGHT )
  end
  
  def draw
    @image.draw_rot(@body.p.x, @body.p.y, 100, @body.a.radians_to_gosu)
  end
  
  private
  
  def random_radian
    # without UP (3*PI/2) and DOWN (1*PI/2) for more playability
    rnd = rand(50)
    rnd = rand(50) while ( rnd == 30 or rnd == 10 )
    rnd * Math::PI/20.0
  end
end
