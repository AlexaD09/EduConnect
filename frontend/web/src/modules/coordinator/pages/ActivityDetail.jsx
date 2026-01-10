import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import LogoutButton from "../../../components/LogoutButton";

export default function ActivityDetail() {

    const tokenData = localStorage.getItem("auth_token");
  const navigate = useNavigate();
  
  if (!tokenData) {
    navigate("/");
    return null; 
  }
  const { activityId } = useParams();
  const [activity, setActivity] = useState(null);
  const [observations, setObservations] = useState("");
  const [status, setStatus] = useState("loading");
  



useEffect(() => {
  const fetchActivityDetails = async () => {
    try {
      const tokenData = JSON.parse(localStorage.getItem("auth_token"));
      const response = await fetch(`http://localhost:8003/activities/${activityId}`, {
        headers: {
          "Authorization": `Bearer ${tokenData.token}`
        }
      });
      
      if (response.ok) {
        const activityData = await response.json();
        
        
        const studentResponse = await fetch(`http://localhost:8001/students/${activityData.student_id}`);
        const studentData = studentResponse.ok ? await studentResponse.json() : {};
        
        setActivity({
          id: activityData.id,
          student: studentData.username || `Student ${activityData.student_id}`,
          date: activityData.created_at.split(' ')[0],
          description: activityData.description,
          entryPhoto: activityData.entry_photo_path,
          exitPhoto: activityData.exit_photo_path
        });
      }
      setStatus("ready");
    } catch (error) {
      console.error("Error fetching activity details:", error);
      setStatus("ready");
    }
  };

  if (activityId) {
    fetchActivityDetails();
  }
}, [activityId]);

  const handleApprove = async () => {
    try {
      const tokenData = JSON.parse(localStorage.getItem("auth_token"));
      const response = await fetch(`http://localhost:8004/activities/${activityId}/approve`, {
        method: "PATCH",
        headers: {
          "Authorization": `Bearer ${tokenData.token}`,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ activity_id: activityId })
      });
      
      if (response.ok) {
        alert("Activity approved successfully!");
        navigate(-2); // Go back to students list
      } else {
        const error = await response.json();
        throw new Error(error.detail || "Approval failed");
      }
    } catch (error) {
      console.error("Approval error:", error);
      alert(`Error: ${error.message}`);
    }
  };

  const handleReject = async () => {
    if (!observations.trim()) {
      alert("Please provide rejection observations");
      return;
    }
    
    try {
      const tokenData = JSON.parse(localStorage.getItem("auth_token"));
      const response = await fetch(`http://localhost:8004/activities/${activityId}/reject`, {
        method: "PATCH",
        headers: {
          "Authorization": `Bearer ${tokenData.token}`,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ 
          activity_id: activityId, 
          observations: observations.trim() 
        })
      });
      
      if (response.ok) {
        alert("Activity rejected successfully!");
        navigate(-2);
      } else {
        const error = await response.json();
        throw new Error(error.detail || "Rejection failed");
      }
    } catch (error) {
      console.error("Rejection error:", error);
      alert(`Error: ${error.message}`);
    }
  };

  const goBack = () => {
    navigate(-1);
  };

  if (status === "loading") {
    return (
      <div className="d-flex justify-content-center align-items-center min-vh-100">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
          <p className="mt-2">Loading activity details...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-vh-100 bg-light">
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
          <button className="navbar-brand btn text-white" onClick={goBack}>
            ← Back to Activities
          </button>
          <LogoutButton />
        </div>
      </nav>

      <div className="container-fluid px-4 py-4">
        <div className="row g-4">
          <div className="col-12">
            <div className="card shadow-sm">
              <div className="card-header bg-success text-white">
                <h5 className="mb-0">📝 Activity Detail #{activity.id}</h5>
              </div>
              <div className="card-body">
                <div className="row mb-3">
                  <div className="col-md-6">
                    <strong>Student:</strong>
                    <p className="text-muted">{activity.student}</p>
                  </div>
                  <div className="col-md-6">
                    <strong>Date:</strong>
                    <p className="text-muted">{activity.date}</p>
                  </div>
                </div>
                
                <div className="mb-3">
                  <strong>Description:</strong>
                  <p className="text-muted">{activity.description}</p>
                </div>
                
                <div className="row">
                  <div className="col-md-6">
                    <strong>Entry Photo:</strong>
                    <img 
                      src={`http://localhost:8003${activity.entryPhoto}`} 
                      alt="Entry" 
                      className="img-fluid mt-2"
                      style={{ maxHeight: '300px', objectFit: 'cover' }}
                    />
                  </div>
                  <div className="col-md-6">
                    <strong>Exit Photo:</strong>
                    <img 
                      src={`http://localhost:8003${activity.exitPhoto}`} 
                      alt="Exit" 
                      className="img-fluid mt-2"
                      style={{ maxHeight: '300px', objectFit: 'cover' }}
                    />
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div className="col-12">
            <div className="card shadow-sm">
              <div className="card-body">
                <div className="mb-3">
                  <label className="form-label">Rejection Observations (if needed):</label>
                  <textarea
                    className="form-control"
                    rows="3"
                    value={observations}
                    onChange={(e) => setObservations(e.target.value)}
                    placeholder="Enter reasons for rejection..."
                  />
                </div>
                
                <div className="d-grid gap-2 d-md-flex justify-content-md-end">
                  <button 
                    className="btn btn-success btn-lg px-4"
                    onClick={handleApprove}
                  >
                    ✅ Approve
                  </button>
                  <button 
                    className="btn btn-danger btn-lg px-4"
                    onClick={handleReject}
                  >
                    ❌ Reject
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}