package com.insurance.dao;

import com.insurance.model.Claim;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClaimDAO {

    public List<Claim> getAllClaims() {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.policy_number, u.name as user_name FROM claims c " +
                "JOIN policies p ON c.policy_id = p.policy_id " +
                "JOIN users u ON p.user_id = u.user_id " +
                "ORDER BY c.claim_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Claim claim = extractClaim(rs);
                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }

    public List<Claim> getClaimsByUserId(int userId) {
        List<Claim> claims = new ArrayList<>();
        String sql = "SELECT c.*, p.policy_number, u.name as user_name FROM claims c " +
                "JOIN policies p ON c.policy_id = p.policy_id " +
                "JOIN users u ON p.user_id = u.user_id " +
                "WHERE p.user_id = ? ORDER BY c.claim_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Claim claim = extractClaim(rs);
                claims.add(claim);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return claims;
    }

    public Claim getClaimById(int id) {
        String sql = "SELECT c.*, p.policy_number, u.name as user_name FROM claims c " +
                "JOIN policies p ON c.policy_id = p.policy_id " +
                "JOIN users u ON p.user_id = u.user_id " +
                "WHERE c.claim_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractClaim(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertClaim(Claim claim) {
        String sql = "INSERT INTO claims (policy_id, claim_number, claim_amount, claim_reason, incident_date, status, remarks) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, claim.getPolicyId());
            stmt.setString(2, claim.getClaimNumber());
            stmt.setDouble(3, claim.getClaimAmount());
            stmt.setString(4, claim.getClaimReason());
            stmt.setDate(5, claim.getIncidentDate());
            stmt.setString(6, claim.getStatus());
            stmt.setString(7, claim.getRemarks());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateClaim(Claim claim) {
        String sql = "UPDATE claims SET policy_id = ?, claim_number = ?, claim_amount = ?, claim_reason = ?, incident_date = ?, status = ?, remarks = ? WHERE claim_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, claim.getPolicyId());
            stmt.setString(2, claim.getClaimNumber());
            stmt.setDouble(3, claim.getClaimAmount());
            stmt.setString(4, claim.getClaimReason());
            stmt.setDate(5, claim.getIncidentDate());
            stmt.setString(6, claim.getStatus());
            stmt.setString(7, claim.getRemarks());
            stmt.setInt(8, claim.getClaimId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteClaim(int id) {
        String sql = "DELETE FROM claims WHERE claim_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Claim extractClaim(ResultSet rs) throws SQLException {
        Claim claim = new Claim();
        claim.setClaimId(rs.getInt("claim_id"));
        claim.setPolicyId(rs.getInt("policy_id"));
        claim.setClaimNumber(rs.getString("claim_number"));
        claim.setClaimAmount(rs.getDouble("claim_amount"));
        claim.setClaimReason(rs.getString("claim_reason"));
        claim.setIncidentDate(rs.getDate("incident_date"));
        claim.setStatus(rs.getString("status"));
        claim.setSubmittedDate(rs.getTimestamp("submitted_date"));
        claim.setRemarks(rs.getString("remarks"));
        claim.setPolicyNumber(rs.getString("policy_number"));
        claim.setUserName(rs.getString("user_name"));
        return claim;
    }
    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM claims";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getPendingCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM claims WHERE status = 'Pending'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getApprovedCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM claims WHERE status = 'Approved'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getRejectedCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM claims WHERE status = 'Rejected'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
}