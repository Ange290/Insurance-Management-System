<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Review Application - Insurance Management System</title>
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
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .layout {
            display: grid;
            grid-template-columns: 1fr 450px;
            gap: 20px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h3 {
            color: #1f2937;
            font-weight: 600;
            font-size: 22px;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e5e7eb;
        }

        .section-title {
            color: #84cc16;
            font-size: 16px;
            font-weight: 600;
            margin-top: 25px;
            margin-bottom: 15px;
        }

        .detail-grid {
            display: grid;
            grid-template-columns: 150px 1fr;
            gap: 12px 20px;
            margin-bottom: 15px;
        }

        .label {
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }

        .value {
            color: #6b7280;
            font-size: 14px;
        }

        .value.highlight {
            font-size: 18px;
            font-weight: 700;
            color: #84cc16;
        }

        .text-block {
            background: #f9fafb;
            padding: 12px;
            border-radius: 6px;
            border-left: 3px solid #84cc16;
            margin-top: 8px;
            color: #374151;
            font-size: 14px;
            line-height: 1.5;
        }

        .review-panel {
            position: sticky;
            top: 20px;
        }

        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .tab {
            flex: 1;
            padding: 12px;
            background: #f3f4f6;
            border: none;
            border-radius: 8px;
            font-family: 'Outfit', sans-serif;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .tab.active {
            background: linear-gradient(135deg, #84cc16 0%, #65a30d 100%);
            color: white;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #374151;
            font-weight: 500;
            font-size: 14px;
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
            min-height: 100px;
        }

        .required {
            color: #ef4444;
        }

        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .btn-success {
            background: #22c55e;
            color: white;
        }

        .btn-success:hover {
            background: #16a34a;
            transform: translateY(-2px);
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
            transform: translateY(-2px);
        }

        .btn-warning {
            background: #f59e0b;
            color: white;
        }

        .btn-warning:hover {
            background: #d97706;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .info-box {
            background: #dbeafe;
            border: 2px solid #3b82f6;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info-box p {
            color: #1e40af;
            font-size: 13px;
            line-height: 1.5;
        }

        .calculation-box {
            background: #fef3c7;
            border: 2px solid #f59e0b;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }

        .calculation-box .calc-label {
            font-size: 12px;
            color: #92400e;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .calculation-box .calc-value {
            font-size: 24px;
            font-weight: 700;
            color: #f59e0b;
        }
    </style>
    <script>
        function showTab(tabName) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            document.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });

            // Show selected tab
            document.getElementById(tabName).classList.add('active');
            document.querySelector(`[onclick="showTab('${tabName}')"]`).classList.add('active');
        }

        function calculateMonthly() {
            const annual = parseFloat(document.getElementById('finalPremium').value) || 0;
            const monthly = annual / 12;
            document.getElementById('monthlyDisplay').textContent = '$' + monthly.toFixed(2);
        }
    </script>
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
        <div class="layout">
            <!-- Left: Application Details -->
            <div class="card">
                <h3>Application #${application.applicationNumber}</h3>

                <!-- Applicant Info -->
                <div class="section-title">Applicant Information</div>
                <div class="detail-grid">
                    <div class="label">Name:</div>
                    <div class="value">${application.userName}</div>

                    <div class="label">Email:</div>
                    <div class="value">${application.userEmail}</div>

                    <div class="label">Submitted:</div>
                    <div class="value">${application.submittedDate}</div>
                </div>

                <!-- Policy Details -->
                <div class="section-title">Requested Policy</div>
                <div class="detail-grid">
                    <div class="label">Type:</div>
                    <div class="value">${application.policyTypeName}</div>

                    <div class="label">Coverage:</div>
                    <div class="value highlight">$${application.requestedCoverage}</div>

                    <div class="label">Est. Premium:</div>
                    <div class="value highlight">$${application.estimatedPremium}/year</div>
                </div>

                <!-- Personal Info -->
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

                <!-- Additional Info -->
                <c:if test="${not empty application.additionalInfo}">
                    <div class="section-title">Additional Information</div>
                    <div class="text-block">
                        ${application.additionalInfo}
                    </div>
                </c:if>
            </div>

            <!-- Right: Review Actions -->
            <div class="review-panel">
                <div class="card">
                    <h3> Review Actions</h3>

                    <div class="tabs">
                        <button class="tab active" onclick="showTab('approveTab')">Approve</button>
                        <button class="tab" onclick="showTab('rejectTab')">Reject</button>
                        <button class="tab" onclick="showTab('reviewTab')">Under Review</button>
                    </div>

                    <!-- Approve & Create Policy Tab -->
                    <div id="approveTab" class="tab-content active">
                        <div class="info-box">
                            <p><strong>Create Policy:</strong> Approve this application and create an active insurance policy for the customer.</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application" method="post">
                            <input type="hidden" name="action" value="createPolicy">
                            <input type="hidden" name="applicationId" value="${application.applicationId}">

                            <div class="form-group">
                                <label for="finalPremium">Final Premium Amount (Annual) <span class="required">*</span></label>
                                <input type="number" id="finalPremium" name="finalPremium" step="0.01"
                                       value="${application.estimatedPremium}" required onchange="calculateMonthly()">
                                <div class="calculation-box" style="margin-top: 10px;">
                                    <div class="calc-label">Monthly Premium</div>
                                    <div class="calc-value" id="monthlyDisplay">$${application.estimatedPremium / 12}</div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="startDate">Policy Start Date <span class="required">*</span></label>
                                <input type="date" id="startDate" name="startDate" required>
                            </div>

                            <div class="form-group">
                                <label for="endDate">Policy End Date <span class="required">*</span></label>
                                <input type="date" id="endDate" name="endDate" required>
                            </div>

                            <button type="submit" class="btn btn-success">✓ Approve & Create Policy</button>
                        </form>
                    </div>

                    <!-- Reject Tab -->
                    <div id="rejectTab" class="tab-content">
                        <div class="info-box" style="background: #fee2e2; border-color: #ef4444;">
                            <p style="color: #991b1b;"><strong>Reject Application:</strong> The applicant will be notified of the rejection reason.</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application" method="post">
                            <input type="hidden" name="action" value="review">
                            <input type="hidden" name="applicationId" value="${application.applicationId}">
                            <input type="hidden" name="status" value="Rejected">

                            <div class="form-group">
                                <label for="rejectionReason">Rejection Reason <span class="required">*</span></label>
                                <textarea id="rejectionReason" name="rejectionReason" required
                                          placeholder="Please provide a detailed reason for rejection..."></textarea>
                            </div>

                            <div class="form-group">
                                <label for="managerNotes">Internal Notes (Optional)</label>
                                <textarea id="managerNotes" name="managerNotes"
                                          placeholder="Internal notes (not visible to customer)..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-danger">✗ Reject Application</button>
                        </form>
                    </div>

                    <!-- Under Review Tab -->
                    <div id="reviewTab" class="tab-content">
                        <div class="info-box" style="background: #fef3c7; border-color: #f59e0b;">
                            <p style="color: #92400e;"><strong>Mark as Under Review:</strong> Use this if you need more time or information before making a decision.</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application" method="post">
                            <input type="hidden" name="action" value="review">
                            <input type="hidden" name="applicationId" value="${application.applicationId}">
                            <input type="hidden" name="status" value="Under Review">

                            <div class="form-group">
                                <label for="managerNotes2">Review Notes</label>
                                <textarea id="managerNotes2" name="managerNotes"
                                          placeholder="Add notes about what needs to be reviewed..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-warning">⚠ Mark Under Review</button>
                        </form>
                    </div>

                    <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/applications" class="btn btn-secondary">Cancel</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Set default dates (start today, end 1 year later)
        const today = new Date();
        const oneYearLater = new Date(today);
        oneYearLater.setFullYear(oneYearLater.getFullYear() + 1);

        document.getElementById('startDate').valueAsDate = today;
        document.getElementById('endDate').valueAsDate = oneYearLater;

        // Calculate initial monthly premium
        calculateMonthly();
    </script>
</body>
</html>