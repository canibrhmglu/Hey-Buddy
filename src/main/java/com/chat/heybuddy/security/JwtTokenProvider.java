package com.chat.heybuddy.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtTokenProvider {

    @Value("${app.jwtSecret:SecretKeyToGenJWTs}")
    private String jwtSecret;

    @Value("${app.jwtExpirationInMs:604800000}")
    private int jwtExpirationInMs;

    public String generateToken(Authentication authentication) {
        UserDetails userPrincipal = (UserDetails) authentication.getPrincipal();

        return JWT.create()
                .withSubject(userPrincipal.getUsername())
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(new Date().getTime() + jwtExpirationInMs))
                .sign(Algorithm.HMAC512(jwtSecret));
    }

    public String getUsernameFromJWT(String token) {
        DecodedJWT decodedJWT = JWT.require(Algorithm.HMAC512(jwtSecret))
                .build()
                .verify(token);
        return decodedJWT.getSubject();
    }

    public boolean validateToken(String authToken) {
        try {
            JWT.require(Algorithm.HMAC512(jwtSecret)).build().verify(authToken);
            return true;
        } catch (Exception ex) {
            // Log exception
        }
        return false;
    }
}
