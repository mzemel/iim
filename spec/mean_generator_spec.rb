require_relative '../lib/iim/mean_generator'
require_relative '../lib/iim/data_set.rb'
require 'spec_helper'

describe IIM::MeanGenerator do

  before(:each) do
    @mg = IIM::MeanGenerator.new('spec/fixtures/sample.txt')
  end

  it "contains a filename reference" do
    expect(@mg.respond_to?(:perform!)).to be_truthy
    expect(@mg.filename).to be_a_kind_of(String)
  end

  it "performs without raising an error" do
    expect{@mg.perform!}.to_not raise_error
  end

end
