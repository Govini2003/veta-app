import React, { useState, useEffect } from "react";
import "./App.css";
import Header from "./components/Header";
import HeroSection from "./components/HeroSection";
import FeaturesSection from "./components/FeaturesSection";
import HowItWorks from "./components/HowItWorks";
import Testimonials from "./components/Testimonials";
import ContactSection from "./components/ContactSection";
import Footer from "./components/Footer";

function App() {
  const [userMessages, setUserMessages] = useState([]);

  // Load messages from localStorage when the component mounts
  useEffect(() => {
    const savedMessages = JSON.parse(localStorage.getItem("userMessages")) || [];
    setUserMessages(savedMessages);
  }, []);

  // Save messages to localStorage whenever they change
  useEffect(() => {
    localStorage.setItem("userMessages", JSON.stringify(userMessages));
  }, [userMessages]);

  const handleAddMessage = (name, message) => {
    const newMessage = `${message} - ${name}`;
    setUserMessages((prevMessages) => [...prevMessages, newMessage]);
  };

  return (
    <div className="App">
      <Header />
      <HeroSection />
      <FeaturesSection />
      <HowItWorks />
      <Testimonials userMessages={userMessages} />
      <ContactSection onAddMessage={handleAddMessage} />
      <Footer />
    </div>
  );
}

export default App;
