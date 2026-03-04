<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payments - Insurance Management System</title>
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

        .badge.completed {
            background: #dcfce7;
            color: #166534;
        }

        .badge.pending {
            background: #fef3c7;
            color: #92400e;
        }

        .badge.failed {
            background: #fee2e2;
            color: #991b1b;
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        .actions a {
            color: #84cc16;
            text-decoration: none;
            font-weight: 500;
        }

        .actions a:hover {
            text-decoration: underline;
        }

        .error, .success {
            padding: 15px;
            border-radius: 5px;
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
            <h3> Payments</h3>
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/payment?action=new" class="btn">+ Add New Payment</a>
        </div>

        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success">${success}</div>
        </c:if>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Payment ID</th>
                        <th>Policy Number</th>
                        <th>Customer</th>
                        <th>Amount</th>
                        <th>Payment Date</th>
                        <th>Payment Method</th>
                        <th>Transaction ID</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="payment" items="${payments}">
                        <tr>
                            <td>${payment.paymentId}</td>
                            <td>${payment.policyNumber}</td>
                            <td>${payment.userName}</td>
                            <td>$${payment.amount}</td>
                            <td>${payment.paymentDate}</td>
                            <td>${payment.paymentMethod}</td>
                            <td>${payment.transactionId}</td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/payment?action=view&id=${payment.paymentId}">View</a>
                                    <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
                                        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/payment?action=edit&id=${payment.paymentId}">Edit</a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>