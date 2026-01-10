// frontend/web/src/services/activity-service.js
const ACTIVITY_SERVICE_URL = "http://localhost:8003";

export async function registerActivity(formData) {
  const response = await fetch(`${ACTIVITY_SERVICE_URL}/activities`, {
    method: "POST",
    body: formData  // ¡FormData en lugar de JSON!
  });
  
  if (!response.ok) {
    const error = await response.json();
    throw new Error(error.detail || "Error al registrar actividad");
  }
  
  return await response.json();
}

export async function getStudentActivities(studentId) {
  const response = await fetch(`http://localhost:8003/activities/student/${studentId}`);
  return await response.json();
}