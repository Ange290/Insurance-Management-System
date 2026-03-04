package com.insurance.controller;

import com.insurance.dao.PolicyDAO;
import com.insurance.dao.PolicyTypeDAO;
import com.insurance.dao.UserDAO;
import com.insurance.model.Policy;
import com.insurance.model.PolicyType;
import com.insurance.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet({"/policy", "/policies",
        "/admin/policy", "/admin/policies",
        "/agent/policy", "/agent/policies",
        "/customer/policy", "/customer/policies",
        "/manager/policy", "/manager/policies"})
public class PolicyServlet extends HttpServlet {

    private PolicyDAO policyDAO = new PolicyDAO();
    private PolicyTypeDAO policyTypeDAO = new PolicyTypeDAO();
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
                deletePolicy(request, response);
                break;
            default:
                listPolicies(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("insert".equals(action)) {
            insertPolicy(request, response);
        } else if ("update".equals(action)) {
            updatePolicy(request, response);
        }
    }

    private void listPolicies(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");

        List<Policy> policies;
        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            policies = policyDAO.getAllPolicies();
        } else {
            policies = policyDAO.getPoliciesByUserId(userId);
        }

        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/WEB-INF/views/policy-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PolicyType> policyTypes = policyTypeDAO.getAllPolicyTypes();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("policyTypes", policyTypes);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/policy-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Policy policy = policyDAO.getPolicyById(id);
        List<PolicyType> policyTypes = policyTypeDAO.getAllPolicyTypes();
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("policy", policy);
        request.setAttribute("policyTypes", policyTypes);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/policy-form.jsp").forward(request, response);
    }

    private void insertPolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Policy policy = new Policy();
        policy.setUserId(Integer.parseInt(request.getParameter("userId")));
        policy.setPolicyTypeId(Integer.parseInt(request.getParameter("policyTypeId")));
        policy.setPolicyNumber(request.getParameter("policyNumber"));
        policy.setCoverageAmount(Double.parseDouble(request.getParameter("coverageAmount")));
        policy.setPremium(Double.parseDouble(request.getParameter("premium")));
        policy.setStartDate(Date.valueOf(request.getParameter("startDate")));
        policy.setEndDate(Date.valueOf(request.getParameter("endDate")));
        policy.setStatus(request.getParameter("status"));
        policyDAO.insertPolicy(policy);
        response.sendRedirect("policy");
    }

    private void updatePolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Policy policy = new Policy();
        policy.setPolicyId(Integer.parseInt(request.getParameter("id")));
        policy.setUserId(Integer.parseInt(request.getParameter("userId")));
        policy.setPolicyTypeId(Integer.parseInt(request.getParameter("policyTypeId")));
        policy.setPolicyNumber(request.getParameter("policyNumber"));
        policy.setCoverageAmount(Double.parseDouble(request.getParameter("coverageAmount")));
        policy.setPremium(Double.parseDouble(request.getParameter("premium")));
        policy.setStartDate(Date.valueOf(request.getParameter("startDate")));
        policy.setEndDate(Date.valueOf(request.getParameter("endDate")));
        policy.setStatus(request.getParameter("status"));
        policyDAO.updatePolicy(policy);
        response.sendRedirect("policy");
    }

    private void deletePolicy(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        policyDAO.deletePolicy(id);
        response.sendRedirect("policy");
    }
}