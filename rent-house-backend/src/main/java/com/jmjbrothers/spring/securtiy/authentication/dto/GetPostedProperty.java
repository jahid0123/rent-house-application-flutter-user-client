package com.jmjbrothers.spring.securtiy.authentication.dto;

import com.jmjbrothers.spring.securtiy.authentication.constants.Category;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@RequiredArgsConstructor
public class GetPostedProperty {

    private Long id;
    private Category category;
    private String title;
    private String description;
    private Boolean isAvailable;
    private Integer rentAmount;
    private LocalDate datePosted;
    private LocalDate availableFrom;
    private String district;
    private String division;
    private String thana;
    private String section;
    private List<String> imageUrls;
}
