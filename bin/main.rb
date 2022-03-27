require_relative '../lib/bot'
require_relative '../lib/parser'
puts 'Enter bot\'s token please'
Bot.new(gets.chomp)
