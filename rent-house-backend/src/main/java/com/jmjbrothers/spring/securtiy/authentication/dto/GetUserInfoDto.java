package com.jmjbrothers.spring.securtiy.authentication.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class GetUserInfoDto {

    private Long userid;
}
