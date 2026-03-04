<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Application Details - Insurance Management System</title>
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
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .card {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e5e7eb;
        }

        .header-section h3 {
            color: #1f2937;
            font-weight: 600;
            font-size: 24px;
        }

        .application-number {
            color: #6b7280;
            font-size: 14px;
            margin-top: 5px;
        }

        .badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
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

        .section-title {
            color: #84cc16;
            font-size: 18px;
            font-weight: 600;
            margin-top: 30px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #84cc16;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 15px 30px;
            margin-bottom: 15px;
        }

        .label {
            font-weight: 600;
            color: #374151;
        }

        .value {
            color: #6b7280;
        }

        .value.large {
            font-size: 20px;
            font-weight: 700;
            color: #84cc16;
        }

        .text-block {
            background: #f9fafb;
            padding: 15px;
            border-radius: 8px;
            border-left: 3px solid #84cc16;
            margin-top: 10px;
            color: #374151;
            line-height: 1.6;
        }

        .review-box {
            background: #fef3c7;
            border: 2px solid #f59e0b;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
        }

        .review-box.rejected {
            background: #fee2e2;
            border-color: #ef4444;
        }

        .review-box h4 {
            color: #92400e;
            margin-bottom: 10px;
        }

        .review-box.rejected h4 {
            color: #991b1b;
        }

        .actions {
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
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
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

        .btn-success {
            background: #22c55e;
            color: white;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .timeline {
            margin-top: 20px;
        }

        .timeline-item {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
        }

        .timeline-dot {
            width: 12px;
            height: 12px;
            background: #84cc16;
            border-radius: 50%;
            margin-top: 5px;
        }

        .timeline-content {
            flex: 1;
        }

        .timeline-date {
            color: #6b7280;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h2> Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/applications">Back to Applications</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="card">
            <div class="header-section">
                <div>
                    <h3>Application Details</h3>
                    <div class="application-number">Application #${application.applicationNumber}</div>
                </div>
                <span class="badge ${application.status == 'Pending' ? 'pending' :
                                    application.status == 'Under Review' ? 'under-review' :
                                    application.status == 'Approved' ? 'approved' : 'rejected'}">
                    ${application.status}
                </span>
            </div>

            <!-- Applicant Information -->
            <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
                <div class="section-title">Applicant Information</div>
                <div class="detail-grid">
                    <div class="label">Name:</div>
                    <div class="value">${application.userName}</div>

                    <div class="label">Email:</div>
                    <div class="value">${application.userEmail}</div>
                </div>
            </c:if>

            <!-- Policy Details -->
            <div class="section-title">Requested Policy</div>
            <div class="detail-grid">
                <div class="label">Insurance Type:</div>
                <div class="value">${application.policyTypeName}</div>

                <div class="label">Coverage Amount:</div>
                <div class="value large">$${application.requestedCoverage}</div>

                <div class="label">Estimated Premium:</div>
                <div class="value large">$${application.estimatedPremium} /year</div>

                <div class="label">Submitted Date:</div>
                <div class="value">${application.submittedDate}</div>
            </div>

            <!-- Personal Information -->
            <div class="section-title">Personal Information</div>
            <div class="detail-grid">
                <div class="label">Occupation:</div>
                <div class="value">${application.occupation}</div>

                <div class="label">Annual Income:</div>
                <div class="value">$${application.annualIncome}</div>
            </div>

            <!-- Health Declaration -->
            <div class="section-title">Health Declaration</div>
            <div class="text-block">
                ${application.healthDeclaration}
            </div>

            <!-- Previous Insurance -->
            <c:if test="${not empty application.previousInsurance}">
                <div class="section-title">Previous Insurance</div>
                <div class="text-block">
                    ${application.previousInsurance}
                </div>
            </c:if>

            <!-- Additional Information -->
            <c:if test="${not empty application.additionalInfo}">
                <div class="section-title">Additional Information</div>
                <div class="text-block">
                    ${application.additionalInfo}
                </div>
            </c:if>

            <!-- Review Information -->
            <c:if test="${application.status == 'Approved' || application.status == 'Rejected' || application.status == 'Under Review'}">
                <div class="section-title">Review Information</div>

                <c:if test="${not empty application.reviewerName}">
                    <div class="detail-grid">
                        <div class="label">Reviewed By:</div>
                        <div class="value">${application.reviewerName}</div>

                        <div class="label">Reviewed Date:</div>
                        <div class="value">${application.reviewedDate}</div>
                    </div>
                </c:if>

                <c:if test="${not empty application.managerNotes}">
                    <div class="review-box">
                        <h4>Manager Notes:</h4>
                        <p>${application.managerNotes}</p>
                    </div>
                </c:if>

                <c:if test="${application.status == 'Rejected' && not empty application.rejectionReason}">
                    <div class="review-box rejected">
                        <h4>Rejection Reason:</h4>
                        <p>${application.rejectionReason}</p>
                    </div>
                </c:if>

                <c:if test="${application.status == 'Approved' && application.policyId != null}">
                    <div class="review-box" style="background: #dcfce7; border-color: #22c55e;">
                        <h4 style="color: #166534;">✓ Policy Created Successfully</h4>
                        <p style="color: #166534;">A policy has been created from this application.</p>
                        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/policies"
                           style="color: #166534; font-weight: 600; text-decoration: underline;">View Policies →</a>
                    </div>
                </c:if>
            </c:if>

            <!-- Actions -->
            <div class="actions">
                <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/applications" class="btn btn-secondary">← Back to Applications</a>

                <c:if test="${sessionScope.userRole == 'Admin' || sessionScope.userRole == 'Manager'}">
                    <c:if test="${application.status == 'Pending' || application.status == 'Under Review'}">
                        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application?action=review&id=${application.applicationId}" class="btn btn-primary">Review Application</a>
                    </c:if>

                    <c:if test="${application.status == 'Approved' && application.policyId == null}">
                        <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application?action=review&id=${application.applicationId}" class="btn btn-success">Create Policy</a>
                    </c:if>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>