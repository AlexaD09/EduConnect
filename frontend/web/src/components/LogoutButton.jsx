import { useNavigate } from "react-router-dom";

export default function LogoutButton() {
  const navigate = useNavigate();
  
  const handleLogout = () => {
    localStorage.removeItem("auth_token");
    navigate("/");
  };
  
  return (
    <button 
      className="btn btn-outline-light ms-3"
      onClick={handleLogout}
      title="Logout"
    >
      <i className="bi bi-box-arrow-right"></i>
    </button>
  );
}