numbers = ARGV[0].to_i
puts "Generating a data set with #{numbers} numbers at #{numbers}.txt -- hold on..."
File.open("#{Dir.pwd}/spec/fixtures/#{numbers}.txt", "w") do |file|
  numbers.times do
    file << rand(0..numbers)
    file << "\n"
  end
end
