package codec;

import javax.websocket.EncodeException;
import javax.websocket.Encoder;
import javax.websocket.EndpointConfig;

import com.google.gson.Gson;

import entity.WebSocketMessage;


@SuppressWarnings("rawtypes")
public class MessageEncoder implements Encoder.Text<WebSocketMessage> {
	
	Gson gson = new Gson();

    @Override
    public String encode(final WebSocketMessage webSocketMessage) throws EncodeException {
		String messageJson = gson.toJson(webSocketMessage);
        return messageJson;
    }

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void init(EndpointConfig arg0) {
		// TODO Auto-generated method stub
		
	}

}
