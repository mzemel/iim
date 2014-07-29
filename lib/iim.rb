require_relative 'iim/data_set'
require_relative 'iim/mean_generator'

module IIM
  def self.perform(filename = 'data.txt', sample_size = nil)
    mean_generator = MeanGenerator.new(filename, sample_size)
    mean_generator.print!
  end
end
