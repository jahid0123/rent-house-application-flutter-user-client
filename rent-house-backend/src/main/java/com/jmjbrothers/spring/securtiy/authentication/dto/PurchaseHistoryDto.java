package com.jmjbrothers.spring.securtiy.authentication.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@RequiredArgsConstructor
public class PurchaseHistoryDto {

    private String packageName;
    private Integer creditsPurchased;
    private BigDecimal amountPaid;
    private LocalDateTime datePurchased;



}
