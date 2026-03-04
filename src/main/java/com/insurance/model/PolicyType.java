package com.insurance.model;

public class PolicyType {
    private int policyTypeId;
    private String typeName;
    private String description;
    private double baseRate;

    public PolicyType() {}

    public int getPolicyTypeId() {
        return policyTypeId;
    }

    public void setPolicyTypeId(int policyTypeId) {
        this.policyTypeId = policyTypeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBaseRate() {
        return baseRate;
    }

    public void setBaseRate(double baseRate) {
        this.baseRate = baseRate;
    }
}