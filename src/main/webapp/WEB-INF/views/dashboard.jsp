<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Insurance Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

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

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .role-badge {
            display: inline-block;
            padding: 5px 15px;
            background: rgba(255,255,255,0.3);
            color: white;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }

        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: 1px solid white;
            border-radius: 5px;
            text-decoration: none;
            transition: all 0.3s;
            font-weight: 500;
        }

        .logout-btn:hover {
            background: white;
            color: #84cc16;
            transform: translateY(-2px);
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .welcome {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .welcome h3 {
            color: #1f2937;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .welcome p {
            color: #6b7280;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .menu-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: all 0.3s;
            text-decoration: none;
            color: #333;
            border-top: 4px solid #84cc16;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(132, 204, 22, 0.3);
        }

        .menu-card h4 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #84cc16;
            font-weight: 600;
        }

        .menu-card p {
            color: #6b7280;
            font-size: 14px;
        }

        .highlight {
            border-top-color: #f59e0b;
        }

        .highlight h4 {
            color: #f59e0b;
        }
    </style>
</head>
<body>
<div class="navbar">
    <h2>Insurance Management System</h2>
    <div class="user-info">
        <span>Welcome, ${sessionScope.userName}!</span>
        <span class="role-badge">${sessionScope.userRole}</span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
</div>

<div class="container">
    <div class="welcome">
        <h3>Dashboard</h3>
        <p>
            <c:choose>
                <c:when test="${sessionScope.userRole == 'Customer'}">
                    Manage your insurance policies, file claims, and track applications.
                </c:when>
                <c:otherwise>
                    Manage insurance operations, review applications, and oversee the system.
                </c:otherwise>
            </c:choose>
        </p>
    </div>

    <div class="menu-grid">
        <c:if test="${sessionScope.userRole == 'Customer'}">
            <a href="${pageContext.request.contextPath}/customer/application?action=new" class="menu-card highlight">
                <h4>Apply for Insurance</h4>
                <p>Submit a new insurance application</p>
            </a>
        </c:if>

        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/applications" class="menu-card">
            <h4>Applications</h4>
            <p>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'Customer'}">Track your applications</c:when>
                    <c:otherwise>Review insurance applications</c:otherwise>
                </c:choose>
            </p>
        </a>

        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/policies" class="menu-card">
            <h4>Policies</h4>
            <p>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'Customer'}">View your active policies</c:when>
                    <c:otherwise>Manage all policies</c:otherwise>
                </c:choose>
            </p>
        </a>

        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/claims" class="menu-card">
            <h4>Claims</h4>
            <p>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'Customer'}">File and track claims</c:when>
                    <c:otherwise>Process insurance claims</c:otherwise>
                </c:choose>
            </p>
        </a>

        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/payments" class="menu-card">
            <h4>Payments</h4>
            <p>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'Customer'}">View payment history</c:when>
                    <c:otherwise>Manage payments</c:otherwise>
                </c:choose>
            </p>
        </a>

        <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/users" class="menu-card">
                <h4>Users</h4>
                <p>Manage system users</p>
            </a>
        </c:if>

        <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/reports" class="menu-card">
                <h4>Reports</h4>
                <p>View system reports</p>
            </a>
        </c:if>
    </div>
</div>
</body>
</html>