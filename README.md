# Real-Time Ticket Booking System

This project is a **Real-Time Ticket Booking System** built using **Spring Boot** for the backend and **React** for the frontend. The system handles ticket booking operations by processing user inputs, calculating ticket availability, and managing configurations in real-time.

---

## Features

- **Backend Features**:
  - Built with **Spring Boot**.
  - REST API to handle ticket processing.
  - Stores configurations and ticket data dynamically.
  - Uses JSON for data persistence.
  
- **Frontend Features**:
  - Developed with **React**.
  - Provides a clean UI for user inputs and results.
  - Handles multiple configurations dynamically.
  - Responsive design with animations for buttons.

- **Core System Features**:
  - Processes tickets in real-time based on:
    - Total tickets.
    - Customer consumption rate.
    - Vendor addition rate.
    - Ticket pool capacity.
    - Number of vendors.
  - Prevents exceeding ticket pool capacity.
  - Supports saving configurations to JSON.

---

## Technologies Used

- **Backend**:
  - Java
  - Spring Boot
  - Jackson (for JSON processing)
- **Frontend**:
  - React
  - Axios (for API requests)
- **Tools**:
  - IntelliJ IDEA
  - Postman (for API testing)
  - npm (for managing React dependencies)

---

## Getting Started

### Prerequisites
Ensure you have the following installed:
- **Java JDK** (version 11 or above)
- **Maven** (for building the Spring Boot project)
- **Node.js** (for running the React app)
- **npm** (Node Package Manager)

---

### Setting Up the Backend

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo-url.git
   cd your-backend-folder
