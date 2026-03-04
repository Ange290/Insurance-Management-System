package com.insurance.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/dashboard", "/admin/dashboard", "/agent/dashboard", "/customer/dashboard", "/manager/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        String userName = (String) session.getAttribute("userName");

        System.out.println("Dashboard accessed by: " + userName + " (Role: " + userRole + ")");

        // Forward to dashboard JSP
        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(request, response);
    }
}