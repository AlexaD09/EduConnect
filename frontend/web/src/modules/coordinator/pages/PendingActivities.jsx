import { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import LogoutButton from "../../../components/LogoutButton";

export default function PendingActivities() {

    const tokenData = localStorage.getItem("auth_token");
  const navigate = useNavigate();
  
  if (!tokenData) {
    navigate("/");
    return null; 
  }
  const { studentId } = useParams();
  const [activities, setActivities] = useState([]);
  const [status, setStatus] = useState("loading");
  

  useEffect(() => {
    const fetchPendingActivities = async () => {
      try {
        const tokenData = JSON.parse(localStorage.getItem("auth_token"));
        const response = await fetch(`http://localhost:8003/activities/student/${studentId}`, {
          headers: {
            "Authorization": `Bearer ${tokenData.token}`
          }
        });
        
        if (response.ok) {
          const activities = await response.json();
          // Filtra solo las pendientes
          const pendingActivities = activities.filter(activity => activity.status === "PENDING");
          setActivities(pendingActivities);
        } else {
          setActivities([]);
        }
        setStatus("ready");
      } catch (error) {
        console.error("Error fetching activities:", error);
        setActivities([]);
        setStatus("ready");
      }
    };

    if (studentId) {
      fetchPendingActivities();
    }
  }, [studentId]);

  const handleViewDetail = (activityId) => {
    navigate(`/coordinator/activities/${activityId}/detail`);
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
          <p className="mt-2">Loading activities...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-vh-100 bg-light">
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
          <button className="navbar-brand btn text-white" onClick={goBack}>
            ← Back to Students
          </button>
          <LogoutButton />
        </div>
      </nav>

      <div className="container-fluid px-4 py-4">
        <div className="row g-4">
          <div className="col-12">
            <div className="card shadow-sm">
              <div className="card-header bg-warning text-white">
                <h5 className="mb-0">⏳ Pending Activities</h5>
              </div>
              <div className="card-body">
                {activities.length === 0 ? (
                  <p className="text-muted text-center">No pending activities</p>
                ) : (
                  <div className="list-group">
                    {activities.map(activity => (
                      <div 
                        key={activity.id} 
                        className="list-group-item list-group-item-action d-flex justify-content-between align-items-center"
                        onClick={() => handleViewDetail(activity.id)}
                        style={{cursor: 'pointer'}}
                      >
                        <div>
                          <h6 className="mb-1">Activity #{activity.id}</h6>
                          <small className="text-muted">{activity.date}</small>
                          <p className="mb-0 mt-2">{activity.description}</p>
                        </div>
                        <span className="badge bg-primary rounded-pill">View Detail</span>
                      </div>
                    ))}
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