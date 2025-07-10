# 🏠 Rent House App

A full-stack mobile rental application built with **Flutter** (frontend) and **Spring Boot** (backend). The platform enables users to **post**, **search**, and **unlock** rental properties with a credit-based system.

---

##  Flutter Frontend

### Features

-  JWT Authentication (Login & Register)
-  View all available properties
-  Search by title, thana, section, rent
-  Unlock property details with credit
-  Image carousel for property preview
-  Post properties (with multiple images)
-  Edit/Delete posted properties
-  My Unlocked Properties screen
-  Profile view/edit + Logout

---

## 🔧 Spring Boot Backend

### Technologies

- Java 21
- Spring Boot 3
- Spring Security + JWT
- Spring Data JPA
- Oracle 19c Database
- Multipart File Upload Support

### Modules

- `AuthController`: Register/Login with JWT
- `PropertyController`: Post, list, unlock, and manage properties
- `UserController`: Profile info for logged-in users
- `UnlockController`: Credit deduction and unlock history

---

## Credit System

- Buyers must unlock properties using credits
- Unlocking reveals owner's contact info
- Admin or system can assign credit balance
- Credit is stored and validated during unlock

---

## Image Upload

- Property posting supports multiple images
- Images uploaded via `MultipartFile[]`
- Stored on backend filesystem
- Image URLs sent to frontend for preview carousel

