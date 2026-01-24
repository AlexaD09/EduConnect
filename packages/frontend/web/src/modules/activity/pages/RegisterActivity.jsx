// frontend/web/src/modules/activity/pages/RegisterActivity.jsx
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../registerActivity.css";
import { registerActivity } from "../../../services/activity-service";
import { getStudentIdByUsername } from "../../../services/agreement-service";
import LogoutButton from "../../../components/LogoutButton";


export default function RegisterActivity() {

  const tokenData = localStorage.getItem("auth_token");
  const navigate = useNavigate();
  
  if (!tokenData) {
    navigate("/");
    return null; 
  }

  const [description, setDescription] = useState("");
  const [entryPhoto, setEntryPhoto] = useState(null);
  const [exitPhoto, setExitPhoto] = useState(null);
  const [msg, setMsg] = useState("");
  

  
  const getStudentId = async () => {
  try {
    const authData = localStorage.getItem("auth_token");
    if (!authData) {
      throw new Error("No authentication data");
    }
    
    const { username } = JSON.parse(authData);
    const student = await getStudentIdByUsername(username);
    return student.id; 
  } catch (error) {
    console.error("Error fetching student ID:", error);
    throw error;
  }
};
  
const handleSubmit = async (e) => {
  e.preventDefault();
  
  if (!entryPhoto || !exitPhoto || !description.trim()) {
    setMsg("❌ All fields are required");
    return;
  }

  try {
    
    const studentId = await getStudentId();
    
    const formData = new FormData();
    formData.append("student_id", studentId);
    formData.append("description", description);
    formData.append("entry_photo", entryPhoto);
    formData.append("exit_photo", exitPhoto);

    await registerActivity(formData);
    setMsg("✅ Activity successfully logged");
    setTimeout(() => navigate("/dashboard/student"), 2000);
  } catch (error) {
    setMsg(`❌ Error: ${error.message}`);
  }
};

  return (
    <div className="container py-4">
      <div className="card p-4 shadow">
        
        <h3 className="text-center mb-4">Record Daily Activity</h3>
        <LogoutButton />
        
        {msg && <div className="alert alert-info text-center">{msg}</div>}
        
        <form onSubmit={handleSubmit}>
          <div className="mb-3">
            <label className="form-label">📸 Entrance Photo</label>
            <input
              type="file"
              className="form-control"
              accept="image/*"
              onChange={(e) => setEntryPhoto(e.target.files[0])}
              required
            />
          </div>
          
          <div className="mb-3">
            <label className="form-label">📸 Exit Photo</label>
            <input
              type="file"
              className="form-control"
              accept="image/*"
              onChange={(e) => setExitPhoto(e.target.files[0])}
              required
            />
          </div>
          
          <div className="mb-3">
            <label className="form-label">📝 Description of today's activity</label>
            <textarea
              className="form-control"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Briefly describe what you did today..."
              rows="4"
              required
            />
          </div>
          
          <div className="d-grid gap-2">
            <button type="submit" className="btn btn-primary">
              Record Activity
            </button>
            <button 
              type="button" 
              className="btn btn-secondary"
              onClick={() => navigate("/dashboard/student")}
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}