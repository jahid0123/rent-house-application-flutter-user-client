package com.jmjbrothers.spring.securtiy.authentication.dto;

import com.jmjbrothers.spring.securtiy.authentication.constants.Category;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;

@Data
@RequiredArgsConstructor
public class UpdateMyPostedPropertyDto {

    private Long postId;
    private String contactNumber;
    private String contactPerson;
    private LocalDate availableFrom;
    @Enumerated(value = EnumType.STRING)
    private Category category;
    private String title;
    private String description;
    private Integer rentAmount;
    private String division;
    private String district;
    private String thana;
    private String section;
    private String roadNumber;
    private String houseNumber;
    private String address;
}
