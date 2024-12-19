import React from "react";
import { FaUserPlus, FaSearch, FaCalendarCheck, FaHeart } from "react-icons/fa"; // Import icons from react-icons
import "./HowItWorks.css"; // Ensure you have this CSS file for styles

function HowItWorks() {
  return (
    <section className="how-it-works-section">
      <h2 className="how-it-works-heading">How It Works</h2>
      <div className="how-it-works-steps">
        {/* Step 1 */}
        <div className="how-it-works-step">
          <FaUserPlus className="step-icon" />
          <h3>Sign Up</h3>
          <p>Create your free account to get started.</p>
        </div>

        {/* Step 2 */}
        <div className="how-it-works-step">
          <FaSearch className="step-icon" />
          <h3>Explore Services</h3>
          <p>Find services and products for your pets.</p>
        </div>

        {/* Step 3 */}
        <div className="how-it-works-step">
          <FaCalendarCheck className="step-icon" />
          <h3>Book or Purchase</h3>
          <p>Schedule appointments or purchase pet products.</p>
        </div>

        {/* Step 4 */}
        <div className="how-it-works-step">
          <FaHeart className="step-icon" />
          <h3>Enjoy Better Care</h3>
          <p>Experience stress-free pet care with Veta.lk.</p>
        </div>
      </div>
    </section>
  );
}

export default HowItWorks;
