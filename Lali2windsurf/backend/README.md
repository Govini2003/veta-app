# Pet Care Platform API

Backend API for a pet care platform connecting Pet Owners with Veterinarians.

## Features

- User management for Pet Owners and Veterinarians
- Pet profiles and medical records
- Detailed pet vaccination history
- Appointment scheduling between Pet Owners and Veterinarians
- Review system for Veterinarians
- Authentication and authorization

## API Endpoints

### Users

- `GET /api/users/profile/:userId` - Get user profile
- `PUT /api/users/profile/:userId` - Update user profile
- `POST /api/users/register` - Register a new user
- `POST /api/users/register/pet-owner` - Register a new pet owner (simplified endpoint)
- `POST /api/users/register/vet` - Register a new veterinarian (simplified endpoint)

### Veterinarians

- `GET /api/users/vets` - Get all veterinarians
- `GET /api/users/vets/specialization/:specialization` - Get vets by specialization
- `GET /api/users/vets/top-rated` - Get top-rated veterinarians

### Pets

- `GET /api/pets/user/:userId` - Get all pets for a user
- `GET /api/pets/:petId` - Get a specific pet
- `POST /api/pets` - Add a new pet
- `PUT /api/pets/:petId` - Update a pet
- `DELETE /api/pets/:petId` - Delete a pet

### Pet Vaccinations

- `GET /api/pets/:petId/vaccinations` - Get all vaccination records for a pet
- `POST /api/pets/:petId/vaccination` - Add a new vaccination record
- `PUT /api/pets/:petId/vaccination/:vaccinationId` - Update a vaccination record
- `DELETE /api/pets/:petId/vaccination/:vaccinationId` - Delete a vaccination record

### Pet Medical History

- `POST /api/pets/:petId/medical-history` - Add medical history record

### Appointments

- `GET /api/appointments/pet-owner/:userId` - Get all appointments for a pet owner
- `GET /api/appointments/vet/:userId` - Get all appointments for a veterinarian
- `GET /api/appointments/pet/:petId` - Get appointments for a specific pet
- `GET /api/appointments/:appointmentId` - Get a specific appointment
- `POST /api/appointments` - Create a new appointment
- `PUT /api/appointments/:appointmentId` - Update an appointment
- `PATCH /api/appointments/:appointmentId/cancel` - Cancel an appointment
- `PATCH /api/appointments/:appointmentId/complete` - Complete an appointment (vet only)

### Reviews

- `GET /api/reviews/vet/:vetId` - Get all reviews for a specific veterinarian
- `GET /api/reviews/pet-owner/:ownerId` - Get all reviews by a pet owner
- `POST /api/reviews` - Create a new review
- `PUT /api/reviews/:reviewId` - Update a review
- `DELETE /api/reviews/:reviewId` - Delete a review

## Models

### User

- Common fields: 
  - email
  - displayName
  - photoURL
  - phoneNumber
  - role

- Pet Owner specific fields:
  - address
  - location
  - bio

- Veterinarian specific fields (vetProfile):
  - licenseNumber
  - nic (National Identity Card)
  - slvcNumber (Sri Lanka Veterinary Council Number)
  - clinicName
  - clinicAddress
  - university (Veterinary College/University)
  - practiceInfo
  - specialization
  - qualifications
  - workingHours
  - services (with name, fee, and description)
  - paymentMethods
  - rating
  - reviewCount

### Pet

- Basic Information:
  - owner (reference to User)
  - name
  - species
  - breed
  - dateOfBirth
  - gender
  - weight
  - photoURL

- Medical History:
  - date
  - condition
  - treatment
  - vet (reference to User)

- Vaccination History:
  - vaccineType
  - vaccinationDate
  - renewalDate
  - vet (reference to User)
  - veterinarianName
  - veterinarianRegNumber
  - vaccineLabel
  - notes

### Appointment

- pet, petOwner, veterinarian, date, timeSlot, status, reason, notes, diagnosis, prescription, followUpDate

### Review

- petOwner, veterinarian, appointment, rating, comment

## Pet Vaccination Example

```json
POST /api/pets/:petId/vaccination
{
  "vaccineType": "Rabies",
  "vaccinationDate": "2023-06-15T00:00:00.000Z",
  "renewalDate": "2024-06-15T00:00:00.000Z",
  "vetId": "60d5ec9af682fbd12a0b4d8a",
  "vaccineLabel": "RabVac 3",
  "notes": "Annual vaccination"
}
```

## Registration Process

### Pet Owner Registration

```json
POST /api/users/register/pet-owner
{
  "displayName": "John Doe",
  "email": "john@example.com",
  "phoneNumber": "1234567890",
  "photoURL": "https://example.com/photo.jpg",
  "address": "123 Main St",
  "location": "Colombo",
  "bio": "Pet lover with 2 dogs and a cat"
}
```

### Veterinarian Registration

```json
POST /api/users/register/vet
{
  "displayName": "Dr. Jane Smith",
  "email": "jane@example.com",
  "phoneNumber": "0987654321",
  "photoURL": "https://example.com/photo.jpg",
  "licenseNumber": "VET12345",
  "nic": "123456789V",
  "slvcNumber": "SLVC2023001",
  "clinicName": "Happy Pets Clinic",
  "clinicAddress": "456 Vet Street, Colombo",
  "university": "University of Peradeniya",
  "practiceInfo": "Specialized in small animal care with 10 years of experience",
  "specialization": "Small Animals",
  "qualifications": ["DVM", "PhD in Veterinary Medicine"],
  "services": [
    {
      "name": "Vaccination",
      "fee": 2500,
      "description": "Routine vaccinations for pets"
    },
    {
      "name": "Surgery",
      "fee": 15000,
      "description": "General surgical procedures"
    }
  ],
  "paymentMethods": ["Cash", "Credit Card", "Bank Transfer"]
}
```

## Setup

1. Clone the repository
2. Install dependencies: `npm install`
3. Create a `.env` file with the following variables:
   ```
   PORT=3000
   MONGODB_URI=your_mongodb_connection_string
   NODE_ENV=development
   ```
4. Start the server: `npm run dev`

## Development

- `npm run dev` - Start the development server with nodemon
- `npm start` - Start the production server 