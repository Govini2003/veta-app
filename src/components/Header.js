import React from 'react';
import { Navbar, Nav, NavDropdown } from 'react-bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';  // Ensure Bootstrap CSS is applied
import './Header.css'; // Import your custom CSS file for styles

const Header = () => {
  return (
    <header className="header">
      {/* Bootstrap Navbar */}
      <Navbar style={{ backgroundColor: '#008000' }} variant="light" expand="lg" fixed="top">
        <Navbar.Brand href="/" className="logo">
          Veta.lk
        </Navbar.Brand>
        <Navbar.Toggle aria-controls="navbar-nav" />
        <Navbar.Collapse id="navbar-nav">
          <Nav className="ms-auto">
            <Nav.Link href="/">Home</Nav.Link>
            <Nav.Link href="/about">About</Nav.Link>
            <Nav.Link href="/portfolio">Portfolio</Nav.Link>
            <Nav.Link href="/services">Service</Nav.Link>
            <Nav.Link href="/contact">Contact</Nav.Link>
            <NavDropdown title="More" id="nav-dropdown">
              <NavDropdown.Item href="/profile">Profile</NavDropdown.Item>
              <NavDropdown.Item href="/settings">Settings</NavDropdown.Item>
              <NavDropdown.Divider />
              <NavDropdown.Item href="/logout">Logout</NavDropdown.Item>
            </NavDropdown>
          </Nav>
        </Navbar.Collapse>
      </Navbar>
    </header>
  );
};

export default Header;
