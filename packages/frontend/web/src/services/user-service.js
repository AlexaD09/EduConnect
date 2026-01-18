const API_GATEWAY_URL = import.meta.env.VITE_API_GATEWAY_URL;
console.log("API_GATEWAY_URL:", API_GATEWAY_URL);

export async function loginUser(username, password) {
  const res = await fetch(`${API_GATEWAY_URL}/api/users/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({username, password }),
  });

  const data = await res.json();

  if (!res.ok) {
    let errorMsg = "Login failed";
    if (typeof data.detail === "string") {
      errorMsg = data.detail; 
    } else if (Array.isArray(data.detail) && data.detail[0]?.msg) {
      errorMsg = data.detail[0].msg;
    }
    throw new Error(errorMsg);
  }

  
  const tokenData = {
    token: data.access_token,
    role: data.role,
    username: username  
  };
  localStorage.setItem("auth_token", JSON.stringify(tokenData));
  
  return data;
}