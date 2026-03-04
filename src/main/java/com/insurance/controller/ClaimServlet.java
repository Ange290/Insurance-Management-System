package com.insurance.controller;

import com.insurance.dao.ClaimDAO;
import com.insurance.dao.PolicyDAO;
import com.insurance.model.Claim;
import com.insurance.model.Policy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet({"/claim", "/claims",
        "/admin/claim", "/admin/claims",
        "/agent/claim", "/agent/claims",
        "/customer/claim", "/customer/claims",
        "/manager/claim", "/manager/claims"})
public class ClaimServlet extends HttpServlet {

    private ClaimDAO claimDAO = new ClaimDAO();
    private PolicyDAO policyDAO = new PolicyDAO();

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
                deleteClaim(request, response);
                break;
            default:
                listClaims(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            insertClaim(request, response);
        } else if ("update".equals(action)) {
            updateClaim(request, response);
        }
    }

    private void listClaims(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");

        List<Claim> claims;
        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            claims = claimDAO.getAllClaims();
        } else {
            claims = claimDAO.getClaimsByUserId(userId);
        }

        request.setAttribute("claims", claims);
        request.getRequestDispatcher("/WEB-INF/views/claim-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        List<Policy> policies;
        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            policies = policyDAO.getAllPolicies();
        } else {
            policies = policyDAO.getPoliciesByUserId(userId);
        }

        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/WEB-INF/views/claim-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Claim claim = claimDAO.getClaimById(id);

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        List<Policy> policies;
        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            policies = policyDAO.getAllPolicies();
        } else {
            policies = policyDAO.getPoliciesByUserId(userId);
        }

        request.setAttribute("claim", claim);
        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/WEB-INF/views/claim-form.jsp").forward(request, response);
    }

    private void insertClaim(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Claim claim = new Claim();
        claim.setPolicyId(Integer.parseInt(request.getParameter("policyId")));
        claim.setClaimNumber(request.getParameter("claimNumber"));
        claim.setClaimAmount(Double.parseDouble(request.getParameter("claimAmount")));
        claim.setClaimReason(request.getParameter("claimReason"));
        claim.setIncidentDate(Date.valueOf(request.getParameter("incidentDate")));
        claim.setStatus("Pending");
        claim.setRemarks(request.getParameter("remarks"));
        claimDAO.insertClaim(claim);
        response.sendRedirect("claim");
    }

    private void updateClaim(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Claim claim = new Claim();
        claim.setClaimId(Integer.parseInt(request.getParameter("id")));
        claim.setPolicyId(Integer.parseInt(request.getParameter("policyId")));
        claim.setClaimNumber(request.getParameter("claimNumber"));
        claim.setClaimAmount(Double.parseDouble(request.getParameter("claimAmount")));
        claim.setClaimReason(request.getParameter("claimReason"));
        claim.setIncidentDate(Date.valueOf(request.getParameter("incidentDate")));
        claim.setStatus(request.getParameter("status"));
        claim.setRemarks(request.getParameter("remarks"));
        claimDAO.updateClaim(claim);
        response.sendRedirect("claim");
    }

    private void deleteClaim(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        claimDAO.deleteClaim(id);
        response.sendRedirect("claim");
    }
}