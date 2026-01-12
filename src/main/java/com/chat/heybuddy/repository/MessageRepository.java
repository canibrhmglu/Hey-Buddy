package com.chat.heybuddy.repository;

import com.chat.heybuddy.entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface MessageRepository extends MongoRepository<Message, String> {
    List<Message> findBySenderAndReceiver(String sender, String receiver);

    List<Message> findByReceiverAndSender(String receiver, String sender);
    // Or find by conversation ID if we had one, but for now we can query both ways
}
