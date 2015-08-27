module Spiqule
  class Parser
    def self.build(type)
      new(type).build
    end

    def initialize(type)
      @type = type
    end

    def build
      parser_class.new
    end

    private

    def parser_class
      case @type
      when "select"
        Parsers::Select
      else
        raise "Parser class (type=#{@type}) is not found"
      end
    end
  end
end
