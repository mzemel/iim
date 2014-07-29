module IIM
  class MeanGenerator

    attr_accessor :data_set,
                  :filename

    def initialize(filename)
      self.filename = filename
      self.data_set = DataSet.new
    end

    def perform!
      File.open(filename, 'r') do |file|
        file.each_line do |item|
          self.data_set << item.to_i
          if data_set.size > 3
            puts "#{data_set.size}: #{"%.2f" % data_set.interquartile_mean}"
          end
        end
      end
    end
  end
end
