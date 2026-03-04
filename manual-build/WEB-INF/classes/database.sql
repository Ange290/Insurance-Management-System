DROP DATABASE IF EXISTS insurance_management_system;
CREATE DATABASE insurance_management_system CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE insurance_management_system;

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
) ENGINE=InnoDB;

CREATE TABLE policy_types (
    policy_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    base_rate DECIMAL(5,2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE policies (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    policy_type_id INT NOT NULL,
    policy_number VARCHAR(50) NOT NULL UNIQUE,
    coverage_amount DECIMAL(12,2) NOT NULL,
    premium DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (policy_type_id) REFERENCES policy_types(policy_type_id)
) ENGINE=InnoDB;

CREATE TABLE claims (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    claim_number VARCHAR(50) NOT NULL UNIQUE,
    claim_amount DECIMAL(12,2) NOT NULL,
    claim_reason TEXT NOT NULL,
    incident_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks TEXT,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
) ENGINE=InnoDB;

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_date DATE NOT NULL,
    transaction_id VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
) ENGINE=InnoDB;

-- Insert default roles
INSERT INTO roles (role_name) VALUES ('Admin'), ('Manager'), ('Customer');

-- Insert default admin user (password: admin123)
INSERT INTO users (name, email, password, phone, address, role_id)
VALUES ('Admin User', 'admin@insurance.com', 'admin123', '1234567890', 'Admin Address', 1);

-- Insert policy types
INSERT INTO policy_types (type_name, description, base_rate) VALUES
('Life Insurance', 'Provides financial security for your family', 2.50),
('Health Insurance', 'Covers medical expenses and hospitalization', 3.00),
('Vehicle Insurance', 'Protects your vehicle against damages', 4.00),
('Property Insurance', 'Safeguards your property and assets', 3.50);