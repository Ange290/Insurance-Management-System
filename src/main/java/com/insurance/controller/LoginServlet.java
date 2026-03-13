package com.insurance.controller;

import com.insurance.dao.UserDAO;
import com.insurance.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet({"/", "/login", "/logout", "/register"})
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    private static final String LOGIN_JSP = "/WEB-INF/views/login.jsp";
    private static final String REGISTER_JSP = "/WEB-INF/views/register.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        System.out.println("=== LoginServlet GET - Path: " + path);

        if ("/logout".equals(path)) {
            logout(request, response);
            return;
        }

        if ("/register".equals(path)) {
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
            return;
        }

        // "/" and "/login"
        // If already logged in, go to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            System.out.println("User already logged in -> redirecting to /dashboard");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        System.out.println("=== LoginServlet POST - Path: " + path);

        if ("/register".equals(path)) {
            register(request, response);
            return;
        }

        login(request, response);
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("username"); // field contains email
        String password = request.getParameter("password");

        System.out.println("=== LOGIN ATTEMPT === Email: " + email);

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
            return;
        }

        User user;
        try {
            user = userDAO.getUserByEmail(email.trim());
        } catch (Exception e) {
            System.err.println("ERROR: getUserByEmail failed: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
            return;
        }

        if (user == null || user.getPassword() == null || !user.getPassword().trim().equals(password.trim())) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
            return;
        }

        if (user.getStatus() == null || !"Active".equalsIgnoreCase(user.getStatus().trim())) {
            request.setAttribute("error", "Your account has been suspended. Please contact support.");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
            return;
        }

        // SUCCESS -> create session
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userRole", user.getRoleName());
        session.setMaxInactiveInterval(30 * 60);

        System.out.println("=== LOGIN SUCCESS ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("userId: " + session.getAttribute("userId"));
        System.out.println("userRole: " + session.getAttribute("userRole"));

        // Avoid cache issues
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        // Role-aware redirect (you already mapped these URLs in DashboardServlet)
        String role = String.valueOf(user.getRoleName()); // e.g. Admin, Customer, Agent, Manager
        String redirectUrl;

        if ("Admin".equalsIgnoreCase(role)) {
            redirectUrl = request.getContextPath() + "/admin/dashboard";
        } else if ("Agent".equalsIgnoreCase(role)) {
            redirectUrl = request.getContextPath() + "/agent/dashboard";
        } else if ("Manager".equalsIgnoreCase(role)) {
            redirectUrl = request.getContextPath() + "/manager/dashboard";
        } else {
            // Customer (default)
            redirectUrl = request.getContextPath() + "/customer/dashboard";
        }

        System.out.println("Redirecting to: " + redirectUrl);
        response.sendRedirect(redirectUrl);
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
            return;
        }

        User existingUser = userDAO.getUserByEmail(email);
        if (existingUser != null) {
            request.setAttribute("error", "Email already exists! Please use a different email.");
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setAddress(address);
        newUser.setPassword(password);
        newUser.setRoleId(3); // customer
        newUser.setStatus("Active");

        boolean success = userDAO.insertUser(newUser);

        if (success) {
            request.setAttribute("success", "Account created successfully! Please login with your email.");
            request.getRequestDispatcher(LOGIN_JSP).forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher(REGISTER_JSP).forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        System.out.println("=== LOGOUT ===");

        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();

        response.sendRedirect(request.getContextPath() + "/login");
    }
}