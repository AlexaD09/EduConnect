const API_GATEWAY_URL= import.meta.env.VITE_API_GATEWAY_URL;

export async function checkAssignment(studentId) {
  const response = await fetch(`${API_GATEWAY_URL}/api/agreements/assignment/${studentId}`);
  return await response.json();
}
 
export async function createAssignment(studentId) {
  const response = await fetch(`${API_GATEWAY_URL}/api/agreements/assign/${studentId}`, {
    method: "POST"
  });
  return await response.json();
}


export async function getStudentIdByUsername(username) {
  const response = await fetch(`${API_GATEWAY_URL}/api/users/students/by-username/${username}`);
  return await response.json();
}

export async function getAgreementDetails(agreementId) {
  const response = await fetch(`${API_GATEWAY_URL}/api/users/agreements/${agreementId}`);
  return await response.json();
}

export async function getTutorDetails(tutorId) {
  const response = await fetch(`${API_GATEWAY_URL}/api/agreements/tutors/${tutorId}`);
  return await response.json();
}

export async function getAgreementsByUser(studentId) {
  const token = localStorage.getItem("auth_token");
  const res = await fetch(`${import.meta.env.VITE_API_GATEWAY_URL}/api/users/agreements/${studentId}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  if (!res.ok) throw new Error("Failed to load agreements");
  return res.json();
}
