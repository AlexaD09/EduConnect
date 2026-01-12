import { useEffect, useState } from "react";
import { 
  getStudentIdByUsername, 
  checkAssignment, 
  createAssignment,
  getAgreementDetails,
  getTutorDetails
} from "../../../services/agreement-service";
import { getStudentActivities } from "../../../services/activity-service"; 
import { useNavigate } from "react-router-dom";
import LogoutButton from "../../../components/LogoutButton";

export default function StudentDashboard() {

    const tokenData = localStorage.getItem("auth_token");
  const navigate = useNavigate();
  
  if (!tokenData) {
    navigate("/");
    return null; 
  }
  const [status, setStatus] = useState("loading");
  const [assignmentInfo, setAssignmentInfo] = useState(null);
  const [studentInfo, setStudentInfo] = useState(null);
  const [agreementName, setAgreementName] = useState(null);
  const [tutorName, setTutorName] = useState(null);
  const [activities, setActivities] = useState([]); 
  

  useEffect(() => {
  const initializeDashboard = async () => {
    try {
      const authData = localStorage.getItem("auth_token");
      if (!authData) {
        throw new Error("No authentication data found");
      }
      
      const { username } = JSON.parse(authData);
      const student = await getStudentIdByUsername(username);
      setStudentInfo(student);
      
      // Get student activities
      const studentActivities = await getStudentActivities(student.id);
      setActivities(studentActivities);
      
      let assignment = await checkAssignment(student.id);
      
      // Si no tiene asignación, crear una
      if (!assignment.has_assignment) {
        await createAssignment(student.id);
        assignment = await checkAssignment(student.id); // Obtener la nueva asignación
      }
      
      setAssignmentInfo(assignment);
      
      // Obtener detalles del agreement y tutor
      const agreement = await getAgreementDetails(assignment.agreement_id);
      const tutor = await getTutorDetails(assignment.tutor_id);
      
      // Siempre usar el mismo formato (objeto)
      setAgreementName({
        institution: agreement.institution || agreement.name || `Agreement ${assignment.agreement_id}`,
        coordinator: agreement.coordinator_name || 'Not assigned'
      });
      
      setTutorName(tutor.full_name || `Tutor ${assignment.tutor_id}`);
      
      setStatus("ready");
    } catch (error) {
      console.error("Error initializing dashboard:", error);
      setStatus("error");
    }
  };

  initializeDashboard();
}, []);

  const handleRegisterActivity = () => {
    navigate("/activity/register");
  };

  // Function to display status with colors
  const getStatusBadge = (status) => {
    const statusConfig = {
      PENDING: { text: "Pending", class: "bg-warning" },
      APPROVED: { text: "Approved", class: "bg-success" },
      REJECTED: { text: "Rejected", class: "bg-danger" }
    };
    const config = statusConfig[status] || statusConfig.PENDING;
    return <span className={`badge ${config.class}`}>{config.text}</span>;
  };

  if (status === "loading") {
    return (
      <div className="d-flex justify-content-center align-items-center min-vh-100">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
          <p className="mt-2">Loading dashboard...</p>
        </div>
      </div>
    );
  }

  if (status === "error") {
    return (
      <div className="container-fluid px-4 py-5">
        <div className="alert alert-danger text-center">
          <h4>❌ Dashboard Loading Error</h4>
          <p>Please try again later.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-vh-100 bg-light">
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
          <span className="navbar-brand">🎓 Student Dashboard</span>
          <button 
            className="navbar-toggler" 
            type="button" 
            data-bs-toggle="collapse" 
            data-bs-target="#navbarNav"
          >
            <span className="navbar-toggler-icon"></span>
          </button>
          <div className="collapse navbar-collapse" id="navbarNav">
            <ul className="navbar-nav ms-auto">
              <li className="nav-item">
                <span className="nav-link">Welcome, {studentInfo?.username}</span>
              </li>
              <li className="nav-item">
                  <LogoutButton />
                  </li>
            </ul>
          </div>
        </div>
      </nav>

      <div className="container-fluid px-4 py-4">
        <div className="row g-4">
          {/* Academic information */}
          <div className="col-12">
            <div className="card shadow-sm">
              <div className="card-header bg-info text-white">
                <h5 className="mb-0">📋 Academic Information</h5>
              </div>
              <div className="card-body">
                {studentInfo && (
                  <div className="row mb-3">
                    <div className="col-md-6 col-lg-4">
                      <strong>Student:</strong>
                      <p className="text-muted">{studentInfo.full_name}</p>
                    </div>
                    <div className="col-md-6 col-lg-4">
                      <strong>City:</strong>
                      <p className="text-muted">{studentInfo.city}</p>
                    </div>
                    <div className="col-md-6 col-lg-4">
                      <strong>Career:</strong>
                      <p className="text-muted">{studentInfo.career}</p>
                    </div>
                  </div>
                )}

                {assignmentInfo?.has_assignment && (
                  <div className="row">
                    <div className="col-md-6">
                      <strong>Assigned Agreement:</strong>
                      <p className="text-muted fw-bold">{agreementName.institution}</p>
                    </div>
                    <div className="col-md-6">
                      <strong>Agreement Coordinator:</strong>
                      <p className="text-muted fw-bold">{agreementName.coordinator}</p>
                    </div>
                    <div className="col-md-6">
                      <strong>Academic Tutor:</strong>
                      <p className="text-muted fw-bold">{tutorName}</p>
                    </div>
                    
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Registration button */}
          <div className="col-12">
            <div className="d-grid gap-2">
              <button 
                className="btn btn-success btn-lg py-3"
                onClick={handleRegisterActivity}
              >
                <i className="bi bi-plus-circle me-2"></i>
                Register New Activity
              </button>
            </div>
          </div>

          {/* Allocation status */}
          <div className="col-lg-4 col-md-6">
            <div className="card shadow-sm h-100">
              <div className="card-header bg-success text-white">
                <h6 className="mb-0">✅ Assignment Status</h6>
              </div>
              <div className="card-body d-flex flex-column justify-content-center align-items-center text-center">
                <div className="badge bg-success fs-5 px-4 py-2 mb-3">
                  Assignment Completed
                </div>
                <p className="text-muted mb-0 small">
                  Ready to register activities
                </p>
              </div>
            </div>
          </div>

          {/* List of activities */}
          <div className="col-lg-8 col-md-6">
            <div className="card shadow-sm h-100">
              <div className="card-header bg-primary text-white">
                <h6 className="mb-0">📊 Your Activities</h6>
              </div>
              <div className="card-body">
                {activities.length === 0 ? (
                  <p className="text-muted text-center">No activities registered yet</p>
                ) : (
                  <div className="table-responsive">
                    <table className="table table-hover">
                      <thead>
                        <tr>
                          <th>Date</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tbody>
                        {activities.map(activity => (
                          <tr key={activity.id}>
                            <td>{activity.date}</td>
                            <td>{getStatusBadge(activity.status)}</td>
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