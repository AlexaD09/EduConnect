// src/modules/coordinator/pages/CoordinatorDashboard.jsx
import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import LogoutButton from "../../../components/LogoutButton";

export default function CoordinatorDashboard() {
  const tokenData = localStorage.getItem("auth_token");
  const navigate = useNavigate();
  
  if (!tokenData) {
    navigate("/");
    return null;
  }

  const [students, setStudents] = useState([]);
  const [status, setStatus] = useState("loading");
  
  useEffect(() => {
    const fetchAssignedStudents = async () => {
      try {
        const parsedToken = JSON.parse(tokenData);
        const coordinatorUsername = parsedToken.username;
        
        
        const coordResponse = await fetch(`http://localhost:8001/coordinators/by-username/${coordinatorUsername}`);
        if (!coordResponse.ok) {
          setStudents([]);
          setStatus("ready");
          return;
        }
        
        const coordinator = await coordResponse.json();
        const agreementId = coordinator.agreement_id; 
        
        if (!agreementId) {
          setStudents([]);
          setStatus("ready");
          return;
        }
        
        
        const activitiesResponse = await fetch(`http://localhost:8003/activities/pending-by-agreement/${agreementId}`);
        if (!activitiesResponse.ok) {
          setStudents([]);
          setStatus("ready");
          return;
        }
        
        const activities = await activitiesResponse.json();
        
       
        const studentIds = [...new Set(activities.map(a => a.student_id))];
        const studentsData = [];
        
        for (const studentId of studentIds) {
          try {
            const studentResponse = await fetch(`http://localhost:8001/students/${studentId}`);
            if (studentResponse.ok) {
              const studentData = await studentResponse.json();
              studentsData.push({
                id: studentId,
                username: studentData.username || `Student ${studentId}`,
                city: studentData.city || "Unknown"
              });
            }
          } catch (error) {
            
            studentsData.push({
              id: studentId,
              username: `Student ${studentId}`,
              city: "Unknown"
            });
          }
        }
        
        setStudents(studentsData);
        setStatus("ready");
      } catch (error) {
        console.error("Error fetching students:", error);
        setStudents([]);
        setStatus("ready");
      }
    };

    fetchAssignedStudents();
  }, [navigate, tokenData]);

  const handleViewPending = (studentId) => {
    navigate(`/coordinator/students/${studentId}/pending-activities`);
  };

  if (status === "loading") {
    return (
      <div className="d-flex justify-content-center align-items-center min-vh-100">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
          <p className="mt-2">Loading students...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-vh-100 bg-light">
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
          <span className="navbar-brand">🎓 Coordinator Dashboard</span>
          <LogoutButton />
        </div>
      </nav>

      <div className="container-fluid px-4 py-4">
        <div className="row g-4">
          <div className="col-12">
            <div className="card shadow-sm">
              <div className="card-header bg-info text-white">
                <h5 className="mb-0">📋 Students Under Your Supervision</h5>
              </div>
              <div className="card-body">
                {students.length === 0 ? (
                  <p className="text-muted text-center">No students assigned</p>
                ) : (
                  <div className="table-responsive">
                    <table className="table table-hover">
                      <thead>
                        <tr>
                          <th>Student</th>
                          <th>City</th>
                          <th>Actions</th>
                        </tr>
                      </thead>
                      <tbody>
                        {students.map(student => (
                          <tr key={student.id}>
                            <td>{student.username}</td>
                            <td>{student.city}</td>
                            <td>
                              <button 
                                className="btn btn-primary btn-sm"
                                onClick={() => handleViewPending(student.id)}
                              >
                                Pending Activities
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}