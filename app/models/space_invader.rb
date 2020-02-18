class SpaceInvader
  include ActiveModel::Model
  attr_accessor :name, :invaders_image

  def initialize(name, invaders_image)
    @name  = name
    @invaders_image = invaders_image
  end

  # Invader image height
  def height
    invaders_image.size
  end

  # Invader image width
  def width
    invaders_image.empty? ? 0 : image.first.size
  end
end
