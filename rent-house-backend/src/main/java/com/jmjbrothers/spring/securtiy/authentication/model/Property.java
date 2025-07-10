package com.jmjbrothers.spring.securtiy.authentication.model;

import com.jmjbrothers.spring.securtiy.authentication.constants.Category;
import jakarta.persistence.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@RequiredArgsConstructor
@Entity
@Table(name = "jahid_property")
public class Property {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    @Enumerated(value = EnumType.STRING)
    private Category category;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "CLOB")
    private String description;

    @Column(name = "is_available")
    private Boolean isAvailable = true;

    @Column(name = "rent_amount")
    private Integer rentAmount;

    @Column(name = "division", nullable = false)
    private String division;

    @Column(name = "district", nullable = false)
    private String district;

    @Column(name = "thana", nullable = false)
    private String thana;

    @Column(name = "section", nullable = false)
    private String section;

    @Column(name = "road_number", nullable = false)
    private String roadNumber;

    @Column(name = "house_number", nullable = false)
    private String houseNumber;

    @Column(columnDefinition = "CLOB")
    private String address;

    @ElementCollection
    private List<String> imageListPaths;

    @Column(name = "date_posted", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDate datePosted = LocalDate.now();

    @PrePersist
    public void prePersist() {
        if (datePosted == null) {
            datePosted = LocalDate.now();
        }
    }
}
