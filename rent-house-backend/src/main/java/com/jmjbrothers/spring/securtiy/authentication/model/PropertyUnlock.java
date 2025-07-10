package com.jmjbrothers.spring.securtiy.authentication.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;

@Data
@RequiredArgsConstructor
@Entity
@Table(name = "jahid_property_unlocks")
public class PropertyUnlock {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "property_id", nullable = false)
    private PropertyPost propertyPost;

    @Column(name = "credits_used", nullable = false, columnDefinition = "int default 5")
    private Integer creditsUsed = 5;

    @Column(name = "date_unlocked", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime dateUnlocked;

    @PrePersist
    public void prePersist() {
        if (dateUnlocked == null) {
            dateUnlocked = LocalDateTime.now();
        }
    }
}