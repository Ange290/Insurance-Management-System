package com.insurance.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Policy {
    private int policyId;
    private int userId;
    private int policyTypeId;
    private String policyNumber;
    private double coverageAmount;
    private double premium;
    private Date startDate;
    private Date endDate;
    private String status;
    private Timestamp createdAt;
    private String userName;
    private String policyTypeName;

    public Policy() {}

    public int getPolicyId() {
        return policyId;
    }

    public void setPolicyId(int policyId) {
        this.policyId = policyId;
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

    public String getPolicyNumber() {
        return policyNumber;
    }

    public void setPolicyNumber(String policyNumber) {
        this.policyNumber = policyNumber;
    }

    public double getCoverageAmount() {
        return coverageAmount;
    }

    public void setCoverageAmount(double coverageAmount) {
        this.coverageAmount = coverageAmount;
    }

    public double getPremium() {
        return premium;
    }

    public void setPremium(double premium) {
        this.premium = premium;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPolicyTypeName() {
        return policyTypeName;
    }

    public void setPolicyTypeName(String policyTypeName) {
        this.policyTypeName = policyTypeName;
    }
}