class InputReader
  attr_accessor :path, :input

  def initialize(path)
    @path = path
    @input = []
  end

  # An array of input
  def process
    @truncate_lines = false
    read_lines
    input
  end

  private

  def read_lines
    File.readlines(path).each do |line|
      if line.strip == '~~~~'
        @truncate_lines = !@truncate_lines
        input_entity
        next
      end
      @entity << line.strip.split('') if @truncate_lines
    end
  end

  def input_entity
    if @truncate_lines
      new_entity
    else
      insert_entity
    end
  end

  def new_entity
    @entity = []
  end

  def insert_entity
    input << @entity
  end
end
