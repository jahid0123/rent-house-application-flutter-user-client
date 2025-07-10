package com.jmjbrothers.spring.securtiy.authentication.controller;

import com.jmjbrothers.spring.securtiy.authentication.dto.GetPostedProperty;
import com.jmjbrothers.spring.securtiy.authentication.dto.MyPostPropertyResponseDto;
import com.jmjbrothers.spring.securtiy.authentication.dto.PostedPropertyResponseDto;
import com.jmjbrothers.spring.securtiy.authentication.dto.PropertyPostUpdateDto;
import com.jmjbrothers.spring.securtiy.authentication.model.CreditPackage;
import com.jmjbrothers.spring.securtiy.authentication.model.PropertyPost;
import com.jmjbrothers.spring.securtiy.authentication.model.User;
import com.jmjbrothers.spring.securtiy.authentication.service.CreditPackageService;
import com.jmjbrothers.spring.securtiy.authentication.service.PropertyPostService;
import com.jmjbrothers.spring.securtiy.authentication.service.UserInfoDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/admin")
public class AdminController {


    private final UserInfoDetailsService userInfoDetailsService;
    private final CreditPackageService packageService;
    private final PropertyPostService propertyPostService;
    private final CreditPackageService creditPackageService;


    //Get all user access control by Admin
    @GetMapping("/alluser")
    public List<User> getAllUser() {
        return userInfoDetailsService.getAllUser();
    }

    //Delete user by id access control by admin
    @DeleteMapping("/delete/user")
    public ResponseEntity<?> deleteUserById(@RequestParam Long id) {
        String deleteUser = userInfoDetailsService.deleteUserById(id);
        if (deleteUser!=null){
            return new ResponseEntity<>(HttpStatus.OK);
        }else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    //Credit Package Creation by the Admin
    @PostMapping("/add/package")
    public ResponseEntity<?> addCreditPackage(@RequestBody CreditPackage cPackage) {
        CreditPackage creditPackage = packageService.addCreditPackage(cPackage);
        return new ResponseEntity<>(creditPackage, HttpStatus.CREATED);
    }

    @PutMapping("/edit/package")
    public ResponseEntity<?> updatePackage(@RequestBody CreditPackage editBody){

        CreditPackage creditPackage = creditPackageService.updatePackage(editBody);

        return new ResponseEntity<>(creditPackage, HttpStatus.OK);
    }

    @DeleteMapping("/delete/package")
    public ResponseEntity<?> deletePackage(@RequestParam Long id){

        String deletePackage = creditPackageService.deletePackageById(id);

        return new ResponseEntity<>(deletePackage, HttpStatus.OK);
    }


    @GetMapping("/all/posted/property")
    public ResponseEntity<?> getAllPostedProperty() {

        List<PostedPropertyResponseDto> allProperty = propertyPostService.allPostedProperty();
        return ResponseEntity.ok(allProperty);
    }

    @PutMapping("/update/posted/property")
    public ResponseEntity<?> updatePostedProperty(@RequestBody PropertyPostUpdateDto post) {

        PropertyPost allProperty = propertyPostService.updatePostedProperty(post);
        return new ResponseEntity<>(HttpStatus.OK);
    }

}
