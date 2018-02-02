# 1. In traditional object-oriented design, what is the purpose of an interface and how is it different from an abstract class?

# 2. Create an "interface called “Shape” with one method getArea.

# 3. Create a concrete “Circle” class that implements your interface. Add everything that is necessary for us to be able to create an instance of a Circle and to compute its area.

# 4. Write unit tests for the getArea method of the Circle class.

# 5. Now we want to add a draw() method to our interface. It should accept 3 parameters: integer x, y coordinates for the location on the output device where the origin of the shape should be located, and the third parameter is a supported graphics library instance. The provided library should be used to render the shape to the output device. Basically, we want the developer to specify the graphics library at call time.

# Sample graphics library interfaces (entirely fictional and greatly simplified for the exercise):
# class GD {
#     public void gd_point(int x, int y) { }
#     public void gd_line(int x1, int y1, int x2, int y2) { }
#     public void gd_circle(int x, int y, double radius) { }
#     // ...
# }

# class ImageMagick {
#     public void drawPoint(int y, int x) { }
#     public void drawLine(int y1, int x1, int y2, int x2) { }
#     public void drawArc(int y, int x, double radius, double degrees) { }
#     // ...
# }

# class Foo {
#     public void point(int x, int y);
# }


require 'rspec/autorun'


class GDInterface
  def graphics_library
    ::GD
  end
  
  def draw(object)
    method = object.class.name.downcase
    graphics_library.send(method, object.centroid[0], object.centroid[1], ...object)
  end
end


class Shape
  def get_area
    raise NoMethodError, "must be implemented by child class"
  end
  
  def centroid
    raise NoMethodError, "must be implemented by child class"
  end
  
  def draw(x, y, graphics_library)
    raise NoMethodError, "#draw must be implemented by child class"
  end
end


class Circle < Shape
  attr_accessor :radius
  
  def initialize(radius)
    super()
    raise(ArgumentError, "radius is not an integer") unless radius.is_a?(::Numeric)
    @radius = radius
  end
  
  def centroid
    [x, y]
  end
  
  def get_area
    Math::PI * @radius ** 2
  end
  
  def draw(x, y, graphics_library)
    glibrary = "#{graphics_library.class.name}Interface".constantize
    glibrary.draw(x, y)
  end
end

RSpec.describe Circle do
  it 'accepts a radius as a parameter' do
    expect(Circle.new(3).radius).to eq(3)
  end
  
  it 'raises ArgumentError if radius not given' do
    expect {
      Circle.new()
    }.to raise_error(ArgumentError)
  end
  
  it 'raises ArgumentError if radius not a Numeric type' do
    expect {
      Circle.new("hello")
    }.to raise_error(ArgumentError)
  end
  
  it 'returns area if radius exists' do
    expect(Circle.new(3).get_area).to eq(28.274333882308138)
  end
  
  it 'returns area if radius is a float' do
    expect(Circle.new(3.5).get_area).to eq(38.48451000647496)
  end
end
