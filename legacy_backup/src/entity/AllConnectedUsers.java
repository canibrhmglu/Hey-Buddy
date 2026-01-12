package entity;

import java.util.Set;

public class AllConnectedUsers {
	
	public static final String type = "allConnectedUsers";
	
	private Set<String> usernames;
	
	public AllConnectedUsers(Set<String> usernames) {
		this.usernames = usernames;
	}

	public Set<String> getUsernames() {
		return usernames;
	}

	public void setUsernames(Set<String> usernames) {
		this.usernames = usernames;
	}

}
