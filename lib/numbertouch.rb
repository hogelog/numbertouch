# frozen_string_literal: true

require_relative "numbertouch/version"
require_relative "numbertouch/canvas"
require_relative "numbertouch/canvas_number"
require_relative "numbertouch/cli"
require_relative "numbertouch/region"

module Numbertouch
  class Error < StandardError; end
end
