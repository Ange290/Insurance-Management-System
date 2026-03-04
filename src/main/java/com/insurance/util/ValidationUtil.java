package com.insurance.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String PHONE_REGEX = "^[0-9]{10}$";

    public static boolean isValidEmail(String email) {
        return email != null && Pattern.compile(EMAIL_REGEX).matcher(email).matches();
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && Pattern.compile(PHONE_REGEX).matcher(phone).matches();
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isPositiveNumber(double value) {
        return value > 0;
    }
}