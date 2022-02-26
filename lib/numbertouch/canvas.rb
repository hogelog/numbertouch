require "erb"

module Numbertouch
  class Canvas

    attr_reader :paper_size, :width, :height, :numbers

    def initialize(option)
      @paper_size = option.paper_size
      @width = option.paper_size[0]
      @height = option.paper_size[1]

      sizes = option.number_data.map{|size, count| [size]*count }.flatten.sort
      sized_numbers = sizes.zip((1..sizes.size).to_a.shuffle)
      @numbers = build(width, height, [], sized_numbers, margin: option.margin)
      abort "Cannot build image" unless @numbers
    end

    TRY_COUNT = 10

    def build(width, height, result, sized_numbers, margin:)
      return result if sized_numbers.empty?

      sized_number = sized_numbers.pop
      TRY_COUNT.times do
        size = sized_number[0]
        n = sized_number[1]
        x = rand(width - size - margin)
        y = rand(height - size - margin)
        candidate = Region.new(x, y, size + margin*2, size + margin*2)
        if result.none?{|number| candidate.intersect?(number.region) }
          result.push(CanvasNumber.new(n, size / 2, candidate))
          if build(width, height, result, sized_numbers, margin: margin)
            return result
          else
            result.pop
          end
        end
      end

      sized_numbers.push(sized_number)
      nil
    end

    def render
      erb = ERB.new(File.read(File.join(File.dirname(__FILE__), "template.svg.erb")))
      erb.result_with_hash(debug: ENV["DEBUG"], width: width, height: height, numbers: numbers)
    end

    def save(path)
      File.write(path, render)
    end
  end
end
