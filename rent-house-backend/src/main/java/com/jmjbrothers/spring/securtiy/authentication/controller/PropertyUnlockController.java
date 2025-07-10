package com.jmjbrothers.spring.securtiy.authentication.controller;


import com.jmjbrothers.spring.securtiy.authentication.dto.MyUnlockPropertyDto;
import com.jmjbrothers.spring.securtiy.authentication.dto.PropertyUnlockDto;
import com.jmjbrothers.spring.securtiy.authentication.model.PropertyUnlock;
import com.jmjbrothers.spring.securtiy.authentication.service.PropertyUnlockService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/user")
public class PropertyUnlockController {

    private final PropertyUnlockService propertyUnlockService;

    @PostMapping("/property/unlock")
    public ResponseEntity<?> propertyUnlock(@RequestBody PropertyUnlockDto propertyUnlockDto){
        PropertyUnlock propertyUnlock = propertyUnlockService.propertyUnlock(propertyUnlockDto);
        if (propertyUnlock == null)
            return ResponseEntity.badRequest().body("Some thing wrong");
        return new ResponseEntity<>(propertyUnlock, HttpStatus.OK);
    }

    @GetMapping("/property/unlock/me")
    public ResponseEntity<?> getAllPropertyUnlockById(@RequestParam Long id){
        List<MyUnlockPropertyDto> allPropertyUnlockEachUser = propertyUnlockService.allPropertyUnlockById(id);
        if (allPropertyUnlockEachUser == null){
            return ResponseEntity.badRequest().body("No unlock property yet");
        }
        return new ResponseEntity<>(allPropertyUnlockEachUser, HttpStatus.OK);
    }
}
