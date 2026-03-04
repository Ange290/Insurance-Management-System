package com.insurance.controller;

import com.insurance.dao.PolicyDAO;
import com.insurance.dao.ClaimDAO;
import com.insurance.dao.PaymentDAO;
import com.insurance.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/report", "/reports",
        "/admin/report", "/admin/reports",
        "/manager/report", "/manager/reports"})
public class ReportServlet extends HttpServlet {

    private PolicyDAO policyDAO = new PolicyDAO();
    private ClaimDAO claimDAO = new ClaimDAO();
    private PaymentDAO paymentDAO = new PaymentDAO();
    private UserDAO userDAO = new UserDAO();

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

        // Only Admin and Manager can access reports
        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        try {
            // Get statistics
            int totalPolicies = policyDAO.getTotalCount();
            int activePolicies = policyDAO.getActiveCount();
            int totalClaims = claimDAO.getTotalCount();
            int pendingClaims = claimDAO.getPendingCount();
            int approvedClaims = claimDAO.getApprovedCount();
            int rejectedClaims = claimDAO.getRejectedCount();
            double totalPayments = paymentDAO.getTotalAmount();
            double pendingPayments = paymentDAO.getPendingAmount();
            int totalUsers = userDAO.getTotalCount();
            int activeUsers = userDAO.getActiveCount();

            // Set attributes for JSP
            request.setAttribute("totalPolicies", totalPolicies);
            request.setAttribute("activePolicies", activePolicies);
            request.setAttribute("totalClaims", totalClaims);
            request.setAttribute("pendingClaims", pendingClaims);
            request.setAttribute("approvedClaims", approvedClaims);
            request.setAttribute("rejectedClaims", rejectedClaims);
            request.setAttribute("totalPayments", totalPayments);
            request.setAttribute("pendingPayments", pendingPayments);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);

            // Forward to report JSP
            request.getRequestDispatcher("/WEB-INF/views/report.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reports: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/report.jsp").forward(request, response);
        }
    }
}