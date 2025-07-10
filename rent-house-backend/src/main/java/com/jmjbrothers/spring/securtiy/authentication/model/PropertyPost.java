package com.jmjbrothers.spring.securtiy.authentication.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "jahid_property_post")
public class PropertyPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "property_id", nullable = false)
    private Property property;

    @Column(name = "contact_number", nullable = false)
    private String contactNumber;

    @Column(name = "contact_person", nullable = false)
    private String contactPerson;

    @Column(name = "available_from", nullable = false)
    private LocalDate availableFrom;

    @Column(name = "credits_used", nullable = false, columnDefinition = "int default 10")
    private Integer creditsUsed = 10;

    @Column(name = "date_posted", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDate datePosted;

    @PrePersist
    public void prePersist() {
        if (datePosted == null) {
            datePosted = LocalDate.now();
        }
    }
}

