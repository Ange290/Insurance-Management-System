package com.insurance.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DatabaseConnection {
    // Database credentials - CHANGE THESE TO MATCH YOUR MYSQL SETUP
    private static final String URL = "jdbc:mysql://localhost:3306/insurance_management_system?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";  // Change to your MySQL username
    private static final String PASSWORD = "";  // Change to your MySQL password

    // JDBC Driver class name
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // Static block to load the JDBC driver
    static {
        try {
            Class.forName(DRIVER_CLASS);
            System.out.println("MySQL JDBC Driver loaded successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connection established successfully!");
            return conn;
        } catch (SQLException e) {
            System.err.println("Failed to create database connection!");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            e.printStackTrace();
            throw e;
        }
    }

    /**
     * Close database connection
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("Database connection closed successfully!");
            } catch (SQLException e) {
                System.err.println("Error closing database connection!");
                e.printStackTrace();
            }
        }
    }

    /**
     * Close Statement
     * @param stmt Statement to close
     */
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Close PreparedStatement
     * @param pstmt PreparedStatement to close
     */
    public static void closePreparedStatement(PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Close ResultSet
     * @param rs ResultSet to close
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Close all resources (Connection, Statement, ResultSet)
     * @param conn Connection to close
     * @param stmt Statement to close
     * @param rs ResultSet to close
     */
    public static void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        closeResultSet(rs);
        closeStatement(stmt);
        closeConnection(conn);
    }

    /**
     * Close all resources (Connection, PreparedStatement, ResultSet)
     * @param conn Connection to close
     * @param pstmt PreparedStatement to close
     * @param rs ResultSet to close
     */
    public static void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        closeResultSet(rs);
        closePreparedStatement(pstmt);
        closeConnection(conn);
    }

    /**
     * Test database connection
     * @return true if connection successful, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed!");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Main method to test database connection
     */
    public static void main(String[] args) {
        System.out.println("Testing Database Connection...");
        System.out.println("================================");

        if (testConnection()) {
            System.out.println("✓ SUCCESS: Database connection is working!");
        } else {
            System.out.println("✗ FAILED: Could not connect to database!");
            System.out.println("\nPlease check:");
            System.out.println("1. MySQL server is running");
            System.out.println("2. Database 'insurance_management_system' exists");
            System.out.println("3. Username and password are correct");
            System.out.println("4. MySQL JDBC driver is in classpath");
        }
    }
}