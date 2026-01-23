import { useState } from "react";
import { loginUser } from "../../../services/user-service";
import { useNavigate } from "react-router-dom";
import "../Login.css";

export default function Login() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [msg, setMsg] = useState("");
  const navigate = useNavigate();

  const handleLogin = async () => {
    setMsg("");
    if (!username || !password) {
      setMsg("❌ Please enter both username and password");
      return;
    }

    try {
      const res = await loginUser(username, password);

      const role = String(res.role || "").toUpperCase().trim();

      if (role === "STUDENT") {
        navigate("/dashboard/student", { replace: true });
        return;
      }

      if (role === "COORDINATOR") {
        navigate("/dashboard/coordinator", { replace: true });
        return;
      }

      setMsg(`❌ Unknown role: ${role || "(empty)"}`);
    } catch (err) {
      setMsg(err.message);
    }
  };

  return (
    <div className="login-container">
      <div className="card p-4 shadow login-card">
        <h3 className="text-center mb-3">User Login</h3>

        <input
          className="form-control mb-2"
          placeholder="username"
          onChange={(e) => setUsername(e.target.value)}
        />

        <input
          type="password"
          className="form-control mb-3"
          placeholder="Password"
          onChange={(e) => setPassword(e.target.value)}
        />

        <button className="btn btn-primary w-100" onClick={handleLogin}>
          Login
        </button>

        {msg && <p className="text-center mt-3">{msg}</p>}
      </div>
    </div>
  );
}
