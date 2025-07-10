package com.jmjbrothers.spring.securtiy.authentication.model;

import com.jmjbrothers.spring.securtiy.authentication.constants.Role;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;


@Data
@RequiredArgsConstructor
@Entity
@Table(name = "jahid_user")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "email", unique = true, nullable = false)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "role")
    @Enumerated(value = EnumType.STRING)
    private Role role;

    @Column(name = "phone")
    private String phone;

    @Column(name = "balance_credits")
    private Integer balanceCredits = 0;

    @Column(name = "created_at")
    private LocalDateTime createdAt;


    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

}