package authentication;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Principal;

@WebFilter("/ws/*")
public class AccessTokenFilter implements Filter{

	@Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }
	
	@Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String token = request.getParameter("access-token");
        if (token == null || token.trim().isEmpty()) {
            returnForbiddenError(response, "An access token is required to connect");
            return;
        }

        String username = Authenticator.getUsername(token);
        if (Authenticator.verifyToken(token) && username !="" ) {
            filterChain.doFilter(new AuthenticatedRequest(request, username), servletResponse);
        } else {
            returnForbiddenError(response, "Invalid access token");
        }
    }
	
	private void returnForbiddenError(HttpServletResponse response, String message) throws IOException {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, message);
    }
	
	private static class AuthenticatedRequest extends HttpServletRequestWrapper {

        private final String username;

        public AuthenticatedRequest(HttpServletRequest request, String username) {
            super(request);
            this.username = username;
        }

        @Override
        public Principal getUserPrincipal() {
            return () -> username;
        }
    }
	
	@Override
    public void destroy() {

    }
}
