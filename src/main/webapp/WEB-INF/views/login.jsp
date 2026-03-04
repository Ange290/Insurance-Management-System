<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Insurance Management System</title>
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
        }

        .login-container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
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
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s;
        }

        input:focus {
            outline: none;
            border-color: #84cc16;
            box-shadow: 0 0 0 3px rgba(132, 204, 22, 0.1);
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

        .register-link {
            text-align: center;
            margin-top: 20px;
            color: #6b7280;
        }

        .register-link a {
            color: #84cc16;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
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

        .success {
            background: #dcfce7;
            color: #166534;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #22c55e;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h2>🛡️ Insurance System</h2>
            <p>Your protection, our priority</p>
        </div>

        <h3>Login to Your Account</h3>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Email Address <span class="required">*</span></label>
                <input type="text" id="username" name="username" required
                       placeholder="Enter your email">
            </div>

            <div class="form-group">
                <label for="password">Password <span class="required">*</span></label>
                <input type="password" id="password" name="password" required
                       placeholder="Enter your password">
            </div>

            <button type="submit" class="btn">Login</button>
        </form>

        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
        </div>
    </div>
</body>
</html>