module Numbertouch
  class Region
    attr_reader :x, :y, :width, :height, :top, :bottom, :left, :right

    def initialize(x, y, width, height)
      @left = @x = x
      @top = @y = y
      @width = width
      @height = height
      @bottom = y + height
      @right = x + width
    end

    def intersect?(other)
      left <= other.right && other.left <= right && top <= other.bottom && other.top <= bottom
    end
  end
end
