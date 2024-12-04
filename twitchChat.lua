
BOT_USER_ID = ''
OAUTH_TOKEN = ''
CLIENT_ID = ''

CHAT_CHANNEL_USER_ID = ''

EVENTSUB_WEBSOCKET_URL = 'wss://eventsub.wss.twitch.tv/ws'

WebsocketSessionID = ''

function GetAuth()
	local response, err = http.get('https://id.twitch.tv/oauth2/validate', {
		['Authorization'] = 'OAuth ' .. OAUTH_TOKEN
	})


	if response then
		if response.getResponseCode() ~= 200 then
			local data = textutils.unserializeJSON(response.readAll())
			print('Token is not valid. /oauth2/validate returned status code ' .. response.getResponseCode())
			print(data)
			return false
		end

		print('Validated token.')
		return true
	else
		print('Failed to validate token.')
		return false
	end
end

function StartWebSocketClient()
    local ws, err = http.websocket(EVENTSUB_WEBSOCKET_URL)

    if ws then
        print('WebSocket connection opened to ' .. EVENTSUB_WEBSOCKET_URL)

        while true do
            local event, url, message = os.pullEvent("websocket_message")
            if url == EVENTSUB_WEBSOCKET_URL then
                local success, data = pcall(textutils.unserializeJSON, message)
                if success then
                    HandleWebSocketMessage(data)
                else
                    print('Error parsing JSON: ' .. data)
                end
            end
        end
    else
        print('Failed to connect: ' .. err)
    end
end

function HandleWebSocketMessage(data)
    if data.metadata.message_type == 'session_welcome' then
        WebsocketSessionID = data.payload.session.id
        RegisterEventSubListeners()
    elseif data.metadata.message_type == 'notification' then
        if data.metadata.subscription_type == 'channel.chat.message' then
            print('<' .. data.payload.event.chatter_user_login .. '> ' .. data.payload.event.message.text)
        end
    end
end

function RegisterEventSubListeners()

    local body = textutils.serializeJSON({
        type = 'channel.chat.message',
        version = '1',
        condition = {
            broadcaster_user_id = CHAT_CHANNEL_USER_ID,
            user_id = BOT_USER_ID
        },
        transport = {
            method = 'websocket',
            session_id = WebsocketSessionID
        }
    })

    local response, err = http.post('https://api.twitch.tv/helix/eventsub/subscriptions', body, {
        ['Authorization'] = 'Bearer ' .. OAUTH_TOKEN,
        ['Client-ID'] = CLIENT_ID,
        ['Content-Type'] = 'application/json'
    })

	print(err)

    if response then
        local data = textutils.unserializeJSON(response.readAll())
        if data then
            print('Subscribed to channel.chat.message [' .. data.data[1].id .. ']')
        else
            print('Failed to subscribe to channel.chat.message. API call returned status code ' .. response.getResponseCode())
            print(response.readAll())
        end
    else
        print('Failed to subscribe to channel.chat.message. API call failed')
    end

end

GetAuth()
StartWebSocketClient()