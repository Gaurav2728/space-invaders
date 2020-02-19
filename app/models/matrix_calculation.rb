class MatrixCalculation
  attr_reader :invader, :border, :bordered_image, :matrix

  def initialize(invader, border, bordered_image)
    @invader        = invader
    @border         = border
    @bordered_image = bordered_image
  end

  # Calculate the similarity matrix between the bordered radar image and the space invader
  def calculate
    max_row_index, max_column_index = setup

    bordered_image.noise[0..max_row_index].each_with_index do |row, row_index|
      row[0..max_column_index].each_with_index do |_, index|
        row_range, column_range = calculate_window_range(row_index, index, invader)
        radar_window = bordered_image.noise_range(row_range, column_range)
        similarity = window_similarity(invader, radar_window)
        update_similarity(matrix, similarity, row_range, column_range) if similarity
      end
    end

    matrix
  end

  private

  # Create new similarity matrix and calculate the max row and column indexes
  def setup
    @matrix = Array.new(bordered_image.height) { Array.new(bordered_image.width, 0) }

    max_row_index = (bordered_image.height - invader.height)
    max_column_index = (bordered_image.width - invader.width)

    return max_row_index, max_column_index
  end

  # Calculate the range of radar image window under comparison
  def calculate_window_range(row_index, index, invader)
    row_range = (row_index..(invader.height + row_index - 1))
    column_range = (index..(invader.width + index - 1))

    return row_range, column_range
  end

  def window_similarity(invader, radar_window)
    return unless radar_window.flatten.count(border) < (radar_window.flatten.size / 2.0)
    window_comparison(radar_window, invader)
  end

  def window_comparison(radar_window, invader)
    equal_pixels = radar_window.zip(invader.invaders_image).map do |x, y|
      x.zip(y).map do |w, z|
        w == z if w != border
      end
    end

    equal_pixels = equal_pixels.flatten.compact
    equal_pixels.count(true) / equal_pixels.size.to_f
  end

  # Update the similarity matrix with the new similarity
  def update_similarity(matrix, similarity, row_range, column_range)
    row_range.to_a.each do |i|
      column_range.to_a.each do |j|
        matrix[i][j] = similarity if matrix[i][j] < similarity
      end
    end
  end
end
