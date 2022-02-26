require "json"
require "optparse"

module Numbertouch
  class CLI
    Option = Struct.new(:paper_size, :number_data, :margin)

    PRESET_PAPER_SIZES = {
      "A4" => [3508, 2480],
      "B5" => [3035, 2150],
    }

    PRESET_DATASETS = {
      "A4_30" => [PRESET_PAPER_SIZES["A4"], {200 => 10, 300 => 15, 400 => 5}, 50],
      "A4_50" => [PRESET_PAPER_SIZES["A4"], {150 => 22, 200 => 18, 300 => 3, 400 => 7}, 30],
    }

    def initialize(argv)
      @option = Option.new(*PRESET_DATASETS["A4_30"])
      parser = OptionParser.new
      parser.on("-p", "--paper_size PAPER_SIZE", "Paper size: preset size (A4, B5) or NxN format string") { set_paper_size!(_1)  }
      parser.on("-n", "--number-data NUMBER_DATA", "Number object data: comma separated NxN format string like '200x10,300x15,400x5'") { set_number_data!(_1) }
      parser.on("-m", "--margin MARGIN", "Number object margin") { @option.margin = _1.to_i }
      parser.on("-s", "--preset PRESET", "Preset dataset: A4_30, A4_50") { set_preset_dataset!(_1) }
      parser.parse!(argv)
      @path = argv.first
    end

    def run
      canvas = Canvas.new(@option)
      canvas.save(@path)
    end

    private

    def set_paper_size!(arg)
      @option.paper_size = PRESET_PAPER_SIZES[arg.upcase] || arg.split("x").map(&:to_i)
    end

    def set_number_data!(arg)
      @option.number_data = Hash[*arg.split(",").map{ _1.split("x").map(&:to_i) }.flatten]
    end

    def set_preset_dataset!(arg)
      dataset = PRESET_DATASETS[arg]
      @option.paper_size = dataset[0]
      @option.number_data = dataset[1]
      @option.margin = dataset[2]
    end
  end
end
