package com.insurance.dao;

import com.insurance.model.User;
import com.insurance.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "ORDER BY u.user_id DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(extractUser(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Get user by ID
    public User getUserById(int userId) {
        String sql = "SELECT u.*, r.role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "WHERE u.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get user by email (for login)
    public User getUserByEmail(String email) {
        String sql = "SELECT u.*, r.role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "WHERE u.email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractUser(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Get only customers (for policy forms)
    public List<User> getCustomersOnly() {
        List<User> customers = new ArrayList<>();
        String sql = "SELECT u.*, r.role_name FROM users u " +
                "JOIN roles r ON u.role_id = r.role_id " +
                "WHERE r.role_name = 'Customer' " +
                "ORDER BY u.name";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                customers.add(extractUser(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // Insert new user (NO USERNAME)
    public boolean insertUser(User user) {
        String sql = "INSERT INTO users (name, email, phone, address, password, role_id, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getPassword());
            stmt.setInt(6, user.getRoleId());
            stmt.setString(7, user.getStatus());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update user (NO USERNAME)
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, phone = ?, address = ?, " +
                "password = ?, role_id = ?, status = ? WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getAddress());
            stmt.setString(5, user.getPassword());
            stmt.setInt(6, user.getRoleId());
            stmt.setString(7, user.getStatus());
            stmt.setInt(8, user.getUserId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete user
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Get total user count
    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Get active user count
    public int getActiveCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'Active'";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Helper method to extract user from ResultSet
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setPassword(rs.getString("password"));
        user.setRoleId(rs.getInt("role_id"));
        user.setRoleName(rs.getString("role_name"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}