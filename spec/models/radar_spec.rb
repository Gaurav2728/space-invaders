require 'rails_helper'

RSpec.describe Radar, type: :model do
  subject do
    Radar.new('1st input',
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
    space_invader = Radar.new('', [])
    expect(space_invader.height).to eq(0)
    expect(space_invader.width).to eq(0)
  end

  it 'should have identifier' do
    expect(subject.id).to eq('1st input')
  end

  it 'should have valid properties' do
    expect(subject.id).to eq('1st input')
    expect(subject.height).to eq(8)
    expect(subject.width).to eq(8)
  end

  it 'should have data' do
    expect(subject.noise_range(1..2, 3..4)).to eq([["o", "o"], ["o", "o"]])
  end
end
