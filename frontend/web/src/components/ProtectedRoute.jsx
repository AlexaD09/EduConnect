// src/components/ProtectedRoute.jsx
import { Navigate } from "react-router-dom";

/**
 * ProtectedRoute component
 * - Redirects unauthenticated users to login
 * - Restricts access based on user roles
 * - Automatically redirects users to their correct dashboard
 * 
 * @param {React.ReactNode} children - The component to protect
 * @param {string[]} allowedRoles - Array of roles allowed to access this route
 * @returns {JSX.Element} Protected component or redirect
 */
export default function ProtectedRoute({ children, allowedRoles }) {
  // Get auth token from localStorage
  const tokenData = localStorage.getItem("auth_token");
  
  // If no token exists, redirect to login
  if (!tokenData) {
    return <Navigate to="/" replace />;
  }
  
  try {
    const parsed = JSON.parse(tokenData);
    
    // If allowedRoles is specified, check if user has permission
    if (allowedRoles && !allowedRoles.includes(parsed.role)) {
      // Redirect coordinator to coordinator dashboard
      if (parsed.role === "COORDINATOR") {
        return <Navigate to="/dashboard/coordinator" replace />;
      } 
      // Redirect student to student dashboard
      else if (parsed.role === "STUDENT") {
        return <Navigate to="/dashboard/student" replace />;
      } 
      // For any other role, redirect to login
      else {
        return <Navigate to="/" replace />;
      }
    }
    
    // If all checks pass, render the protected component
    return children;
  } catch (error) {
    // If token is invalid, clear it and redirect to login
    localStorage.removeItem("auth_token");
    return <Navigate to="/" replace />;
  }
}