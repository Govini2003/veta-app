import React from "react";

function FeaturesSection() {
  const features = [
    { title: "Book Appointments Easily", description: "Schedule visits with top veterinarians in a few clicks." },
    { title: "Find Nearby Clinics", description: "Locate animal clinics, pharmacies, and pet shops." },
    { title: "Marketplace for Pet Products", description: "Buy and sell trusted pet care products online." },
    { title: "Compare Services", description: "Find the best quality and affordable services for your pets." },
  ];

  return (
    <section className="section" id="services">
      <h2>Our Features</h2>
      <div style={{ display: "flex", justifyContent: "center", flexWrap: "wrap" }}>
        {features.map((feature, index) => (
          <div className="card" key={index}>
            <h3>{feature.title}</h3>
            <p>{feature.description}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

export default FeaturesSection;
