package com.insurance.controller;

import com.insurance.dao.PolicyApplicationDAO;
import com.insurance.dao.PolicyTypeDAO;
import com.insurance.dao.PolicyDAO;
import com.insurance.model.PolicyApplication;
import com.insurance.model.PolicyType;
import com.insurance.model.Policy;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet({"/application", "/applications",
        "/admin/application", "/admin/applications",
        "/customer/application", "/customer/applications",
        "/manager/application", "/manager/applications"})
public class ApplicationServlet extends HttpServlet {

    private PolicyApplicationDAO applicationDAO = new PolicyApplicationDAO();
    private PolicyTypeDAO policyTypeDAO = new PolicyTypeDAO();
    private PolicyDAO policyDAO = new PolicyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showApplicationForm(request, response);
                break;
            case "view":
                viewApplication(request, response);
                break;
            case "review":
                showReviewForm(request, response);
                break;
            case "approve":
                approveApplication(request, response);
                break;
            case "reject":
                rejectApplication(request, response);
                break;
            default:
                listApplications(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("submit".equals(action)) {
            submitApplication(request, response);
        } else if ("review".equals(action)) {
            processReview(request, response);
        } else if ("createPolicy".equals(action)) {
            createPolicyFromApplication(request, response);
        }
    }

    // List all applications
    private void listApplications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");

        List<PolicyApplication> applications;

        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            // Managers see all applications
            applications = applicationDAO.getAllApplications();
        } else {
            // Customers see only their own applications
            applications = applicationDAO.getApplicationsByUserId(userId);
        }

        request.setAttribute("applications", applications);
        request.getRequestDispatcher("/WEB-INF/views/application-list.jsp").forward(request, response);
    }

    // Show application form (for customers)
    private void showApplicationForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PolicyType> policyTypes = policyTypeDAO.getAllPolicyTypes();
        request.setAttribute("policyTypes", policyTypes);
        request.getRequestDispatcher("/WEB-INF/views/application-form.jsp").forward(request, response);
    }

    // View application details
    private void viewApplication(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int applicationId = Integer.parseInt(request.getParameter("id"));
        PolicyApplication application = applicationDAO.getApplicationById(applicationId);

        // Security: Customers can only view their own applications
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");

        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            if (application.getUserId() != userId) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        }

        request.setAttribute("application", application);
        request.getRequestDispatcher("/WEB-INF/views/application-view.jsp").forward(request, response);
    }

    // Submit new application
    private void submitApplication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        PolicyApplication application = new PolicyApplication();
        application.setApplicationNumber(applicationDAO.generateApplicationNumber());
        application.setUserId(userId);
        application.setPolicyTypeId(Integer.parseInt(request.getParameter("policyTypeId")));
        application.setRequestedCoverage(new BigDecimal(request.getParameter("requestedCoverage")));
        application.setEstimatedPremium(new BigDecimal(request.getParameter("estimatedPremium")));
        application.setOccupation(request.getParameter("occupation"));
        application.setAnnualIncome(new BigDecimal(request.getParameter("annualIncome")));
        application.setHealthDeclaration(request.getParameter("healthDeclaration"));
        application.setPreviousInsurance(request.getParameter("previousInsurance"));
        application.setAdditionalInfo(request.getParameter("additionalInfo"));

        applicationDAO.insertApplication(application);

        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/applications?success=submitted");
    }

    // Show review form (for Manager/Admin)
    private void showReviewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security: Only Admin and Manager can review
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("id"));
        PolicyApplication application = applicationDAO.getApplicationById(applicationId);

        request.setAttribute("application", application);
        request.getRequestDispatcher("/WEB-INF/views/application-review.jsp").forward(request, response);
    }

    // Process review (approve/reject)
    private void processReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Security: Only Admin and Manager can review
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer reviewerId = (Integer) session.getAttribute("userId");

        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String status = request.getParameter("status");
        String managerNotes = request.getParameter("managerNotes");
        String rejectionReason = request.getParameter("rejectionReason");

        applicationDAO.updateApplicationStatus(applicationId, status, reviewerId, managerNotes, rejectionReason);

        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/applications?success=reviewed");
    }

    // Quick approve (sets status to "Under Review")
    private void approveApplication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer reviewerId = (Integer) session.getAttribute("userId");

        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("id"));
        applicationDAO.updateApplicationStatus(applicationId, "Under Review", reviewerId, "Application under review", null);

        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/applications");
    }

    // Quick reject
    private void rejectApplication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer reviewerId = (Integer) session.getAttribute("userId");

        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("id"));
        String reason = request.getParameter("reason");
        applicationDAO.updateApplicationStatus(applicationId, "Rejected", reviewerId, "Application rejected", reason);

        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/applications");
    }

    // Create policy from approved application
    private void createPolicyFromApplication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Security: Only Admin and Manager can create policies
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"Admin".equals(userRole) && !"Manager".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        PolicyApplication application = applicationDAO.getApplicationById(applicationId);

        // Create policy from application data
        Policy policy = new Policy();
        policy.setPolicyNumber("POL-" + System.currentTimeMillis());
        policy.setUserId(application.getUserId());
        policy.setPolicyTypeId(application.getPolicyTypeId());
        policy.setCoverageAmount(application.getRequestedCoverage().doubleValue());
        policy.setPremium(Double.parseDouble(request.getParameter("finalPremium")));
        policy.setStartDate(Date.valueOf(request.getParameter("startDate")));
        policy.setEndDate(Date.valueOf(request.getParameter("endDate")));
        policy.setStatus("Active");

        // Insert policy and get generated ID
        int policyId = policyDAO.insertPolicyAndGetId(policy);

        // Update application status and link to policy
        applicationDAO.updateApplicationStatus(applicationId, "Approved",
                (Integer) session.getAttribute("userId"), "Policy created successfully", null);
        applicationDAO.linkApplicationToPolicy(applicationId, policyId);

        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/policies?success=created");
    }
}