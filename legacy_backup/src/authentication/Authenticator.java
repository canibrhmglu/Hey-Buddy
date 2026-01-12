package authentication;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import service.UserService;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

public class Authenticator {
	
	private static final SecureRandom random = new SecureRandom();
	
	private static final Cache<String, String> accessTokens = CacheBuilder.newBuilder()
            .expireAfterAccess(15, TimeUnit.SECONDS) // Entries expire in 15 seconds
            .build();
	
	private static final Cache<String,Algorithm> algorithms = CacheBuilder.newBuilder()
            .expireAfterAccess(15, TimeUnit.SECONDS) // Entries expire in 15 seconds
            .build();

    
    public static boolean checkCredentials(String username, String password) {
        return UserService.CheckUserInDB(username, password);
    }
    
    public static String issueAccessToken(String username) throws IllegalArgumentException, UnsupportedEncodingException {
    	String token = "";
    	String randomSecret = new BigInteger(130, random).toString(32);
    	try {
    	    Algorithm algorithm = Algorithm.HMAC256(randomSecret);
    	    token = JWT.create()
    	        .withIssuer("auth0")
    	        .sign(algorithm);
    	    
    	    algorithms.put(token,algorithm);
    	    accessTokens.put(token,username);
    	} catch (JWTCreationException exception){
    	    //Invalid Signing configuration / Couldn't convert Claims.
    	}
        return token;
    }
    
    public static String getUsername(String accessToken) {
    	String username = accessTokens.getIfPresent(accessToken);
    	Optional<String> optionalUsername = Optional.ofNullable(username);
    	return optionalUsername.orElse("");
    }
    
    public static Boolean verifyToken(String accessToken) throws IllegalArgumentException, UnsupportedEncodingException {
    	Algorithm algorithm = algorithms.getIfPresent(accessToken);
        try {
            JWTVerifier verifier = JWT.require(algorithm)
                .withIssuer("auth0")
                .build(); //Reusable verifier instance
            @SuppressWarnings("unused")
    		DecodedJWT jwt = verifier.verify(accessToken);
            accessTokens.invalidate(accessToken); // The token can be used only once
            return true;
        	    
        } catch (Exception exception){
       	    //Invalid signature/claims
       		return false;
       	}
    	

    }

}
