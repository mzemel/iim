require_relative 'iim/data_set'
require_relative 'iim/mean_generator'

module IIM
  def self.perform!(filename = 'data.txt')
    mean_generator = MeanGenerator.new(filename)
    mean_generator.perform!
  end
end

IIM.perform!
