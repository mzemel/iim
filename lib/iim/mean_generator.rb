module IIM
  class MeanGenerator

    attr_accessor :data_set

    def initialize(filename, sample_size = nil)
      self.data_set = DataSet.new
    end
