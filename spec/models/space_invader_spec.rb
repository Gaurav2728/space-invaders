require 'rails_helper'

RSpec.describe SpaceInvader, type: :model do
  subject do
    SpaceInvader.new('1st input',
                    [['-','-','-','o','o','-','-','-'],
                     ['-','-','o','o','o','o','-','-'],
                     ['-','o','o','o','o','o','o','-'],
                     ['o','o','-','o','o','-','o','o'],
                     ['o','o','o','o','o','o','o','o'],
                     ['-','-','o','-','-','o','-','-'],
                     ['-','o','-','o','o','-','o','-'],
                     ['o','-','o','-','-','o','-','o']])
  end

  it 'should have height and width' do
    space_invader = SpaceInvader.new('', [])
    expect(space_invader.height).to eq(0)
    expect(space_invader.width).to eq(0)
  end

  it 'should have initial value' do
    expect(subject.name).to eq('1st input')
  end

  it 'should have valid data' do
    expect(subject.name).to eq('1st input')
    expect(subject.height).to eq(8)
    expect(subject.width).to eq(8)
  end

  it 'should contain correct values' do
    expect(subject.invaders_image[0]).to eq(["-", "-", "-", "o", "o", "-", "-", "-"])
  end
end
