class Player
  attr_accessor :score,  :rackets
  
  def initialize(window)
    @score = 0
    @window = window
    @cursors = {}
    @orphan_cursor = nil
    @rackets = []
  end
  
  def add_cursor( cursor )
    @cursors[cursor.session_id] = cursor
    if @orphan_cursor != nil
      @rackets << Racket.new( @window, @orphan_cursor, TuioCursor.from_params( cursor ) )
      @orphan_cursor = nil
    else
      @orphan_cursor = TuioCursor.from_params( cursor )
    end
  end
  
  def update_cursor( cursor )
    @cursors[cursor.session_id].update_from_params( cursor )
    @rackets.each do | racket |
      racket.update_cursor( cursor.session_id, cursor ) if racket.has_cursor? cursor.session_id
    end
  end
  
  def remove_cursor( cursor )
    @cursors.delete(cursor.session_id)
    if @orphan_cursor != nil
      if @orphan_cursor.session_id == cursor.session_id
        @orphan_cursor = nil
      else
        @rackets.each do | racket |
          if racket.has_cursor? cursor.session_id
            racket.update_cursor( cursor.session_id, @orphan_cursor )
            @orphan_cursor = nil
          end
        end   
      end
    else # There is no orphan cursor
      @rackets.each do |racket|
        if racket.has_cursor? cursor.session_id
          racket.cursors.each do |c|
            if c.session_id != cursor.session_id
              @orphan_cursor = c
            end
          end
        end
      end
      # Delete racket and racket shapes
      @rackets.select {|r| r.has_cursor? cursor.session_id }.each do |racket|
        @window.space.remove_static_shape (racket.shape)
      end
      @rackets.delete_if {|racket| racket.has_cursor? cursor.session_id }
    end
  end
  
  def has_cursor?( cursor )
    @cursors.has_key? cursor.session_id
  end
  
  def draw
    @rackets.each {|racket| racket.draw }
  end
  
end
