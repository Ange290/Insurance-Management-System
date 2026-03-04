<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Apply for Insurance - Insurance Management System</title>
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
            max-width: 900px;
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
            margin-bottom: 10px;
            font-weight: 600;
            font-size: 28px;
        }

        .subtitle {
            color: #6b7280;
            margin-bottom: 30px;
        }

        .section-title {
            color: #84cc16;
            font-size: 18px;
            font-weight: 600;
            margin-top: 30px;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #84cc16;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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

        .info-box {
            background: #f0fdf4;
            border-left: 4px solid #84cc16;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }

        .info-box p {
            color: #166534;
            font-size: 14px;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 14px 30px;
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

        .premium-calculator {
            background: #fef3c7;
            border: 2px solid #f59e0b;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
        }

        .premium-calculator p {
            color: #92400e;
            font-size: 14px;
            margin-bottom: 5px;
        }

        .premium-display {
            font-size: 24px;
            font-weight: 700;
            color: #f59e0b;
        }
    </style>
    <script>
        // Simple premium calculator
        function calculatePremium() {
            const coverage = parseFloat(document.getElementById('requestedCoverage').value) || 0;
            const policyType = document.getElementById('policyTypeId').value;

            let rate = 0.05; // Default 5%

            // Different rates for different policy types (you can adjust)
            if (policyType == "1") rate = 0.04; // Life - 4%
            if (policyType == "2") rate = 0.06; // Health - 6%
            if (policyType == "3") rate = 0.05; // Auto - 5%
            if (policyType == "4") rate = 0.03; // Home - 3%

            const annualPremium = coverage * rate;
            const monthlyPremium = annualPremium / 12;

            document.getElementById('estimatedPremium').value = annualPremium.toFixed(2);
            document.getElementById('premiumDisplay').innerHTML =
                'Estimated Annual Premium: <span class="premium-display">$' + annualPremium.toFixed(2) + '</span><br>' +
                'Monthly: <strong>$' + monthlyPremium.toFixed(2) + '</strong>';
        }
    </script>
</head>
<body>
    <div class="navbar">
        <h2> Insurance Management System</h2>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/applications">My Applications</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="form-container">
            <h3> Apply for Insurance</h3>
            <p class="subtitle">Complete this form to apply for an insurance policy. Our team will review your application within 2-3 business days.</p>

            <div class="info-box">
                <p><strong>Note:</strong> All fields marked with <span class="required">*</span> are required. Please provide accurate information for faster processing.</p>
            </div>

            <form action="${pageContext.request.contextPath}/${sessionScope.userRole.toLowerCase()}/application" method="post">
                <input type="hidden" name="action" value="submit">

                <!-- Section 1: Policy Details -->
                <div class="section-title">Policy Information</div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="policyTypeId">Insurance Type <span class="required">*</span></label>
                        <select id="policyTypeId" name="policyTypeId" required onchange="calculatePremium()">
                            <option value="">Select Insurance Type</option>
                            <c:forEach var="type" items="${policyTypes}">
                                <option value="${type.policyTypeId}">${type.typeName} - ${type.description}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="requestedCoverage">Coverage Amount <span class="required">*</span></label>
                        <input type="number" id="requestedCoverage" name="requestedCoverage"
                               step="1000" min="10000" placeholder="e.g., 100000" required onchange="calculatePremium()">
                    </div>
                </div>

                <div class="form-group">
                    <input type="hidden" id="estimatedPremium" name="estimatedPremium" value="0">
                    <div class="premium-calculator">
                        <p><strong>Premium Estimate:</strong></p>
                        <div id="premiumDisplay">Select coverage amount to calculate premium</div>
                    </div>
                </div>

                <!-- Section 2: Personal Information -->
                <div class="section-title">Personal Information</div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="occupation">Occupation <span class="required">*</span></label>
                        <input type="text" id="occupation" name="occupation" placeholder="Your current occupation" required>
                    </div>

                    <div class="form-group">
                        <label for="annualIncome">Annual Income <span class="required">*</span></label>
                        <input type="number" id="annualIncome" name="annualIncome"
                               step="1000" placeholder="e.g., 50000" required>
                    </div>
                </div>

                <!-- Section 3: Health & Insurance History -->
                <div class="section-title">Health & Insurance History</div>

                <div class="form-group">
                    <label for="healthDeclaration">Health Declaration <span class="required">*</span></label>
                    <textarea id="healthDeclaration" name="healthDeclaration"
                              placeholder="Please describe your current health status, any pre-existing conditions, medications, etc." required></textarea>
                </div>

                <div class="form-group">
                    <label for="previousInsurance">Previous Insurance</label>
                    <textarea id="previousInsurance" name="previousInsurance"
                              placeholder="List any previous insurance policies you've held (optional)"></textarea>
                </div>

                <!-- Section 4: Additional Information -->
                <div class="section-title">Additional Information</div>

                <div class="form-group">
                    <label for="additionalInfo">Additional Comments</label>
                    <textarea id="additionalInfo" name="additionalInfo"
                              placeholder="Any other information you'd like to provide (optional)"></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Submit Application</button>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>