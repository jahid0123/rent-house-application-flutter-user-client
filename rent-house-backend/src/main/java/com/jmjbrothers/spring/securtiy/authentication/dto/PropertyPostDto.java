package com.jmjbrothers.spring.securtiy.authentication.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.jmjbrothers.spring.securtiy.authentication.constants.Category;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;

@Data
@RequiredArgsConstructor
public class PropertyPostDto {

    private Long userID;
    @Enumerated(value = EnumType.STRING)
    private Category category;
    private String title;
    private String description;
    private String address;
    private String contactPerson;
    private String contactNumber;
    private String area;
    @JsonFormat(pattern = "yyyy-MM-dd") // ADD THIS
    private LocalDate availableFrom;
    private Integer rentAmount;
    private String division;
    private String district;
    private String thana;
    private String section;
    private String roadNumber;
    private String houseNumber;



}
