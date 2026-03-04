<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${claim != null ? 'Edit' : 'File'} Claim - Insurance Management System</title>
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
            min-height: 120px;
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
        <h2> Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/claims">Back to Claims</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <h3>${claim != null ? '️ Edit Claim' : ' File New Claim'}</h3>

            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success">${success}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/claim" method="post">
                <input type="hidden" name="action" value="${claim != null ? 'update' : 'create'}">
                <c:if test="${claim != null}">
                    <input type="hidden" name="claimId" value="${claim.claimId}">
                </c:if>

                <div class="form-group">
                    <label for="claimNumber">Claim Number <span class="required">*</span></label>
                    <input type="text" id="claimNumber" name="claimNumber" value="${claim.claimNumber}" required>
                </div>

                <div class="form-group">
                    <label for="policyId">Policy <span class="required">*</span></label>
                    <select id="policyId" name="policyId" required>
                        <option value="">Select Policy</option>
                        <c:forEach var="policy" items="${policies}">
                            <option value="${policy.policyId}" ${claim.policyId == policy.policyId ? 'selected' : ''}>
                                ${policy.policyNumber} - ${policy.userName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="claimAmount">Claim Amount <span class="required">*</span></label>
                    <input type="number" id="claimAmount" name="claimAmount" step="0.01" value="${claim.claimAmount}" required>
                </div>

                <div class="form-group">
                    <label for="incidentDate">Incident Date <span class="required">*</span></label>
                    <input type="date" id="incidentDate" name="incidentDate" value="${claim.incidentDate}" required>
                </div>

                <div class="form-group">
                    <label for="claimReason">Claim Reason <span class="required">*</span></label>
                    <textarea id="claimReason" name="claimReason" required>${claim.claimReason}</textarea>
                </div>

                <div class="form-group">
                    <label for="status">Status <span class="required">*</span></label>
                    <select id="status" name="status" required>
                        <option value="Pending" ${claim.status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Approved" ${claim.status == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Rejected" ${claim.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="remarks">Remarks</label>
                    <textarea id="remarks" name="remarks">${claim.remarks}</textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ${claim != null ? 'Update Claim' : 'File Claim'}
                    </button>
                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/claims" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>