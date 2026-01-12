import { Routes, Route } from "react-router-dom";
import Login from "../modules/user/pages/Login";
import StudentDashboard from "../modules/user/pages/StudentDashboard";
import RegisterActivity from "../modules/activity/pages/RegisterActivity"; 
import CoordinatorDashboard from "../modules/coordinator/pages/CoordinatorDashboard";
import PendingActivities from "../modules/coordinator/pages/PendingActivities";
import ActivityDetail from "../modules/coordinator/pages/ActivityDetail";

export default function Router() {
  return (
    <Routes> 
      <Route path="/" element={<Login />} />
      <Route path="/dashboard/student" element={<StudentDashboard />} /> 
      <Route path="/activity/register" element={<RegisterActivity />} />
      <Route path="/dashboard/coordinator" element={<CoordinatorDashboard />} />
      <Route path="/coordinator/students/:studentId/pending-activities" element={<PendingActivities />} />
      <Route path="/coordinator/activities/:activityId/detail" element={<ActivityDetail />} />
    </Routes>
  );
}
