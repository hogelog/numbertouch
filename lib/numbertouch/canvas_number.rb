require "erb"
require "forwardable"

module Numbertouch
  class CanvasNumber
    extend Forwardable

    attr_reader :n, :region, :x, :y, :r, :cx, :cy, :font
    delegate [:x, :y, :width, :height, :top, :bottom, :left, :right] => :@region

    def initialize(n, r, region)
      @n = n
      @region = region
      @r = r
      @cx = region.x + region.width / 2
      @cy = region.y + region.height / 2
      @font = r
    end
  end
end
