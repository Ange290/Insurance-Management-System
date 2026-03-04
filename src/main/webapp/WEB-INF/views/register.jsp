<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Insurance Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .register-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px;
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo h2 {
            color: #84cc16;
            font-size: 32px;
            font-weight: 700;
        }

        .logo p {
            color: #6b7280;
            margin-top: 5px;
        }

        h3 {
            color: #1f2937;
            margin-bottom: 25px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 500;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="tel"],
        textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s;
        }

        input:focus,
        textarea:focus {
            outline: none;
            border-color: #84cc16;
            box-shadow: 0 0 0 3px rgba(132, 204, 22, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .required {
            color: #ef4444;
        }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(132, 204, 22, 0.4);
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #6b7280;
        }

        .login-link a {
            color: #84cc16;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ef4444;
        }

        .password-strength {
            font-size: 12px;
            margin-top: 5px;
        }

        .strength-weak {
            color: #ef4444;
        }

        .strength-medium {
            color: #f59e0b;
        }

        .strength-strong {
            color: #22c55e;
        }
    </style>
    <script>
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const strengthDiv = document.getElementById('passwordStrength');

            if (password.length === 0) {
                strengthDiv.innerHTML = '';
                return;
            }

            let strength = 0;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;

            if (strength < 2) {
                strengthDiv.innerHTML = '<span class="strength-weak">Weak password</span>';
            } else if (strength < 3) {
                strengthDiv.innerHTML = '<span class="strength-medium">Medium password</span>';
            } else {
                strengthDiv.innerHTML = '<span class="strength-strong">Strong password</span>';
            }
        }

        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }

            if (password.length < 6) {
                alert('Password must be at least 6 characters long!');
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
    <div class="register-container">
        <div class="logo">
            <h2>🛡️ Insurance System</h2>
            <p>Your protection, our priority</p>
        </div>

        <h3>Create Account</h3>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="name">Full Name <span class="required">*</span></label>
                <input type="text" id="name" name="name" required placeholder="John Doe">
            </div>

            <div class="form-group">
                <label for="email">Email Address <span class="required">*</span></label>
                <input type="email" id="email" name="email" required placeholder="john@example.com">
            </div>

            <div class="form-group">
                <label for="phone">Phone Number <span class="required">*</span></label>
                <input type="tel" id="phone" name="phone" required placeholder="+1234567890">
            </div>

            <div class="form-group">
                <label for="address">Address <span class="required">*</span></label>
                <textarea id="address" name="address" required placeholder="Your full address"></textarea>
            </div>

            <div class="form-group">
                <label for="password">Password <span class="required">*</span></label>
                <input type="password" id="password" name="password" required
                       placeholder="At least 6 characters" onkeyup="checkPasswordStrength()">
                <div id="passwordStrength" class="password-strength"></div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
                <input type="password" id="confirmPassword" name="confirmPassword" required
                       placeholder="Re-enter password">
            </div>

            <button type="submit" class="btn">Create Account</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</body>
</html>