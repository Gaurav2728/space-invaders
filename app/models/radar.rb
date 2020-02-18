class Radar
  include ActiveModel::Model
  attr_accessor :id, :noise

  def initialize(id, noise)
    @id    = id
    @noise = noise
  end

  # The noise height
  def height
    noise.size
  end

  # The noise width
  def width
    noise.empty? ? 0 : noise.first.size
  end

  # The noise between the two ranges
  def noise_range(row_range, column_range)
    noise[row_range].map { |row| row[column_range] }
  end
end
