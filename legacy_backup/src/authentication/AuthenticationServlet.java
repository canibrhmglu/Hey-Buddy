package authentication;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class authenticationServlet
 */
@WebServlet("/Authentication")
public class AuthenticationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AuthenticationServlet() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Gson gson = new Gson();
		Credentials credentials = gson.fromJson(request.getReader(), Credentials.class);
		
		if (Authenticator.checkCredentials(credentials.getUsername(), credentials.getPassword())) {
            String token = Authenticator.issueAccessToken(credentials.getUsername());
            response.setStatus(HttpServletResponse.SC_OK);
            response.setContentType("application/json");
            
            String tokenJson = gson.toJson(new AccessToken(token));
            response.getWriter().print(tokenJson);
        } else {
        	response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        	response.setContentType("text/plain");
        	response.getWriter().write("Invalid credentials");
        }
		
	}

	private static class Credentials {

        private String username;
        private String password;

        public String getUsername() {
            return username;
        }
		public void setUsername(String username) {
            this.username = username;
        }
        public String getPassword() {
            return password;
        }
		public void setPassword(String password) {
            this.password = password;
        }
    }

	private static class AccessToken {
		private final String token;
        public AccessToken(String token) {
            this.token = token;
        }
    }
}
