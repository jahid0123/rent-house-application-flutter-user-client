package com.jmjbrothers.spring.securtiy.authentication.dto;


import com.jmjbrothers.spring.securtiy.authentication.constants.Category;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.Data;

@Data
public class PropertyDto {

    private Long userId;
    @Enumerated(value = EnumType.STRING)
    private Category category;
    private String title;
    private String description;
    private String address;
    private Integer rentAmount;
}
