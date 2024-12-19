import React from "react";
import "./HeroSection.css";  // Or the appropriate path to your CSS file

function HeroSection() {
  return (
    <section
      className="section"
      id="home"
      style={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        height: "35vh",
      }}
    >
      {/* Add margin-top to move the heading further down */}
      <h1 style={{ marginTop: "70px" }}>Connecting Pet Owners to Veterinary Services</h1>
      <p>Your one-stop platform for appointments, pet care, and more!</p>

      <button
        className="explore-btn"
        style={{
          marginLeft: "10px",
          backgroundColor: "transparent",
          color: "#008000",
          border: "1px solid #008000",
        }}
      >
        Explore Services
      </button>

    </section>
  );
}

export default HeroSection;
