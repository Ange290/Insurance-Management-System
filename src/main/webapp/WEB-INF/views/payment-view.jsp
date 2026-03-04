<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Details - Insurance Management System</title>
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
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/payments">Back to Payments</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <h3> Payment Details</h3>

            <div class="detail-grid">
                <div class="label">Payment ID:</div>
                <div class="value">${payment.paymentId}</div>

                <div class="label">Policy Number:</div>
                <div class="value">${payment.policyNumber}</div>

                <div class="label">Customer:</div>
                <div class="value">${payment.userName}</div>

                <div class="label">Amount:</div>
                <div class="value amount">$${payment.amount}</div>

                <div class="label">Payment Date:</div>
                <div class="value">${payment.paymentDate}</div>

                <div class="label">Payment Method:</div>
                <div class="value">${payment.paymentMethod}</div>

                <div class="label">Transaction ID:</div>
                <div class="value">${payment.transactionId}</div>

                <div class="label">Created At:</div>
                <div class="value">${payment.createdAt}</div>
            </div>

            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/payments" class="btn">← Back to Payments</a>
        </div>
    </div>
</body>
</html>