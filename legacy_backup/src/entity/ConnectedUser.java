package entity;

@SuppressWarnings("rawtypes")
public class ConnectedUser extends WebSocketMessage{

	public static final String type = "connectedUser";
	private String username;
	
	public ConnectedUser (String username) {
		this.setUsername(username);
	}
	
	public ConnectedUser () {
	}

	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}

}
