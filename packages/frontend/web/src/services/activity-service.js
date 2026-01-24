const API_GATEWAY_URL = import.meta.env.VITE_API_GATEWAY_URL;


export async function registerActivity(formData) {
  const response = await fetch(`${API_GATEWAY_URL}/api/activities/activity`, {
    method: "POST",
    body: formData  
  });
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.detail || "Error al registrar actividad");
  }
  
  return await response.json();
}

export async function getStudentActivities(studentId) {
  const response = await fetch(`${API_GATEWAY_URL}/api/activities/student/${studentId}`);
  return await response.json();
}