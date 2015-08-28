require 'thread'
require 'enumerator'

require_relative 'iim/data_set'
require_relative 'iim/mean_generator'

module IIM
  def self.perform!(_filename = nil)
    filename = _filename || 'spec/fixtures/data.txt'
    mean_generator = MeanGenerator.new(filename)
    mean_generator.perform!
  end
end

module IIM::Async
  class << self
    def perform!
      #####
      # Setup
      set_size     = get_set_size
      sub_set_size = get_sub_set_size
      data         = get_data(set_size)
      threads      = []
      print "."

      #####
      # Estimated IQM
      start = Time.now.to_f * 1000.0
      data.each_slice(sub_set_size) do |chunk|
        threads << Thread.new { Thread.current[:output] = IIM::DataSet.new(chunk, chunk.size).interquartile_mean }
      end
      threads.each { |thr| thr.join }
      est_iqm = threads.collect {|t| t[:output]}.reduce(:+).to_f / threads.size
      est_iqm_time = Time.now.to_f * 1000.0 - start

      #####
      # Real IQM
      start = Time.now.to_f * 1000.0
      real_iqm = IIM::DataSet.new(data, data.size).interquartile_mean
      real_iqm_time = Time.now.to_f * 1000.0 - start

      update_histogram({
        set_size: set_size,
        sub_set_size: sub_set_size,
        est_iqm: est_iqm,
        est_iqm_time: est_iqm_time,
        real_iqm: real_iqm,
        real_iqm_time: real_iqm_time
        })

      remove_data_file(set_size) # remove this to speed up program; keep it to generate samples for histogram
    end

    def get_set_size
      set_size_arg = ARGV.detect {|arg| arg.match /set_size=\d+/}
      set_size = ARGV.delete(set_size_arg).split("=").last.to_i if set_size_arg.is_a?(String)
      raise("Specify set size with `ruby iim.rb [async] set_size=[int] sub_set_size=[int]`") if set_size.nil?
      set_size
    end

    def get_sub_set_size
      sub_set_size_arg = ARGV.detect {|arg| arg.match /sub_set_size=\d+/}
      sub_set_size = ARGV.delete(sub_set_size_arg).split("=").last.to_i if sub_set_size_arg.is_a?(String)
      raise("Specify sub_set size with `ruby iim.rb [async] set_size=[int] sub_set_size=[int]`") if sub_set_size.nil?
      sub_set_size
    end

    def get_data(set_size)
      if File.exists?("#{Dir.pwd}/spec/fixtures/#{set_size}.txt")
        data = []
        File.open("#{Dir.pwd}/spec/fixtures/#{set_size}.txt", 'r') do |file|
          file.each_line do |item|
            data << item.to_i
          end
        end
        data
      else
        create_data!(set_size)
        get_data(set_size)
      end
    end

    def create_data!(set_size)
      File.open("#{Dir.pwd}/spec/fixtures/#{set_size}.txt", "w") do |file|
        set_size.times do
          file << rand(0..set_size)
          file << "\n"
        end
      end
    end

    def update_histogram(set_size:, sub_set_size:, est_iqm:, est_iqm_time:, real_iqm:, real_iqm_time:)
      File.open("histogram.csv", "a") do |f|
        f << [set_size, sub_set_size, est_iqm, est_iqm_time, real_iqm, real_iqm_time].join(",")
        f << "\n"
      end
    end

    def remove_data_file(set_size)
      File.delete("#{Dir.pwd}/spec/fixtures/#{set_size}.txt")
    end
  end
end

case
when ARGV.include?("async")
  IIM::Async.perform!
else
  IIM.perform!("spec/fixtures/100.txt")
end
