package com.insurance.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // optional
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String loginURI = httpRequest.getContextPath() + "/login.jsp";
        String uri = httpRequest.getRequestURI();

        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        boolean loginRequest = uri.contains("login");
        boolean registerRequest = uri.contains("register");

        boolean staticResource =
                uri.contains("/css/") ||
                        uri.contains("/js/") ||
                        uri.contains("/images/") ||
                        uri.contains("/bootstrap/");

        if (loggedIn || loginRequest || registerRequest || staticResource) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        // optional
    }
}
