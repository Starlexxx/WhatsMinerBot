class Worker
  attr_reader :ip, :status, :up_time, :elapsed, :ths_rt,	:ths_avg, :power, :freq_avg, :volt

  def initialize(args)
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
end
