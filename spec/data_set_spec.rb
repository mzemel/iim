require_relative '../lib/iim/mean_generator'
require_relative '../lib/iim/data_set.rb'
require 'spec_helper'

describe IIM::DataSet do
  before(:each) do
    @ds = IIM::DataSet.new
    @ds << 1
    @ds << 2
    @ds << 3
    @ds << 4
  end

  it "has an accurate size" do
    expect(@ds.size).to eq(4)
  end

  it "calculates a correct interquartile range" do
    expect(@ds.interquartile_range).to eq([2,3])
  end

  it "has a correct boundary modifier" do
    expect(@ds.boundary_modifier).to eq(1)
    @ds << 5
    expect(@ds.boundary_modifier).to eq(0.75)
  end

  it "correctly calculates the interquartile mean" do
    expect(@ds.interquartile_mean).to eq(2.5)
    @ds << 5
    expect(@ds.interquartile_mean).to eq(3)
  end
end
