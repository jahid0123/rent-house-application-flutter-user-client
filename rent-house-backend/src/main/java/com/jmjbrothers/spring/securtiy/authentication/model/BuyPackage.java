package com.jmjbrothers.spring.securtiy.authentication.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@RequiredArgsConstructor
@Entity
@Table(name = "jahid_buy_package")
public class BuyPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "package_id", nullable = false)
    private CreditPackage creditPackage;

    @Column(name = "credits_purchased", nullable = false)
    private Integer creditsPurchased;

    @Column(name = "amount_paid", precision = 10, scale = 2, nullable = false)
    private BigDecimal amountPaid;

    @Column(name = "date_purchased", nullable = false)
    private LocalDateTime datePurchased;

    @PrePersist
    public void prePersist() {
        if (datePurchased == null) {
            datePurchased = LocalDateTime.now();
        }
    }
}

