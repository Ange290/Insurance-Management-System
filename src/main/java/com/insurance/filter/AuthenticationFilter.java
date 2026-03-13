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

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();
        String path = req.getServletPath(); // safer than contains()

        // Allow public endpoints
        boolean isLogin = path.equals("/") || path.equals("/login");
        boolean isRegister = path.equals("/register");
        boolean isLogout = path.equals("/logout");

        // Allow static resources
        boolean isStatic =
                uri.startsWith(contextPath + "/css/") ||
                        uri.startsWith(contextPath + "/js/") ||
                        uri.startsWith(contextPath + "/images/") ||
                        uri.startsWith(contextPath + "/bootstrap/") ||
                        uri.startsWith(contextPath + "/fonts/");

        // Allow JSP access only if you really need it (optional).
        // Since your JSPs are under /WEB-INF/views, they are not directly accessible anyway.

        if (isLogin || isRegister || isLogout || isStatic) {
            chain.doFilter(request, response);
            return;
        }

        // Check session login
        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
        } else {
            // IMPORTANT: redirect to the servlet /login (NOT /login.jsp)
            res.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        // optional
    }
}