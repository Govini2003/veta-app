import React, { useState } from "react";
import { FaEnvelope, FaInstagram } from "react-icons/fa"; // Ensure you have react-icons installed

function ContactSection({ onAddMessage }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [message, setMessage] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();
    if (name && message) {
      onAddMessage(name, message);
      setName("");
      setEmail("");
      setMessage("");
    }
  };

  return (
    <section
      className="section"
      id="contact"
      style={{ textAlign: "center", padding: "20px" }}
    >
      <h2>Contact Us</h2>
      <form
        onSubmit={handleSubmit}
        style={{
          margin: "20px auto",
          maxWidth: "400px",
          display: "flex",
          flexDirection: "column",
        }}
      >
        <input
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          style={{
            margin: "10px",
            padding: "10px",
            borderRadius: "20px", // Increased border radius
            border: "1px solid #ccc",
          }}
        />
        <input
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          style={{
            margin: "10px",
            padding: "10px",
            borderRadius: "20px", // Increased border radius
            border: "1px solid #ccc",
          }}
        />
        <textarea
          placeholder="Message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          style={{
            margin: "10px",
            padding: "10px",
            borderRadius: "20px", // Increased border radius
            border: "1px solid #ccc",
          }}
        />
        <button
          type="submit"
          style={{
            padding: "10px",
            backgroundColor: "#008000",
            color: "white",
            border: "none",
            borderRadius: "5px",
            cursor: "pointer",
          }}
        >
          Send Message
        </button>
      </form>

      {/* Contact Information Section */}
      <div style={{ marginTop: "20px" }}>
        {/* Email Section */}
        <p
          style={{
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
            marginBottom: "10px",
          }}
        >
          <FaEnvelope style={{ marginRight: "8px", color: "#008000" }} />{" "}
          <a
            href="mailto:veta.lk.app@gmail.com"
            style={{
              textDecoration: "none",
              color: "#008000",
              fontWeight: "bold",
            }}
          >
            veta.lk.app@gmail.com
          </a>
        </p>

        {/* Instagram Section */}
        <p
          style={{
            display: "flex",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <FaInstagram style={{ marginRight: "8px", color: "#C13584" }} />{" "}
          <a
            href="https://www.instagram.com/veta.lk.app?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="
            target="_blank"
            rel="noopener noreferrer"
            style={{
              textDecoration: "none",
              color: "#C13584",
              fontWeight: "bold",
            }}
          >
            Instagram
          </a>
        </p>
      </div>
    </section>
  );
}

export default ContactSection;
