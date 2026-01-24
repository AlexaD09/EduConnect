import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import LogoutButton from "../../../components/LogoutButton";
import "../AuditLog.css";

const API_GATEWAY_URL = import.meta.env.VITE_API_GATEWAY_URL;

export default function AuditLog() {
  const navigate = useNavigate();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState("all");

  useEffect(() => {
    const fetchAuditLogs = async () => {
      try {
        const tokenData = localStorage.getItem("auth_token");
        if (!tokenData) {
          navigate("/");
          return;
        }
        
        const { username } = JSON.parse(tokenData);
        let url = `${API_GATEWAY_URL}/api/audit/user/${username}`;
        
        if (filter !== "all") {
          url = `${API_GATEWAY_URL}/api/audit/action/${filter}`;
        }

        const response = await fetch(url);
        if (response.ok) {
          const data = await response.json();
          setLogs(data);
        }
      } catch (error) {
        console.error("Error fetching audit logs:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchAuditLogs();
  }, [navigate, filter]);

  const getActionBadge = (action) => {
    const badges = {
      "LOGIN": "bg-success",
      "APPROVE": "bg-primary",
      "REJECT": "bg-danger",
      "CREATE": "bg-info",
      "UPDATE": "bg-warning"
    };
    return badges[action] || "bg-secondary";
  };

  if (loading) {
    return (
      <div className="min-vh-100 bg-light d-flex justify-content-center align-items-center">
        <div className="text-center">
          <div className="spinner-border text-primary" role="status">
            <span className="visually-hidden">Loading...</span>
          </div>
          <p className="mt-2">Loading audit logs...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-vh-100 bg-light">
      <nav className="navbar navbar-expand-lg navbar-dark bg-primary">
        <div className="container-fluid">
          <span className="navbar-brand">🔍 Audit Log</span>
          <LogoutButton />
        </div>
      </nav>

      <div className="container-fluid px-4 py-4">
        <div className="row mb-4">
          <div className="col-md-6">
            <select 
              className="form-select"
              value={filter}
              onChange={(e) => setFilter(e.target.value)}
            >
              <option value="all">All Actions</option>
              <option value="LOGIN">Login</option>
              <option value="APPROVE">Approvals</option>
              <option value="REJECT">Rejections</option>
              <option value="CREATE">Creations</option>
            </select>
          </div>
        </div>

        <div className="row">
          <div className="col-12">
            <div className="card shadow-sm">
              <div className="card-header bg-dark text-white">
                <h5 className="mb-0">📋 Audit Trail</h5>
              </div>
              <div className="card-body">
                {logs.length === 0 ? (
                  <p className="text-muted text-center">No audit logs found</p>
                ) : (
                  <div className="table-responsive">
                    <table className="table table-hover">
                      <thead>
                        <tr>
                          <th>Timestamp</th>
                          <th>User</th>
                          <th>Action</th>
                          <th>Resource</th>
                          <th>Details</th>
                        </tr>
                      </thead>
                      <tbody>
                        {logs.map(log => (
                          <tr key={log.id}>
                            <td>{new Date(log.timestamp).toLocaleString()}</td>
                            <td>{log.user_id}</td>
                            <td>
                              <span className={`badge ${getActionBadge(log.action)}`}>
                                {log.action}
                              </span>
                            </td>
                            <td>{log.resource}</td>
                            <td>{log.details || "-"}</td>
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