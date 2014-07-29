module IIM
  class DataSet
    include Enumerable # necessary?

    attr_accessor :total_size,

                  :first_quartile_min,
                  :first_quartile_max,
                  :first_quartile_size,

                  :second_quartile_min,
                  :second_quartile_max,
                  :second_quartile_size,
                  :second_quartile_avg,

                  :third_quartile_min,
                  :third_quartile_max,
                  :third_quartile_size,
                  :third_quartile_avg,

                  :fourth_quartile_min,
                  :fourth_quartile_max,
                  :fourth_quartile_size

    def <<(item)
      @total_size += 1
      insert_into_quartile(item)
    end

    def insert_into_quartile(item)
      case item
      when (q1_min..q1_max).cover? item
        add_to_q1(item)
