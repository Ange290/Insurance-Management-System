<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${policy != null ? 'Edit' : 'Add'} Policy - Insurance Management System</title>
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
        input[type="number"],
        input[type="date"],
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Outfit', sans-serif;
            transition: all 0.3s;
        }

        input:focus,
        select:focus {
            outline: none;
            border-color: #84cc16;
            box-shadow: 0 0 0 3px rgba(132, 204, 22, 0.1);
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
    </style>
</head>
<body>
    <div class="navbar">
        <h2>️ Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/policies">Back to Policies</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <h3>${policy != null ? '️ Edit Policy' : ' Add New Policy'}</h3>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/policy" method="post">
                <input type="hidden" name="action" value="${policy != null ? 'update' : 'insert'}">
                <c:if test="${policy != null}">
                    <input type="hidden" name="policyId" value="${policy.policyId}">
                </c:if>

                <div class="form-group">
                    <label for="policyNumber">Policy Number <span class="required">*</span></label>
                    <input type="text" id="policyNumber" name="policyNumber" value="${policy.policyNumber}" required>
                </div>

                <div class="form-group">
                    <label for="userId">Customer <span class="required">*</span></label>
                    <select id="userId" name="userId" required>
                        <option value="">Select Customer</option>
                        <c:forEach var="user" items="${users}">
                            <option value="${user.userId}" ${policy.userId == user.userId ? 'selected' : ''}>
                                ${user.name} (${user.email})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="policyTypeId">Policy Type <span class="required">*</span></label>
                    <select id="policyTypeId" name="policyTypeId" required>
                        <option value="">Select Policy Type</option>
                        <c:forEach var="type" items="${policyTypes}">
                            <option value="${type.policyTypeId}" ${policy.policyTypeId == type.policyTypeId ? 'selected' : ''}>
                                ${type.typeName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="premium">Premium Amount <span class="required">*</span></label>
                    <input type="number" id="premium" name="premium" step="0.01" value="${policy.premium}" required>
                </div>

                <div class="form-group">
                    <label for="coverageAmount">Coverage Amount <span class="required">*</span></label>
                    <input type="number" id="coverageAmount" name="coverageAmount" step="0.01" value="${policy.coverageAmount}" required>
                </div>

                <div class="form-group">
                    <label for="startDate">Start Date <span class="required">*</span></label>
                    <input type="date" id="startDate" name="startDate" value="${policy.startDate}" required>
                </div>

                <div class="form-group">
                    <label for="endDate">End Date <span class="required">*</span></label>
                    <input type="date" id="endDate" name="endDate" value="${policy.endDate}" required>
                </div>

                <div class="form-group">
                    <label for="status">Status <span class="required">*</span></label>
                    <select id="status" name="status" required>
                        <option value="Active" ${policy.status == 'Active' ? 'selected' : ''}>Active</option>
                        <option value="Inactive" ${policy.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                        <option value="Expired" ${policy.status == 'Expired' ? 'selected' : ''}>Expired</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ${policy != null ? 'Update Policy' : 'Create Policy'}
                    </button>
                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/policies" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>