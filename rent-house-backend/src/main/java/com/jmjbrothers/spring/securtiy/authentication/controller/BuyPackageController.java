package com.jmjbrothers.spring.securtiy.authentication.controller;

import com.jmjbrothers.spring.securtiy.authentication.dto.BuyPackageDto;
import com.jmjbrothers.spring.securtiy.authentication.dto.MyUnlockPropertyDto;
import com.jmjbrothers.spring.securtiy.authentication.dto.PurchaseHistoryDto;
import com.jmjbrothers.spring.securtiy.authentication.model.BuyPackage;
import com.jmjbrothers.spring.securtiy.authentication.service.BuyPackageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/user")
public class BuyPackageController {

    private final BuyPackageService transactionService;


    @PostMapping("/buy/package")
    public ResponseEntity<?> buyPackage(@RequestBody BuyPackageDto transactionDto){
        BuyPackage ct = transactionService.buyPackage(transactionDto);
        return new ResponseEntity<>(ct, HttpStatus.ACCEPTED);
    }

    @GetMapping("/buy/package/me")
    public ResponseEntity<?> getCreditPurchaseHistoryById(@RequestParam Long id){
        List<PurchaseHistoryDto> allPurchaseHistory = transactionService.allPropertyUnlockById(id);
        if (allPurchaseHistory == null){
            return ResponseEntity.badRequest().body("No unlock property yet");
        }
        return new ResponseEntity<>(allPurchaseHistory, HttpStatus.OK);
    }

    @GetMapping("/buy/package/all")
    public ResponseEntity<?> getAllCreditPurchaseHistory(){
        List<PurchaseHistoryDto> allPurchaseHistory = transactionService.allPropertyUnlock();
        if (allPurchaseHistory == null){
            return ResponseEntity.badRequest().body("No unlock property yet");
        }
        return new ResponseEntity<>(allPurchaseHistory, HttpStatus.OK);
    }



}
