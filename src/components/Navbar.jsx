import { useState } from "react";
import { Link, useLocation } from "react-router-dom";
import "./Navbar.css";

export default function Navbar() {
  const [isOpen, setIsOpen] = useState(false);
  const location = useLocation();

  // Check if current route is admin/dashboard
  const onAdminPage = location.pathname === "/admin" || location.pathname === "/dashboard";

  return (
    <nav className="navbar">
      <div className="navbar-container">
        {/* Brand Name */}
        <Link to="/" className="navbar-brand">
          Versatile Attendance System
        </Link>

        {/* Desktop & Mobile Links */}
        <div className={`nav-links ${isOpen ? "active" : ""}`}>
          {onAdminPage ? (
            <Link to="/enroll" onClick={() => setIsOpen(false)}>
              Enroll
            </Link>
          ) : (
            <Link to="/admin" onClick={() => setIsOpen(false)}>
              Admin Panel
            </Link>
          )}
        </div>

        {/* Hamburger Menu */}
        <div
          className={`hamburger ${isOpen ? "open" : ""}`}
          onClick={() => setIsOpen(!isOpen)}
        >
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
    </nav>
  );
}
