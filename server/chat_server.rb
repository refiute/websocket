require 'em-websocket'

EM::run do
	puts 'server start'

	@channel = EM::Channel.new

	EM::WebSocket.start(:host => "0.0.0.0", :port => 8001) do |ws|
		ws.onopen{
			sid = @channel.subscribe{|mes|
				ws.send(mes)
			}
			puts "<#{sid}> connected"
			@channel.push("<#{sid}> connected")

			ws.onmessage{|mes|
				puts "<#{sid}> #{mes}"
				@channel.push("<#{sid}> #{mes}")
			}

			ws.onclose{
				puts "<#{sid}> disconnected"
				@channel.unsubscribe(sid)
				@channel.push("<#{sid}> disconnected")
			}
		}
	end
end
