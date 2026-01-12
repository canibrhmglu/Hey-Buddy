package com.chat.heybuddy.handler;

import com.chat.heybuddy.entity.Message;
import com.chat.heybuddy.repository.MessageRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler {

    // Map session to username
    private final Map<WebSocketSession, String> sessionToUser = new ConcurrentHashMap<>();
    // Map username to session (for direct messaging)
    private final Map<String, WebSocketSession> userToSession = new ConcurrentHashMap<>();

    @Autowired
    private MessageRepository messageRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // Connection established, waiting for JOIN message to identify user
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        try {
            Message msg = objectMapper.readValue(payload, Message.class);
            msg.setReceivedDate(LocalDateTime.now().toString());

            if ("JOIN".equalsIgnoreCase(msg.getType())) {
                String username = msg.getSender();
                if (username != null) {
                    sessionToUser.put(session, username);
                    userToSession.put(username, session);
                    broadcastUserList();
                }
            } else if ("CHAT".equalsIgnoreCase(msg.getType())) {
                // Save to DB
                messageRepository.save(msg);

                String receiver = msg.getReceiver();
                if ("Global".equalsIgnoreCase(receiver) || receiver == null) {
                    broadcastMessage(msg);
                } else {
                    sendPrivateMessage(msg);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void broadcastUserList() throws IOException {
        Message userListMsg = new Message();
        userListMsg.setType("USER_LIST");
        userListMsg.setSender("System");
        userListMsg.setContent(objectMapper.writeValueAsString(userToSession.keySet()));

        broadcastMessage(userListMsg);
    }

    private void broadcastMessage(Message msg) throws IOException {
        String json = objectMapper.writeValueAsString(msg);
        for (WebSocketSession s : sessionToUser.keySet()) {
            if (s.isOpen()) {
                s.sendMessage(new TextMessage(json));
            }
        }
    }

    private void sendPrivateMessage(Message msg) throws IOException {
        String json = objectMapper.writeValueAsString(msg);

        // Send to receiver
        WebSocketSession receiverSession = userToSession.get(msg.getReceiver());
        if (receiverSession != null && receiverSession.isOpen()) {
            receiverSession.sendMessage(new TextMessage(json));
        }

        // Send back to sender (so they see their own message)
        WebSocketSession senderSession = userToSession.get(msg.getSender());
        if (senderSession != null && senderSession.isOpen() && !senderSession.equals(receiverSession)) {
            senderSession.sendMessage(new TextMessage(json));
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String username = sessionToUser.remove(session);
        if (username != null) {
            userToSession.remove(username);
            broadcastUserList();
        }
    }
}
