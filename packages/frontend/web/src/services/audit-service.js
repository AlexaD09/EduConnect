const API_GATEWAY_URL = import.meta.env.VITE_API_GATEWAY_URL;

export async function logAuditEvent(userId, action, resource, details = null) {
  const response = await fetch(`${API_GATEWAY_URL}/api/audit/log`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ user_id: userId, action, resource, details })
  });
  return await response.json();
}

export async function getUserAuditLogs(userId) {
  const response = await fetch(`${API_GATEWAY_URL}/api/audit/user/${userId}`);
  return await response.json();
}

export async function getAuditLogsByAction(action) {
  const response = await fetch(`${API_GATEWAY_URL}/api/audit/action/${action}`);
  return await response.json();
}