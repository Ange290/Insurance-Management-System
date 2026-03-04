package com.insurance.dao;

import com.insurance.model.Payment;
import com.insurance.model.Policy;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT pm.*, p.policy_number, u.name as user_name FROM payments pm " +
                "JOIN policies p ON pm.policy_id = p.policy_id " +
                "JOIN users u ON p.user_id = u.user_id " +
                "ORDER BY pm.payment_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Payment payment = extractPayment(rs);
                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    public List<Payment> getPaymentsByUserId(int userId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT pm.*, p.policy_number, u.name as user_name FROM payments pm " +
                "JOIN policies p ON pm.policy_id = p.policy_id " +
                "JOIN users u ON p.user_id = u.user_id " +
                "WHERE p.user_id = ? ORDER BY pm.payment_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Payment payment = extractPayment(rs);
                payments.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return payments;
    }

    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT pm.*, p.policy_number, u.name as user_name FROM payments pm " +
                "JOIN policies p ON pm.policy_id = p.policy_id " +
                "JOIN users u ON p.user_id = u.user_id " +
                "WHERE pm.payment_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, paymentId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractPayment(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertPayment(Payment payment) {
        String sql = "INSERT INTO payments (policy_id, amount, payment_method, payment_date, transaction_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, payment.getPolicyId());
            stmt.setDouble(2, payment.getAmount());
            stmt.setString(3, payment.getPaymentMethod());
            stmt.setDate(4, payment.getPaymentDate());
            stmt.setString(5, payment.getTransactionId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePayment(Payment payment) {
        String sql = "UPDATE payments SET policy_id = ?, amount = ?, payment_method = ?, payment_date = ?, transaction_id = ? WHERE payment_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payment.getPolicyId());
            stmt.setDouble(2, payment.getAmount());
            stmt.setString(3, payment.getPaymentMethod()); // FIXED TYPO
            stmt.setDate(4, payment.getPaymentDate());
            stmt.setString(5, payment.getTransactionId());
            stmt.setInt(6, payment.getPaymentId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePayment(int id) {
        String sql = "DELETE FROM payments WHERE payment_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getTotalAmount() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    public double getPendingAmount() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'Pending'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    private Payment extractPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setPolicyId(rs.getInt("policy_id"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentDate(rs.getDate("payment_date"));
        payment.setTransactionId(rs.getString("transaction_id"));
        payment.setCreatedAt(rs.getTimestamp("created_at"));
        payment.setPolicyNumber(rs.getString("policy_number"));
        payment.setUserName(rs.getString("user_name"));
        return payment;
    }
    // Add this method to PolicyDAO.java
    public int insertPolicyAndGetId(Policy policy) {
        String sql = "INSERT INTO policies (policy_number, user_id, policy_type_id, coverage_amount, " +
                "premium, start_date, end_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, policy.getPolicyNumber());
            stmt.setInt(2, policy.getUserId());
            stmt.setInt(3, policy.getPolicyTypeId());
            stmt.setDouble(4, policy.getCoverageAmount());
            stmt.setDouble(5, policy.getPremium());
            stmt.setDate(6, policy.getStartDate());
            stmt.setDate(7, policy.getEndDate());
            stmt.setString(8, policy.getStatus());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}