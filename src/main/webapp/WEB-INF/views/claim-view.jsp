<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Claim Details - Insurance Management System</title>
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
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 5px;
            font-weight: 500;
        }

        .nav-links a:hover {
            background: rgba(255,255,255,0.2);
        }

        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h3 {
            color: #1f2937;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 20px;
            margin-bottom: 15px;
        }

        .label {
            font-weight: 600;
            color: #374151;
        }

        .value {
            color: #6b7280;
        }

        .value.amount {
            font-size: 24px;
            font-weight: 700;
            color: #84cc16;
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

        .badge.approved {
            background: #dcfce7;
            color: #166534;
        }

        .badge.rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .text-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
        }

        .text-section h4 {
            color: #84cc16;
            margin-bottom: 10px;
        }

        .text-content {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
            color: #374151;
            line-height: 1.6;
        }

        .btn {
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            color: white;
            padding: 10px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            margin-top: 20px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(132, 204, 22, 0.4);
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
        <div class="card">
            <h3> Claim Details</h3>

            <div class="detail-grid">
                <div class="label">Claim ID:</div>
                <div class="value">${claim.claimId}</div>

                <div class="label">Claim Number:</div>
                <div class="value">${claim.claimNumber}</div>

                <div class="label">Policy Number:</div>
                <div class="value">${claim.policyNumber}</div>

                <div class="label">Customer:</div>
                <div class="value">${claim.userName}</div>

                <div class="label">Claim Amount:</div>
                <div class="value amount">$${claim.claimAmount}</div>

                <div class="label">Incident Date:</div>
                <div class="value">${claim.incidentDate}</div>

                <div class="label">Submitted Date:</div>
                <div class="value">${claim.submittedDate}</div>

                <div class="label">Status:</div>
                <div class="value">
                    <span class="badge ${claim.status.toLowerCase()}">${claim.status}</span>
                </div>
            </div>

            <div class="text-section">
                <h4>Claim Reason</h4>
                <div class="text-content">
                    ${claim.claimReason}
                </div>
            </div>

            <c:if test="${not empty claim.remarks}">
                <div class="text-section">
                    <h4>Remarks</h4>
                    <div class="text-content">
                        ${claim.remarks}
                    </div>
                </div>
            </c:if>

            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/claims" class="btn">← Back to Claims</a>
        </div>
    </div>
</body>
</html>