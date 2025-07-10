package com.jmjbrothers.spring.securtiy.authentication.repository;

import com.jmjbrothers.spring.securtiy.authentication.model.PropertyPost;
import com.jmjbrothers.spring.securtiy.authentication.model.PropertyUnlock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PropertyUnlockRepository extends JpaRepository<PropertyUnlock, Long> {

    List<PropertyUnlock> findAllByUserId(Long userId);

}
