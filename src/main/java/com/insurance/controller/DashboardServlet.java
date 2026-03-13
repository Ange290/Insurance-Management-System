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

    private static final String DASHBOARD_JSP = "/WEB-INF/views/dashboard.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== DASHBOARD GET === " + request.getRequestURI());

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("No session - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Forward to JSP (your design)
        request.getRequestDispatcher(DASHBOARD_JSP).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}