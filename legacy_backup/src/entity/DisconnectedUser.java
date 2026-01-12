package entity;

public class DisconnectedUser {
	public static final String type = "disconnectedUser";
	private String username;
	
	public DisconnectedUser (String username) {
		this.setUsername(username);
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
}
