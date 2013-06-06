#!/usr/bin/env ruby
%w{erb fileutils}.each { |lib| require lib }
File.readlines('warianty.csv').select { |row| row =~ /36000/ }.each_with_index do |row, i|
  krzyzowanie, mutacja, osobniki, pokolenia, skalowanie, elitaryzm = *row.strip.split(';')
  id_wariantu = "%03d" % (4*(i+1))
  FileUtils.mkdir_p katalog_wariantu = "../wyliczenia/#{id_wariantu}"
  File.write("#{katalog_wariantu}/mdvrp_ust.txt", ERB.new(File.read('mdvrp_ust.txt.erb')).result(binding))
end
Dir["../wyliczenia/[0-9][0-9][0-9]"].each { |dirname| FileUtils.cp Dir["000/*"], dirname, preserve: true }
