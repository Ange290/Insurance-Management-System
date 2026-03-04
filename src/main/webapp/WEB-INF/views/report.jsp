<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports - Insurance Management System</title>
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #84cc16;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
        }

        .stat-card.success {
            border-left-color: #22c55e;
        }

        .stat-card.warning {
            border-left-color: #eab308;
        }

        .stat-card.danger {
            border-left-color: #ef4444;
        }

        .stat-card.info {
            border-left-color: #3b82f6;
        }

        .stat-title {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            font-weight: 500;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 5px;
        }

        .stat-description {
            color: #9ca3af;
            font-size: 13px;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .section h4 {
            color: #1f2937;
            margin-bottom: 20px;
            border-bottom: 3px solid #84cc16;
            padding-bottom: 10px;
            font-weight: 600;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .summary-item {
            padding: 20px;
            background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%);
            border-radius: 8px;
            border-left: 3px solid #84cc16;
            transition: all 0.3s;
        }

        .summary-item:hover {
            transform: translateX(5px);
            box-shadow: 0 3px 10px rgba(132, 204, 22, 0.2);
        }

        .summary-label {
            font-size: 13px;
            color: #65a30d;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .summary-value {
            font-size: 24px;
            font-weight: 700;
            color: #1f2937;
        }

        .error {
            background-color: #fee2e2;
            color: #991b1b;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #ef4444;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2>️ Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="header">
            <h3>System Reports & Statistics</h3>
            <span>Welcome, ${sessionScope.userName}</span>
        </div>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <!-- Key Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-title">Total Policies</div>
                <div class="stat-value">${totalPolicies}</div>
                <div class="stat-description">${activePolicies} Active</div>
            </div>

            <div class="stat-card warning">
                <div class="stat-title">Pending Claims</div>
                <div class="stat-value">${pendingClaims}</div>
                <div class="stat-description">Out of ${totalClaims} total</div>
            </div>

            <div class="stat-card success">
                <div class="stat-title">Total Payments</div>
                <div class="stat-value">$<fmt:formatNumber value="${totalPayments}" pattern="#,##0.00"/></div>
                <div class="stat-description">$<fmt:formatNumber value="${pendingPayments}" pattern="#,##0.00"/> Pending</div>
            </div>

            <div class="stat-card info">
                <div class="stat-title">Total Users</div>
                <div class="stat-value">${totalUsers}</div>
                <div class="stat-description">${activeUsers} Active</div>
            </div>
        </div>

        <!-- Policy Statistics -->
        <div class="section">
            <h4> Policy Statistics</h4>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">Total Policies</div>
                    <div class="summary-value">${totalPolicies}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Active Policies</div>
                    <div class="summary-value">${activePolicies}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Inactive Policies</div>
                    <div class="summary-value">${totalPolicies - activePolicies}</div>
                </div>
            </div>
        </div>

        <!-- Claim Statistics -->
        <div class="section">
            <h4> Claim Statistics</h4>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">Total Claims</div>
                    <div class="summary-value">${totalClaims}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Pending Claims</div>
                    <div class="summary-value">${pendingClaims}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Approved Claims</div>
                    <div class="summary-value">${approvedClaims}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Rejected Claims</div>
                    <div class="summary-value">${rejectedClaims}</div>
                </div>
            </div>
        </div>

        <!-- Payment Statistics -->
        <div class="section">
            <h4> Payment Statistics</h4>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">Total Amount</div>
                    <div class="summary-value">$<fmt:formatNumber value="${totalPayments}" pattern="#,##0.00"/></div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Pending Amount</div>
                    <div class="summary-value">$<fmt:formatNumber value="${pendingPayments}" pattern="#,##0.00"/></div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Completed Amount</div>
                    <div class="summary-value">$<fmt:formatNumber value="${totalPayments - pendingPayments}" pattern="#,##0.00"/></div>
                </div>
            </div>
        </div>

        <!-- User Statistics -->
        <div class="section">
            <h4> User Statistics</h4>
            <div class="summary-grid">
                <div class="summary-item">
                    <div class="summary-label">Total Users</div>
                    <div class="summary-value">${totalUsers}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Active Users</div>
                    <div class="summary-value">${activeUsers}</div>
                </div>
                <div class="summary-item">
                    <div class="summary-label">Inactive Users</div>
                    <div class="summary-value">${totalUsers - activeUsers}</div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>