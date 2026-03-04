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

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/logout".equals(path)) {
            logout(request, response);
        } else if ("/register".equals(path)) {
            // Show registration page
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        } else {
            // Show login page (for "/" and "/login")
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/register".equals(path)) {
            register(request, response);
        } else {
            login(request, response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("username"); // Field name is "username" but contains email
        String password = request.getParameter("password");

        // Find user by email
        User user = userDAO.getUserByEmail(email);

        if (user != null && user.getPassword().equals(password)) {

            if ("Active".equals(user.getStatus())) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userRole", user.getRoleName());

                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Your account has been suspended. Please contact support.");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate passwords match
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        User existingUser = userDAO.getUserByEmail(email);
        if (existingUser != null) {
            request.setAttribute("error", "Email already exists! Please use a different email.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // Create new customer account
        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setAddress(address);
        newUser.setPassword(password); // In production, hash this!
        newUser.setRoleId(3); // Customer role
        newUser.setStatus("Active");

        boolean success = userDAO.insertUser(newUser);

        if (success) {
            request.setAttribute("success", "Account created successfully! Please login with your email.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}