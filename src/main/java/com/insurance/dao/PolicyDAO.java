package com.insurance.dao;

import com.insurance.model.Policy;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PolicyDAO {

    public List<Policy> getAllPolicies() {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT p.*, u.name as user_name, pt.type_name FROM policies p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "JOIN policy_types pt ON p.policy_type_id = pt.policy_type_id " +
                "ORDER BY p.policy_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Policy policy = extractPolicy(rs);
                policies.add(policy);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    public List<Policy> getPoliciesByUserId(int userId) {
        List<Policy> policies = new ArrayList<>();
        String sql = "SELECT p.*, u.name as user_name, pt.type_name FROM policies p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "JOIN policy_types pt ON p.policy_type_id = pt.policy_type_id " +
                "WHERE p.user_id = ? ORDER BY p.policy_id DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Policy policy = extractPolicy(rs);
                policies.add(policy);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policies;
    }

    public Policy getPolicyById(int id) {
        String sql = "SELECT p.*, u.name as user_name, pt.type_name FROM policies p " +
                "JOIN users u ON p.user_id = u.user_id " +
                "JOIN policy_types pt ON p.policy_type_id = pt.policy_type_id " +
                "WHERE p.policy_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return extractPolicy(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertPolicy(Policy policy) {
        String sql = "INSERT INTO policies (user_id, policy_type_id, policy_number, coverage_amount, premium, start_date, end_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, policy.getUserId());
            stmt.setInt(2, policy.getPolicyTypeId());
            stmt.setString(3, policy.getPolicyNumber());
            stmt.setDouble(4, policy.getCoverageAmount());
            stmt.setDouble(5, policy.getPremium());
            stmt.setDate(6, policy.getStartDate());
            stmt.setDate(7, policy.getEndDate());
            stmt.setString(8, policy.getStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // NEW METHOD: Insert policy and return generated ID
    public int insertPolicyAndGetId(Policy policy) {
        String sql = "INSERT INTO policies (user_id, policy_type_id, policy_number, coverage_amount, premium, start_date, end_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, policy.getUserId());
            stmt.setInt(2, policy.getPolicyTypeId());
            stmt.setString(3, policy.getPolicyNumber());
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

    public boolean updatePolicy(Policy policy) {
        String sql = "UPDATE policies SET user_id = ?, policy_type_id = ?, policy_number = ?, coverage_amount = ?, premium = ?, start_date = ?, end_date = ?, status = ? WHERE policy_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, policy.getUserId());
            stmt.setInt(2, policy.getPolicyTypeId());
            stmt.setString(3, policy.getPolicyNumber());
            stmt.setDouble(4, policy.getCoverageAmount());
            stmt.setDouble(5, policy.getPremium());
            stmt.setDate(6, policy.getStartDate());
            stmt.setDate(7, policy.getEndDate());
            stmt.setString(8, policy.getStatus());
            stmt.setInt(9, policy.getPolicyId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePolicy(int id) {
        String sql = "DELETE FROM policies WHERE policy_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Policy extractPolicy(ResultSet rs) throws SQLException {
        Policy policy = new Policy();
        policy.setPolicyId(rs.getInt("policy_id"));
        policy.setUserId(rs.getInt("user_id"));
        policy.setPolicyTypeId(rs.getInt("policy_type_id"));
        policy.setPolicyNumber(rs.getString("policy_number"));
        policy.setCoverageAmount(rs.getDouble("coverage_amount"));
        policy.setPremium(rs.getDouble("premium"));
        policy.setStartDate(rs.getDate("start_date"));
        policy.setEndDate(rs.getDate("end_date"));
        policy.setStatus(rs.getString("status"));
        policy.setCreatedAt(rs.getTimestamp("created_at"));
        policy.setUserName(rs.getString("user_name"));
        policy.setPolicyTypeName(rs.getString("type_name"));
        return policy;
    }

    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM policies";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getActiveCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM policies WHERE status = 'Active'";
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