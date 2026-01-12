package service;

import codec.MessageDecoder;
import codec.MessageEncoder;
import entity.ConnectedUser;
import entity.DisconnectedUser;
import entity.Message;
import entity.WebSocketMessage;
import repository.MessageRepository;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.util.*;
import java.util.concurrent.TimeUnit;

@ServerEndpoint(value = "/ws", encoders = MessageEncoder.class, decoders = MessageDecoder.class)
public class WebSocketService {

	static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());
	MessageRepository database = new MessageRepository(); // connect DB

	@OnOpen
	public void onOpen(Session session) {
		System.out.println("onOpen::" + session.getId());
		clients.add(session);
		String[] keys = { "sender", "receiver" };
		List<Message<?>> messages = database.findDocument(keys, session.getUserPrincipal().getName());

		messages.forEach(message -> {
			WebSocketMessage<Message<?>> webSocketMessage = new WebSocketMessage<Message<?>>(message);
			session.getAsyncRemote().sendObject(webSocketMessage);
			try {
				TimeUnit.MILLISECONDS.sleep(30);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		});
		
		WebSocketMessage<String> initialLoadOkMessage = new WebSocketMessage<String>();
		initialLoadOkMessage.setType("initialLoadOK");
		
		session.getAsyncRemote().sendObject(initialLoadOkMessage);

	}

	@OnClose
	public void onClose(Session session) {
		//System.out.println("onClose::" + session.getId());
		clients.remove(session);
		sendUserStatusToAllClients(session.getUserPrincipal().getName(), false);
	}

	@SuppressWarnings("unchecked")
	@OnMessage
	public void handleMessage(Session session, @SuppressWarnings("rawtypes") WebSocketMessage webSocketMessage) {
		
		if(webSocketMessage.getPayload() instanceof String) {
			webSocketMessage.setPayload("__pong__");
			clients.forEach(client -> {
				if(client == session) {
					client.getAsyncRemote().sendObject(webSocketMessage);
				}
			});
		}

		if (webSocketMessage.getPayload() instanceof Message) {

			Message<?> message = (Message<?>) webSocketMessage.getPayload();

			database.createDocument(message);

			clients.forEach(client -> {
				if (client.getUserPrincipal().getName().equalsIgnoreCase(message.getReceiver())
						|| client.getUserPrincipal().getName().equalsIgnoreCase(message.getSender())) {
					client.getAsyncRemote().sendObject(webSocketMessage);
				}
			});

		}
		if (webSocketMessage.getPayload() instanceof ConnectedUser) {
			clients.forEach(client -> {
				sendUserStatusToAllClients(client.getUserPrincipal().getName(), true); 
				try {
					TimeUnit.MILLISECONDS.sleep(30);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
		}
	}

	@OnError
	public void onError(Throwable t) {
		System.out.println("onError::" + t.getMessage());
		t.printStackTrace();
	}

	public void sendUserStatusToAllClients(String user, Boolean status) {
		if (status) { // it means "Online"
			ConnectedUser connectedUser = new ConnectedUser(user);
			WebSocketMessage<ConnectedUser> webSocketMessage = new WebSocketMessage<ConnectedUser>(connectedUser);

			System.out.println("connected user: " + user);
			clients.forEach(client -> client.getAsyncRemote().sendObject(webSocketMessage));

		} else if (!status ) { // it means "Offline"
			DisconnectedUser disconnectedUser = new DisconnectedUser(user);
			WebSocketMessage<DisconnectedUser> webSocketMessage = new WebSocketMessage<DisconnectedUser>(
					disconnectedUser);
			System.out.println("disconnected user: " + user);
			clients.forEach(client -> client.getAsyncRemote().sendObject(webSocketMessage));

		}

	}
}
