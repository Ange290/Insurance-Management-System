package com.insurance.model;

import java.sql.Timestamp;
import java.math.BigDecimal;

public class PolicyApplication {
    private int applicationId;
    private String applicationNumber;
    private int userId;
    private int policyTypeId;
    private BigDecimal requestedCoverage;
    private BigDecimal estimatedPremium;

    // Personal Information
    private String occupation;
    private BigDecimal annualIncome;

    // Additional Info
    private String healthDeclaration;
    private String previousInsurance;
    private String additionalInfo;

    // Status
    private String status;
    private Timestamp submittedDate;

    // Review Info
    private Integer reviewedBy;
    private Timestamp reviewedDate;
    private String rejectionReason;
    private String managerNotes;

    // Link to policy
    private Integer policyId;

    // Joined data
    private String userName;
    private String userEmail;
    private String policyTypeName;
    private String reviewerName;

    // Constructors
    public PolicyApplication() {}

    // Getters and Setters
    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
    }

    public String getApplicationNumber() {
        return applicationNumber;
    }

    public void setApplicationNumber(String applicationNumber) {
        this.applicationNumber = applicationNumber;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getPolicyTypeId() {
        return policyTypeId;
    }

    public void setPolicyTypeId(int policyTypeId) {
        this.policyTypeId = policyTypeId;
    }

    public BigDecimal getRequestedCoverage() {
        return requestedCoverage;
    }

    public void setRequestedCoverage(BigDecimal requestedCoverage) {
        this.requestedCoverage = requestedCoverage;
    }

    public BigDecimal getEstimatedPremium() {
        return estimatedPremium;
    }

    public void setEstimatedPremium(BigDecimal estimatedPremium) {
        this.estimatedPremium = estimatedPremium;
    }

    public String getOccupation() {
        return occupation;
    }

    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }

    public BigDecimal getAnnualIncome() {
        return annualIncome;
    }

    public void setAnnualIncome(BigDecimal annualIncome) {
        this.annualIncome = annualIncome;
    }

    public String getHealthDeclaration() {
        return healthDeclaration;
    }

    public void setHealthDeclaration(String healthDeclaration) {
        this.healthDeclaration = healthDeclaration;
    }

    public String getPreviousInsurance() {
        return previousInsurance;
    }

    public void setPreviousInsurance(String previousInsurance) {
        this.previousInsurance = previousInsurance;
    }

    public String getAdditionalInfo() {
        return additionalInfo;
    }

    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getSubmittedDate() {
        return submittedDate;
    }

    public void setSubmittedDate(Timestamp submittedDate) {
        this.submittedDate = submittedDate;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public Timestamp getReviewedDate() {
        return reviewedDate;
    }

    public void setReviewedDate(Timestamp reviewedDate) {
        this.reviewedDate = reviewedDate;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public String getManagerNotes() {
        return managerNotes;
    }

    public void setManagerNotes(String managerNotes) {
        this.managerNotes = managerNotes;
    }

    public Integer getPolicyId() {
        return policyId;
    }

    public void setPolicyId(Integer policyId) {
        this.policyId = policyId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getPolicyTypeName() {
        return policyTypeName;
    }

    public void setPolicyTypeName(String policyTypeName) {
        this.policyTypeName = policyTypeName;
    }

    public String getReviewerName() {
        return reviewerName;
    }

    public void setReviewerName(String reviewerName) {
        this.reviewerName = reviewerName;
    }
}