<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Applications - Insurance Management System</title>
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
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .header {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h3 {
            color: #1f2937;
            font-weight: 600;
        }

        .btn {
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            color: white;
            padding: 10px 25px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(132, 204, 22, 0.4);
        }

        .table-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            color: white;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }

        td {
            padding: 12px 15px;
            border-bottom: 1px solid #f3f4f6;
        }

        tr:hover {
            background: #f9fafb;
        }

        .badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .badge.pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge.under-review {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge.approved {
            background: #dcfce7;
            color: #166534;
        }

        .badge.rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .actions a {
            color: #84cc16;
            text-decoration: none;
            font-weight: 500;
            font-size: 13px;
        }

        .actions a:hover {
            text-decoration: underline;
        }

        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #22c55e;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }

        .empty-state h4 {
            margin-bottom: 10px;
            color: #374151;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2> Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="header">
            <h3>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'Customer'}">My Applications</c:when>
                    <c:otherwise>All Applications</c:otherwise>
                </c:choose>
            </h3>
            <c:if test="${sessionScope.userRole == 'Customer'}">
                <a href="${pageContext.request.contextPath}/customer/application?action=new" class="btn">+ New Application</a>
            </c:if>
        </div>

        <c:if test="${param.success == 'submitted'}">
            <div class="success-message">
                ✓ Application submitted successfully! We'll review it within 2-3 business days.
            </div>
        </c:if>

        <c:if test="${param.success == 'reviewed'}">
            <div class="success-message">
                ✓ Application reviewed successfully!
            </div>
        </c:if>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty applications}">
                    <div class="empty-state">
                        <h4>No Applications Found</h4>
                        <p>
                            <c:choose>
                                <c:when test="${sessionScope.userRole == 'Customer'}">
                                    You haven't submitted any applications yet. Click "New Application" to get started.
                                </c:when>
                                <c:otherwise>
                                    No applications have been submitted yet.
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>App #</th>
                                <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
                                    <th>Applicant</th>
                                </c:if>
                                <th>Insurance Type</th>
                                <th>Coverage</th>
                                <th>Premium</th>
                                <th>Submitted</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="app" items="${applications}">
                                <tr>
                                    <td>${app.applicationNumber}</td>
                                    <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
                                        <td>${app.userName}<br><small style="color:#6b7280">${app.userEmail}</small></td>
                                    </c:if>
                                    <td>${app.policyTypeName}</td>
                                    <td>$${app.requestedCoverage}</td>
                                    <td>$${app.estimatedPremium}/year</td>
                                    <td>${app.submittedDate}</td>
                                    <td>
                                        <span class="badge ${app.status == 'Pending' ? 'pending' :
                                                            app.status == 'Under Review' ? 'under-review' :
                                                            app.status == 'Approved' ? 'approved' : 'rejected'}">
                                            ${app.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application?action=view&id=${app.applicationId}">View</a>

                                            <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
                                                <c:if test="${app.status == 'Pending' || app.status == 'Under Review'}">
                                                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application?action=review&id=${app.applicationId}">Review</a>
                                                </c:if>
                                                <c:if test="${app.status == 'Approved' && app.policyId == null}">
                                                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application?action=review&id=${app.applicationId}" style="color: #f59e0b;">Create Policy</a>
                                                </c:if>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>