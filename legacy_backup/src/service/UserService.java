
package service;

import com.google.gson.Gson;
import entity.User;
import repository.UserRepository;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class as
 */
@WebServlet("/userService")
public class UserService extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserService() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<String> allUserNames = UserRepository.findAllUserNames();
		String json = new Gson().toJson(allUserNames);
		response.getWriter().write(json);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		User newUser = new User();
		newUser.setName(request.getParameter("name"));
		newUser.setLastname(request.getParameter("lastname"));
		newUser.setEmail(request.getParameter("email"));
		newUser.setUsername(request.getParameter("username"));
		newUser.setPassword(request.getParameter("password"));

		UserRepository.createDocument(newUser);

		response.setStatus(200);
		response.sendRedirect("/Auth");
	}
	
	public static Boolean CheckUserInDB(String username, String password) {
		User user = UserRepository.findDocument(username, password);
		return user.getUsername() != null;
	}

}
