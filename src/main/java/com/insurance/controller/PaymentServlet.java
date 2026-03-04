package com.insurance.controller;

import com.insurance.dao.PaymentDAO;
import com.insurance.dao.PolicyDAO;
import com.insurance.model.Payment;
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
import java.util.UUID;

@WebServlet({"/payment", "/payments",
        "/admin/payment", "/admin/payments",
        "/agent/payment", "/agent/payments",
        "/customer/payment", "/customer/payments",
        "/manager/payment", "/manager/payments"})
public class PaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO = new PaymentDAO();
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
            case "view":
                viewPayment(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deletePayment(request, response);
                break;
            default:
                listPayments(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("update".equals(action)) {
            updatePayment(request, response);
        } else {
            insertPayment(request, response);
        }
    }

    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        Integer userId = (Integer) session.getAttribute("userId");

        List<Payment> payments;
        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            payments = paymentDAO.getAllPayments();
        } else {
            payments = paymentDAO.getPaymentsByUserId(userId);
        }

        request.setAttribute("payments", payments);
        request.getRequestDispatcher("/WEB-INF/views/payment-list.jsp").forward(request, response);
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
        request.getRequestDispatcher("/WEB-INF/views/payment-form.jsp").forward(request, response);
    }

    private void viewPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Payment payment = paymentDAO.getPaymentById(id);
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/WEB-INF/views/payment-view.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Payment payment = paymentDAO.getPaymentById(id);

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("userRole");

        List<Policy> policies;
        if ("Admin".equals(userRole) || "Manager".equals(userRole)) {
            policies = policyDAO.getAllPolicies();
        } else {
            policies = policyDAO.getPoliciesByUserId(userId);
        }

        request.setAttribute("payment", payment);
        request.setAttribute("policies", policies);
        request.getRequestDispatcher("/WEB-INF/views/payment-form.jsp").forward(request, response);
    }

    private void insertPayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Payment payment = new Payment();
        payment.setPolicyId(Integer.parseInt(request.getParameter("policyId")));
        payment.setAmount(Double.parseDouble(request.getParameter("amount")));
        payment.setPaymentMethod(request.getParameter("paymentMethod"));
        payment.setPaymentDate(Date.valueOf(request.getParameter("paymentDate")));
        payment.setTransactionId("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        paymentDAO.insertPayment(payment);

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/payments");
    }

    private void updatePayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Payment payment = new Payment();
        payment.setPaymentId(Integer.parseInt(request.getParameter("paymentId")));
        payment.setPolicyId(Integer.parseInt(request.getParameter("policyId")));
        payment.setAmount(Double.parseDouble(request.getParameter("amount")));
        payment.setPaymentMethod(request.getParameter("paymentMethod"));
        payment.setPaymentDate(Date.valueOf(request.getParameter("paymentDate")));
        payment.setTransactionId(request.getParameter("transactionId"));
        paymentDAO.updatePayment(payment);

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/payments");
    }

    private void deletePayment(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        paymentDAO.deletePayment(id);

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        response.sendRedirect(request.getContextPath() + "/" + userRole.toLowerCase() + "/payments");
    }
}