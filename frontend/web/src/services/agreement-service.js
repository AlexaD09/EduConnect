const AGREEMENT_SERVICE_URL = "http://localhost:8002";

export async function checkAssignment(studentId) {
  const response = await fetch(`${AGREEMENT_SERVICE_URL}/assignment/${studentId}`);
  return await response.json();
}

export async function createAssignment(studentId) {
  const response = await fetch(`${AGREEMENT_SERVICE_URL}/assign/${studentId}`, {
    method: "POST"
  });
  return await response.json();
}

// 🔹 NUEVO: Obtener student_id por username
export async function getStudentIdByUsername(username) {
  const response = await fetch(`http://localhost:8001/students/by-username/${username}`);
  return await response.json();
}

export async function getAgreementDetails(agreementId) {
  const response = await fetch(`http://localhost:8001/agreements/${agreementId}`);
  return await response.json();
}

export async function getTutorDetails(tutorId) {
  const response = await fetch(`http://localhost:8002/tutors/${tutorId}`);
  return await response.json();
}