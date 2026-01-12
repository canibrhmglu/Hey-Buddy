package repository;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import entity.User;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class UserRepository {

	static MongoDatabase database = DatabaseConnection.getInstance();
	static MongoCollection<Document> collection = database.getCollection("User");

	public static void createDocument(User newUser) {

		collection = database.getCollection("User");

		Document document = new Document();
		document.put("name", newUser.getName());
		document.put("lastname", newUser.getLastname());
		document.put("email", newUser.getEmail());
		document.put("username", newUser.getUsername());
		document.put("password", newUser.getPassword());

		collection.insertOne(document);

	}

	public static User findDocument(String username, String password) {

		List<Document> criterias = new ArrayList<Document>();

		Document documentUsername = new Document("username", username);
		Document documentPassword = new Document("password", password);
		criterias.add(documentUsername);
		criterias.add(documentPassword);

		Document query = new Document("$and", criterias);
		Document document = new Document();
		document = collection.find(query).first();

		User user = new User();
		if (document != null) {
			user.setName(document.getString("name"));
			user.setLastname(document.getString("lastname"));
			user.setEmail(document.getString("email"));
			user.setUsername(document.getString("username"));
			user.setPassword(document.getString("password"));
		}

		return user;

	}

	public static List<String> findAllUserNames() {

		List<Document> documents = new ArrayList<Document>();
		collection.find().into(documents);

		List<String> userNames = new ArrayList<String>();

		documents.forEach(document -> userNames.add(document.getString("username")));

		return userNames;

	}

	public static List<User> findDocuments(String[] keys, String value) {

		List<Document> criterias = new ArrayList<Document>();

		for (String key : keys) {
			Document document = new Document(key, value);
			criterias.add(document);
		}

		Document query = new Document("$or", criterias);
		List<Document> documents = new ArrayList<Document>();
		collection.find(query).into(documents);

		List<User> userList = new ArrayList<User>();

		documents.forEach(document -> {
			User user = new User();
			user.setName(document.getString("name"));
			user.setLastname(document.getString("lastname"));
			user.setEmail(document.getString("email"));
			user.setUsername(document.getString("username"));
			user.setPassword(document.getString("password"));

			userList.add(user);

		});

		return userList;

	}

}
