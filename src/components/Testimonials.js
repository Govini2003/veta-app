import React from "react";

function Testimonials({ userMessages }) {
  return (
    <section className="section">
      <h2>What Our Users Say</h2>
      <div className="card">
        <p>"Veta.lk made it so easy to find a vet for my pet!" - Sarah</p>
      </div>
      <div className="card">
        <p>"I love the marketplace feature. Super convenient!" - John</p>
      </div>
      {userMessages.map((message, index) => (
        <div className="card" key={index}>
          <p>{message}</p>
        </div>
      ))}
    </section>
  );
}

export default Testimonials;
