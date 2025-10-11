import { Navigate } from "react-router-dom";

// Auto-logout time in milliseconds (10 minutes)
const AUTO_LOGOUT_TIME = 10 * 60 * 1000;

export default function ProtectedRoute({ children }) {
  const authData = JSON.parse(localStorage.getItem("adminAuthData") || "null");

  if (!authData || !authData.authenticated) {
    // Not logged in → redirect to login
    return <Navigate to="/admin" replace />;
  }

  const now = new Date().getTime();

  if (now - authData.timestamp > AUTO_LOGOUT_TIME) {
    // Auto-logout after 10 minutes
    localStorage.removeItem("adminAuthData");
    return <Navigate to="/admin" replace />;
  }

  // Refresh timestamp to extend session on route visit
  localStorage.setItem(
    "adminAuthData",
    JSON.stringify({ ...authData, timestamp: now })
  );

  return children;
}
