const API_GATEWAY_URL = import.meta.env.VITE_API_GATEWAY_URL;

export async function loginUser(username, password) {
  const res = await fetch(`${API_GATEWAY_URL}/api/users/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ username, password }),
  });

  const data = await res.json();

  if (!res.ok) {
    let errorMsg = "Login failed";
    if (typeof data.detail === "string") errorMsg = data.detail;
    else if (Array.isArray(data.detail) && data.detail[0]?.msg) errorMsg = data.detail[0].msg;
    throw new Error(errorMsg);
  }

  const role =
    (typeof data.role === "string" && data.role) ||
    (typeof data.role_name === "string" && data.role_name) ||
    (data.role_id === 2 ? "STUDENT" : data.role_id === 3 ? "COORDINATOR" : data.role_id === 1 ? "ADMIN" : "");

  const tokenData = {
    token: data.access_token,
    role,
    role_id: data.role_id ?? null,
    username,
  };

  localStorage.setItem("auth_token", JSON.stringify(tokenData));

  return { ...data, role };
}
