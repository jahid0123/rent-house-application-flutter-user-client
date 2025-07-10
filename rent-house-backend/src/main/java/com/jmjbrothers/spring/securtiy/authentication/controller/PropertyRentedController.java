package com.jmjbrothers.spring.securtiy.authentication.controller;


import com.jmjbrothers.spring.securtiy.authentication.model.PropertyRented;
import com.jmjbrothers.spring.securtiy.authentication.service.PropertyRentedService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping(value = "/api/user")
public class PropertyRentedController {

    private final PropertyRentedService propertyRentedService;

    public PropertyRentedController(PropertyRentedService propertyRentedService) {
        this.propertyRentedService = propertyRentedService;
    }

    @PostMapping("/rented")
    public ResponseEntity<?> rentedProperty(@RequestParam Long id){

        PropertyRented rented = propertyRentedService.rentedProperty(id);
        return ResponseEntity.ok(rented);
    }

}
