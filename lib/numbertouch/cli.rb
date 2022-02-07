module Numbertouch
  class CLI
    def initialize(argv)
      @path = argv.last
    end

    def run
      canvas = Canvas.new
      canvas.save(@path)
    end
  end
end
