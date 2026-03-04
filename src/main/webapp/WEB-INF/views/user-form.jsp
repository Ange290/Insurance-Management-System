<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${user != null ? 'Edit' : 'Add'} User - Insurance Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: #f4f4f4;
        }

        .navbar {
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(132, 204, 22, 0.3);
        }

        .navbar h2 {
            font-size: 24px;
            font-weight: 600;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 5px;
            transition: all 0.3s;
            font-weight: 500;
        }

        .nav-links a:hover {
            background: rgba(255,255,255,0.2);
        }

        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .form-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h3 {
            color: #1f2937;
            margin-bottom: 30px;
            font-weight: 600;
            font-size: 24px;
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
        select,
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
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #84cc16;
            box-shadow: 0 0 0 3px rgba(132, 204, 22, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(132, 204, 22, 0.4);
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .error, .success {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }

        .success {
            background: #dcfce7;
            color: #166534;
            border-left: 4px solid #22c55e;
        }

        .required {
            color: #ef4444;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .help-text {
            font-size: 12px;
            color: #6b7280;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>🛡️ Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/user">Back to Users</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <h3>${user != null ? '✏️ Edit User' : '➕ Add New User'}</h3>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/user" method="post">
                <input type="hidden" name="action" value="${user != null ? 'update' : 'insert'}">
                <c:if test="${user != null}">
                    <input type="hidden" name="userId" value="${user.userId}">
                </c:if>

                <div class="form-group">
                    <label for="name">Full Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name" value="${user.name}" required
                           placeholder="Enter full name">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" value="${user.email}" required
                               placeholder="user@example.com">
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone Number <span class="required">*</span></label>
                        <input type="tel" id="phone" name="phone" value="${user.phone}" required
                               placeholder="+1234567890">
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <textarea id="address" name="address" placeholder="Enter full address">${user.address}</textarea>
                </div>

                <div class="form-group">
                    <label for="password">Password <span class="required">*</span></label>
                    <input type="password" id="password" name="password"
                           ${user != null ? '' : 'required'}
                           placeholder="${user != null ? 'Leave blank to keep current password' : 'Enter password'}">
                    <c:if test="${user != null}">
                        <div class="help-text">Leave blank to keep the current password</div>
                    </c:if>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="roleId">Role <span class="required">*</span></label>
                        <select id="roleId" name="roleId" required>
                            <option value="">Select Role</option>
                            <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Admin</option>
                            <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Manager</option>
                            <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Customer</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="status">Status <span class="required">*</span></label>
                        <select id="status" name="status" required>
                            <option value="">Select Status</option>
                            <option value="Active" ${user.status == 'Active' ? 'selected' : ''}>Active</option>
                            <option value="Inactive" ${user.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                            <option value="Suspended" ${user.status == 'Suspended' ? 'selected' : ''}>Suspended</option>
                        </select>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ${user != null ? '💾 Update User' : '➕ Create User'}
                    </button>
                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/user"
                       class="btn btn-secondary">❌ Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>