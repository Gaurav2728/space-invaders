class Showtime
  include ActiveModel::Model
  attr_reader :radar, :space_invaders, :threshold

  def initialize(options = {})
    @radar     = options[:radar]
    @threshold = options[:threshold] || 0.80
    @space_invaders = options[:space_invaders]
    @border_character = 'x'
  end

  # start building the entire game (space invaders)
  def start
    invaders, radar_image = read_files
    validate_measurements(invaders, radar_image.first)
    border_height, border_width = border_calculations(invaders)
    new_image = new_bordered_image(radar_image.first, border_height, border_width, @border_character)
    bordered_image = apply_border(radar_image.first, border_height, border_width, new_image)

    matrix = invaders.map do |invader|
      MatrixCalculation.new(invader, @border_character, bordered_image).calculate
    end

    result = merge_similarities(matrix, radar_image.first, border_height, border_width, invaders)
    format_output(result)
  end

  private

  def read_files
    invaders_images = InputReader.new(space_invaders).process
    space_invaders = invaders_images.each_with_index.map do |invader_image, index|
      SpaceInvader.new(index + 1, invader_image)
    end

    radar_content = InputReader.new(radar).process
    radar_images = radar_content.each_with_index.map do |image, index|
      Radar.new("Radar Image ##{index + 1}", image)
    end

    return space_invaders, radar_images
  end

  def validate_measurements(invaders, radar_image)
    min_radar_height = invaders.max_by(&:height).height
    min_radar_width = invaders.max_by(&:width).width

    if radar_image.height >= min_radar_height && radar_image.width >= min_radar_width
      return
    else
      raise StandardError.new "Invalid input !!"
    end
  end

  def border_calculations(invaders)
    border_height = (invaders.max_by(&:height).height / 2.0).round
    border_width = (invaders.max_by(&:width).width / 2.0).round

    return border_height, border_width
  end

  # Create a new full bordered image
  def new_bordered_image(radar_image, border_height, border_width, border)
    Array.new(radar_image.height + (border_height * 2)) do
      Array.new(radar_image.width + (border_width * 2), border)
    end
  end

  def apply_border(radar_image, border_height, border_width, bordered_image)
    radar_image.noise[0..radar_image.height].each_with_index do |row, row_index|
      width_range = border_width..(border_width + radar_image.width - 1)
      bordered_image[border_height + row_index][width_range] = row
    end

    Radar.new(radar_image.id, bordered_image)
  end

  def merge_similarities(similarity_matrices, radar_image, border_height, border_width, invaders)
    output = Array.new(radar_image.height) { Array.new(radar_image.width, '-') }

    similarity_matrices.each_with_index do |similarity_matrix, index|
      subset = similarity_subset(similarity_matrix, border_height, border_width, radar_image)

      subset.each_with_index do |row, index_x|
        row.each_with_index do |element, index_y|
          output[index_x][index_y] = invaders[index].name if element > @threshold
        end
      end
    end

    output
  end

  # Subset the similarity matrix ignoring the borders values
  def similarity_subset(similarity_matrix, border_height, border_width, radar_image)
    max_range = (radar_image.height + border_height - 1)
    similarity_matrix[border_height..max_range].map do |row|
      row[border_width..(radar_image.width + border_width - 1)]
    end
  end

  def format_output(matrix)
    matrix.map { |row| "#{row.join} \n" }.join
  end
end
