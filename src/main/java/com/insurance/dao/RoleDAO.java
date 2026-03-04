package com.insurance.dao;

import com.insurance.model.Role;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO {

    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles ORDER BY role_id";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                roles.add(role);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }

    public Role getRoleById(int roleId) {
        String sql = "SELECT * FROM roles WHERE role_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roleId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                return role;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Role getRoleByName(String roleName) {
        String sql = "SELECT * FROM roles WHERE role_name = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, roleName);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                return role;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}