class Racket
  include CP::Object
  SCROLLS_PER_STEP = 50
  attr_reader :shape, :cursors
  
  def initialize( window, cursor1, cursor2 )
    @white = Color.new(200,255,255,255)
    @window = window
    @cursors = [cursor1, cursor2]
    @radius = 2.0
    @body = CP::Body.new(Float::INFINITY,Float::INFINITY)
    @shape = nil
    update
  end
  
  def draw
    #@window.draw_line( @x1, @y1, @white, @x2, @y2, @white, ZOrder::Objects )
    @window.draw_quad( (@x1.to_int - @radius.to_int), (@y1.to_int - @radius.to_int), @white,\
                       (@x2.to_int - @radius.to_int), (@y2.to_int - @radius.to_int), @white,\
                       (@x1.to_int + @radius.to_int), (@y1.to_int + @radius.to_int), @white,\
                       (@x2.to_int + @radius.to_int), (@y2.to_int + @radius.to_int), @white, ZOrder::Objects)
  end
  
  def has_cursor?( cursor_id )
    if (@cursors.index { |cursor| cursor.session_id == cursor_id } )
      then true else false
    end
  end
  
  def update_cursor(id, cursor)
    @cursors[@cursors.index{|cursor| cursor.session_id == id }] = cursor
    update
  end
  
  private
  
  def update
    @x1 = Float( @cursors[0].x_pos * WIDTH  )
    @y1 = Float( @cursors[0].y_pos * HEIGHT )
    @x2 = Float( @cursors[1].x_pos * WIDTH  )
    @y2 = Float( @cursors[1].y_pos * HEIGHT )
    @window.space.remove_static_shape (@shape) if @shape != nil
    @shape = CP::Shape::Segment.new(@body, CP::Vec2.new(@x1, @y1), CP::Vec2.new(@x2, @y2), @radius)
    @shape.e = 1.0  # Elasticity
    @shape.u = 0.1  # Friction
    @shape.collision_type = :racket
    @window.space.add_static_shape(@shape)
  end
  
end
