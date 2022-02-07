require "erb"

module Numbertouch
  class Canvas

    A4 = [3508, 2480]

    NUMBER_DATA_30 = {200 => 10, 300 => 15, 400 => 5}
    DEFAULT_MARGIN = 50

    attr_reader :paper_size,:width, :height, :numbers

    def initialize(paper_size: A4, number_data: NUMBER_DATA_30, margin: DEFAULT_MARGIN)
      @paper_size = paper_size
      @width = paper_size[0]
      @height = paper_size[1]

      sized_numbers = number_data.map{|size, count| [size]*count }.flatten.shuffle.map.with_index(1).to_a.shuffle
      @numbers = build(A4[0], A4[1], [], sized_numbers, margin: margin)
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
