# frozen_string_literal: true

require 'telegram/bot'
require 'rufus/scheduler'

require_relative 'parser'
require_relative 'worker'

module Parser
  class Bot
    TELEGRAM_TOKEN = ENV['BOT_TOKEN']

    def initialize
      scheduler = Rufus::Scheduler.new

      Telegram::Bot::Client.run(TELEGRAM_TOKEN) do |bot|

        scheduler.every '1m' do
          bot.api.send_message(chat_id: 385730505, text: 'Test')
        end

        bot.listen do |message|
          case message.text
          when '/status'
            status(bot, message)
          end
        end
      end
    end

    def update_workers
      @workers = []
      Parser.workers_params.each { |params| @workers << Worker.new(params) }
    end

    def status(bot, message)
      update_workers
      text = []
      @workers.each { |worker| text << worker.ip }
      bot.api.send_message(chat_id: message.chat.id, text: "There are #{@workers.size} workers with ip\'s: #{text}")
    end

    def watch_fails(bot, message)
      update_workers
      @workers.each do |worker|
        if worker.status != 'Running'
          bot.api.send_message(chat_id: message.chat.id,
                               text: "Worker with ip: #{worker.ip} is not working")
        end
      end
    end
  end
end
