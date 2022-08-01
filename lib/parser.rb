require_relative 'worker'
require 'rubygems'
require 'ccsv'
PARAMS = %i[ip status up_time elapsed ths_rt ths_avg power freq_avg volt].freeze

module Parser
  extend self

  def workers_params
    params = []
    Ccsv.foreach(find_file[0], ',') do |line|
      unless line[0] == 'IP'
        short_line = line[0], line[1], line[6], line[7], line[8], line[9], line[11], line[21], line[34]
        params << PARAMS.zip(short_line).to_h
      end
    end
    params
  end

  def find_file
    Dir.glob("#{Dir.pwd}/*.csv")
  end

  def delete_file
    File.delete(find_file[0])
  end
end
