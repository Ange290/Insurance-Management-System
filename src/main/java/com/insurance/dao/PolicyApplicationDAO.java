package com.insurance.dao;

import com.insurance.model.PolicyApplication;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PolicyApplicationDAO {

    // Get all applications (for Admin/Manager)
    public List<PolicyApplication> getAllApplications() {
        List<PolicyApplication> applications = new ArrayList<>();
        String sql = "SELECT pa.*, u.name as user_name, u.email as user_email, " +
                "pt.type_name as policy_type_name, r.name as reviewer_name " +
                "FROM policy_applications pa " +
                "JOIN users u ON pa.user_id = u.user_id " +
                "JOIN policy_types pt ON pa.policy_type_id = pt.policy_type_id " +
                "LEFT JOIN users r ON pa.reviewed_by = r.user_id " +
                "ORDER BY pa.submitted_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                applications.add(extractApplication(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }

    // Get applications by user (for Customers)
    public List<PolicyApplication> getApplicationsByUserId(int userId) {
        List<PolicyApplication> applications = new ArrayList<>();
        String sql = "SELECT pa.*, u.name as user_name, u.email as user_email, " +
                "pt.type_name as policy_type_name, r.name as reviewer_name " +
                "FROM policy_applications pa " +
                "JOIN users u ON pa.user_id = u.user_id " +
                "JOIN policy_types pt ON pa.policy_type_id = pt.policy_type_id " +
                "LEFT JOIN users r ON pa.reviewed_by = r.user_id " +
                "WHERE pa.user_id = ? " +
                "ORDER BY pa.submitted_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                applications.add(extractApplication(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return applications;
    }

    // Get application by ID
    public PolicyApplication getApplicationById(int applicationId) {
        String sql = "SELECT pa.*, u.name as user_name, u.email as user_email, " +
                "pt.type_name as policy_type_name, r.name as reviewer_name " +
                "FROM policy_applications pa " +
                "JOIN users u ON pa.user_id = u.user_id " +
                "JOIN policy_types pt ON pa.policy_type_id = pt.policy_type_id " +
                "LEFT JOIN users r ON pa.reviewed_by = r.user_id " +
                "WHERE pa.application_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, applicationId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractApplication(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Insert new application
    public boolean insertApplication(PolicyApplication application) {
        String sql = "INSERT INTO policy_applications (application_number, user_id, policy_type_id, " +
                "requested_coverage, estimated_premium, occupation, annual_income, " +
                "health_declaration, previous_insurance, additional_info, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, application.getApplicationNumber());
            stmt.setInt(2, application.getUserId());
            stmt.setInt(3, application.getPolicyTypeId());
            stmt.setBigDecimal(4, application.getRequestedCoverage());
            stmt.setBigDecimal(5, application.getEstimatedPremium());
            stmt.setString(6, application.getOccupation());
            stmt.setBigDecimal(7, application.getAnnualIncome());
            stmt.setString(8, application.getHealthDeclaration());
            stmt.setString(9, application.getPreviousInsurance());
            stmt.setString(10, application.getAdditionalInfo());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update application status (for review)
    public boolean updateApplicationStatus(int applicationId, String status, int reviewedBy,
                                           String managerNotes, String rejectionReason) {
        String sql = "UPDATE policy_applications SET status = ?, reviewed_by = ?, " +
                "reviewed_date = CURRENT_TIMESTAMP, manager_notes = ?, rejection_reason = ? " +
                "WHERE application_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, reviewedBy);
            stmt.setString(3, managerNotes);
            stmt.setString(4, rejectionReason);
            stmt.setInt(5, applicationId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Link application to created policy
    public boolean linkApplicationToPolicy(int applicationId, int policyId) {
        String sql = "UPDATE policy_applications SET policy_id = ? WHERE application_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, policyId);
            stmt.setInt(2, applicationId);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get pending applications count
    public int getPendingApplicationsCount() {
        String sql = "SELECT COUNT(*) FROM policy_applications WHERE status = 'Pending'";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Generate unique application number
    public String generateApplicationNumber() {
        return "APP-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 4).toUpperCase();
    }

    // Helper method to extract application from ResultSet
    private PolicyApplication extractApplication(ResultSet rs) throws SQLException {
        PolicyApplication app = new PolicyApplication();
        app.setApplicationId(rs.getInt("application_id"));
        app.setApplicationNumber(rs.getString("application_number"));
        app.setUserId(rs.getInt("user_id"));
        app.setPolicyTypeId(rs.getInt("policy_type_id"));
        app.setRequestedCoverage(rs.getBigDecimal("requested_coverage"));
        app.setEstimatedPremium(rs.getBigDecimal("estimated_premium"));
        app.setOccupation(rs.getString("occupation"));
        app.setAnnualIncome(rs.getBigDecimal("annual_income"));
        app.setHealthDeclaration(rs.getString("health_declaration"));
        app.setPreviousInsurance(rs.getString("previous_insurance"));
        app.setAdditionalInfo(rs.getString("additional_info"));
        app.setStatus(rs.getString("status"));
        app.setSubmittedDate(rs.getTimestamp("submitted_date"));

        // Review info (may be null)
        int reviewedBy = rs.getInt("reviewed_by");
        app.setReviewedBy(rs.wasNull() ? null : reviewedBy);
        app.setReviewedDate(rs.getTimestamp("reviewed_date"));
        app.setRejectionReason(rs.getString("rejection_reason"));
        app.setManagerNotes(rs.getString("manager_notes"));

        // Policy link (may be null)
        int policyId = rs.getInt("policy_id");
        app.setPolicyId(rs.wasNull() ? null : policyId);

        // Joined data
        app.setUserName(rs.getString("user_name"));
        app.setUserEmail(rs.getString("user_email"));
        app.setPolicyTypeName(rs.getString("policy_type_name"));
        app.setReviewerName(rs.getString("reviewer_name"));

        return app;
    }
}