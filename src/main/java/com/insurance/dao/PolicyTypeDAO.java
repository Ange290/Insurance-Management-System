package com.insurance.dao;

import com.insurance.model.PolicyType;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PolicyTypeDAO {

    public List<PolicyType> getAllPolicyTypes() {
        List<PolicyType> policyTypes = new ArrayList<>();
        String sql = "SELECT * FROM policy_types ORDER BY policy_type_id";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                PolicyType policyType = new PolicyType();
                policyType.setPolicyTypeId(rs.getInt("policy_type_id"));
                policyType.setTypeName(rs.getString("type_name"));
                policyType.setDescription(rs.getString("description"));
                policyType.setBaseRate(rs.getDouble("base_rate"));
                policyTypes.add(policyType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return policyTypes;
    }

    public PolicyType getPolicyTypeById(int id) {
        String sql = "SELECT * FROM policy_types WHERE policy_type_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                PolicyType policyType = new PolicyType();
                policyType.setPolicyTypeId(rs.getInt("policy_type_id"));
                policyType.setTypeName(rs.getString("type_name"));
                policyType.setDescription(rs.getString("description"));
                policyType.setBaseRate(rs.getDouble("base_rate"));
                return policyType;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}