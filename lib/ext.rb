# Convenience method for converting from radians to a Vec2 vector.
class Numeric
  def radians_to_vec2
    CP::Vec2.new(Math::cos(self), Math::sin(self))
  end
end

class Float 
	# Normal floating point infinity. For your convenience.
	INFINITY = 1.0/0.0
end
