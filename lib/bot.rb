require 'telegram/bot'
require_relative 'parser'
require_relative 'worker'

include Parser

class Bot
  def initialize(token)
    @workers = []
    Telegram::Bot::Client.run(token) do |bot|
      bot.listen do |message|
        case message.text
        when '/create_workers'
          Parser.workers_params.each { |params| @workers << Worker.new(params) }
          puts @workers
          puts @workers.ip
        end
      end
    end
  end
end
