package repository;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import entity.Message;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class MessageRepository {

	MongoCollection<Document> collection = null;
	MongoDatabase database = DatabaseConnection.getInstance();

	public void createDocument(Message<?> message) {

		collection = database.getCollection("Message");

		Document document = new Document();
		document.put("sender", message.getSender());
		document.put("receiver", message.getReceiver());
		document.put("contentType", message.getContentType());
		document.put("content", message.getContent());
		document.put("receivedDate", message.getReceivedDate());

		collection.insertOne(document);

	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<Message<?>> findDocument(String[] keys, String value) {
		collection = database.getCollection("Message");

		List<Document> criterias = new ArrayList<Document>();

		for (String key : keys) {
			Document document = new Document(key, value);
			criterias.add(document);
		}

		Document query = new Document("$or", criterias);
		List<Document> documents = new ArrayList<Document>();
		collection.find(query).into(documents);

		List<Message<?>> messages = new ArrayList<Message<?>>();

		for (Document document : documents) {
			Message message = new Message();
			message.setSender(document.getString("sender"));
			message.setReceiver(document.getString("receiver"));
			message.setContentType(document.getString("contentType"));
			if (document.getString("contentType").equals("txt"))
				message.setContent(document.getString("content"));
			else if (document.getString("contentType").equals("img"))
				message.setContent(document.get("content"));
			message.setReceivedDate(document.getString("receivedDate"));

			messages.add(message);
		}

		return messages;

	}

}
