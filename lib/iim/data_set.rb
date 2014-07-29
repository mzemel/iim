module IIM
  class DataSet
    include Enumerable

    attr_accessor :data,
                  :size

    def initialize
      self.data = []
      self.size = 0
    end

    def <<(item)
      self.size += 1
      self.data << item
    end

    # Used to truncate data set and get IQR upper & lower modifiers
    def fractional_quartile_size
      size / 4.0
    end

    # Multiply upper & lower IQR values when dataset not divisible by four, i.e.:
    # these values get partially reduced since they're only partial observations.
    #
    # http://en.wikipedia.org/wiki/Interquartile_mean#Dataset_not_divisible_by_four
    def boundary_modifier
      1 - fractional_quartile_size.modulo(1)
    end

    def interquartile_range
      trunc = fractional_quartile_size.floor
      data.sort[trunc...-trunc]
    end

    def interquartile_mean
      iqr = interquartile_range
      lower, upper = iqr.shift, iqr.pop # modifies iqr!

      weighted_sum = iqr.inject(:+).to_i + boundary_modifier * (lower + upper)
      weighted_sum / (0.5 * size)
    end

    def method_missing(meth, *args, &block)
      data.send(meth, *args, &block) if data.respond_to?(meth)
    end
  end
end
