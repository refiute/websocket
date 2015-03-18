require 'em-websocket'

count = 0

EM::run do
	puts 'count server start'

	@channel = EM::Channel.new

	EM::WebSocket.start(:host => "0.0.0.0", :port => 8000) do |ws|
		ws.onopen{
			sid = @channel.subscribe{|mes|
				ws.send(mes)
			}
			count += 1
			puts "count: #{count}"
			puts "<#{sid}> connected"
			@channel.push("#{count}")

			ws.onclose{
				count -= 1
				puts "<#{sid}> disconnected"
				@channel.unsubscribe(sid)
				@channel.push("#{count}")
			}
		}
	end
end
