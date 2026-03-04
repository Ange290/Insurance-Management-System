package com.insurance.controller;

import com.insurance.dao.UserDAO;
import com.insurance.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/user", "/users",
        "/admin/user", "/admin/users",
        "/manager/user", "/manager/users"})
public class UserServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            insertUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/user-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/user-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(id);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/WEB-INF/views/user-form.jsp").forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String status = request.getParameter("status");

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setPassword(password);
        user.setRoleId(roleId);
        user.setStatus(status != null ? status : "Active"); // Default to Active if not provided

        boolean success = userDAO.insertUser(user);

        if (success) {
            response.sendRedirect(getServletPath(request) + "?success=created");
        } else {
            response.sendRedirect(getServletPath(request) + "?error=failed");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String status = request.getParameter("status");

        // Get existing user to preserve old password if new one is blank
        User existingUser = userDAO.getUserById(userId);

        User user = new User();
        user.setUserId(userId);
        user.setName(name);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        // If password is blank or null, keep the old password
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        } else {
            user.setPassword(existingUser.getPassword());
        }

        user.setRoleId(roleId);
        user.setStatus(status != null ? status : "Active");

        boolean success = userDAO.updateUser(user);

        if (success) {
            response.sendRedirect(getServletPath(request) + "?success=updated");
        } else {
            response.sendRedirect(getServletPath(request) + "?error=failed");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = userDAO.deleteUser(id);

        if (success) {
            response.sendRedirect(getServletPath(request) + "?success=deleted");
        } else {
            response.sendRedirect(getServletPath(request) + "?error=failed");
        }
    }

    // Helper method to get the correct servlet path based on user role
    private String getServletPath(HttpServletRequest request) {
        String userRole = (String) request.getSession().getAttribute("userRole");
        if (userRole != null) {
            return request.getContextPath() + "/" + userRole.toLowerCase() + "/user";
        }
        return request.getContextPath() + "/user";
    }
}