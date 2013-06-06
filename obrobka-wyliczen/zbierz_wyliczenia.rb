#!/usr/bin/env ruby
require 'csv'
require 'pry'

raw_result_regexp = /^Pokolenie nr=(  599| 2999| 8999|35999).*/
result_regexp = /najlepszy=[\s\d]*\(dl=(?<best>[\d\.]+)\), najgorszy=[\s\d]*\(dl=(?<worst>[\d\.]+)\), .*rednia_dl=(?<average>[\d\.]+)/

variants = CSV.table('warianty.csv', col_sep: ';').to_a
results = CSV.open('wyliczenia.csv', 'w+', { headers: :first_row, write_headers: true })
results << CSV::Row.new([], variants.shift + %i[najlepszy najgorszy średni], true)

Dir["../wyliczenia/[0-9][0-9][0-9]/ewolucja.txt"].each do |variant_filepath|
  raw_results = File.readlines(variant_filepath)
    .map { |line| line.encode(Encoding::ISO_8859_2, Encoding::UTF_8, { invalid: :replace, undef: :replace }) }
    .select { |line| raw_result_regexp =~ line }
  parsed_results = raw_results.map { |raw_result| (_, *parsed_result = *(result_regexp.match raw_result)).drop(1).map(&:to_f) }
  variants.shift(4).zip(parsed_results).each(&:flatten!).each { |result| results << CSV::Row.new(results.headers, result) }
end

`lime -n wyliczenia.csv`
