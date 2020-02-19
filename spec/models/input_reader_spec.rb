require 'rails_helper'

RSpec.describe InputReader, type: :model do

  it 'return an array of space invaders' do
    file = InputReader.new('test/fixtures/space_invaders').process
    expect(file.first).to eq([['-','-','o','-','-','-','-','-','o','-','-'],
                              ['-','-','-','o','-','-','-','o','-','-','-'],
                              ['-','-','o','o','o','o','o','o','o','-','-'],
                              ['-','o','o','-','o','o','o','-','o','o','-'],
                              ['o','o','o','o','o','o','o','o','o','o','o'],
                              ['o','-','o','o','o','o','o','o','o','-','o'],
                              ['o','-','o','-','-','-','-','-','o','-','o'],
                              ['-','-','-','o','o','-','o','o','-','-','-']])
    expect(file.last).to include(['o', 'o', '-', 'o', 'o', '-', 'o', 'o'])
  end

  it 'raise error for invalid path' do
    expect do
      InputReader.new('invalid address').process
    end.to raise_error(Errno::ENOENT)
  end
end
