package com.jmjbrothers.spring.securtiy.authentication.dto;


import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class PasswordChangeRequestDto {

    private Long userId;
    private String currentPassword;
    private String newPassword;
}
