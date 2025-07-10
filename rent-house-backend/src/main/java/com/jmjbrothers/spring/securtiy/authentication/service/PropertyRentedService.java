package com.jmjbrothers.spring.securtiy.authentication.service;

import com.jmjbrothers.spring.securtiy.authentication.model.PropertyPost;
import com.jmjbrothers.spring.securtiy.authentication.model.PropertyRented;
import com.jmjbrothers.spring.securtiy.authentication.repository.PropertyPostRepository;
import com.jmjbrothers.spring.securtiy.authentication.repository.PropertyRentedRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

@Service
public class PropertyRentedService {

    private final PropertyRentedRepository propertyRentedRepository;
    private final PropertyPostRepository propertyPostRepository;


    public PropertyRentedService(PropertyRentedRepository propertyRentedRepository, PropertyPostRepository propertyPostRepository){
        this.propertyRentedRepository = propertyRentedRepository;
        this.propertyPostRepository = propertyPostRepository;
    }


    @Transactional
    public PropertyRented rentedProperty(Long id) {
        PropertyPost propertyPost = propertyPostRepository.findById(id).orElseThrow(
                ()-> new RuntimeException("Property not found with this id: "+id)
        );
        PropertyRented propertyRented = new PropertyRented();
        propertyRented.setPropertyPost(propertyPost);
        return propertyRentedRepository.save(propertyRented);
    }
}
