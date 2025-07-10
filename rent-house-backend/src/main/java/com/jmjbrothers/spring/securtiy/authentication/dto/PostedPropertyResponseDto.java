package com.jmjbrothers.spring.securtiy.authentication.dto;

import com.jmjbrothers.spring.securtiy.authentication.constants.Category;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;

@Data
@RequiredArgsConstructor
public class PostedPropertyResponseDto {

    private Long postId;
    private Long userId;
    private String contactNumber;
    private String contactPerson;
    private String area;
    private LocalDate availableFrom;
    private Category category;
    private String title;
    private String description;
    private Boolean isAvailable;
    private Integer rentAmount;
    private LocalDate datePosted;
    private String division;
    private String district;
    private String thana;
    private String section;
    private String roadNumber;
    private String houseNumber;
    private String address;
}
