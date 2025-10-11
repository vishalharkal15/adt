import TodayStudents from "../components/TodayStudents";
import TotalStudents from "../components/TotalStudents";
import WeeklyAttendance from "../components/WeeklyAttendance";
import TodayAbsent from "../components/AbsentToday";
export default function Dashboard() {
  return (
    <div
      style={{
        width: "100vw",  // Full viewport width
        height: "100vh", // Ensure the container takes full height as well
        margin: "0",     // Remove any margin that might cause offset
        padding: "0",    // Remove padding if any
        fontFamily: "Poppins, Arial, sans-serif",
        color: "#fff",
        overflowX: "hidden",  // Prevent horizontal scrolling
      }}
    >
      {/* Dashboard Heading */}
      <h2
        style={{
          textAlign: "center",
          marginBottom: "40px",
          fontSize: "2rem",
          background: "linear-gradient(90deg, #43e97b, #38f9d7)",
          WebkitBackgroundClip: "text",
          WebkitTextFillColor: "transparent",
          fontWeight: "700",
          letterSpacing: "1px",
        }}
      >
        Admin Dashboard
      </h2>

      {/* Summary Cards Section */}
      <div
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "stretch",
          gap: "30px",
          marginTop: "40px",
          flexWrap: "wrap", // ✅ allows wrapping for smaller screens
          width: "100%", // Ensure it takes full width
          transition: "all 0.3s ease",
        }}
      >
        <TodayStudents />
        <TodayAbsent />
        <TotalStudents />
      </div>

      {/* Weekly Attendance Chart */}
      <div style={{ marginTop: "50px" }}>
        <WeeklyAttendance />
      </div>

      {/* Responsive Media Queries */}
      <style>
        {`
          * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
          }

          html, body {
            width: 100%;
            height: 100%;
          }

          @media (max-width: 1024px) {
            h2 {
              font-size: 1.8rem !important;
            }
            .summary-cards {
              gap: 20px;
            }
          }

          @media (max-width: 768px) {
            div[style*="display: flex"][style*="wrap"] {
              flex-direction: row;
              justify-content: center;
            }
            div[style*="width: 300px"] {
              width: 45% !important;
            }
          }

          @media (max-width: 600px) {
            div[style*="display: flex"][style*="wrap"] {
              flex-direction: column !important;
              align-items: center !important;
              gap: 25px !important;
            }
            div[style*="width: 300px"] {
              width: 80% !important;
              height: auto !important;
            }
            h2 {
              font-size: 1.6rem !important;
              text-align: center;
            }
          }

          @media (max-width: 400px) {
            div[style*="width: 300px"] {
              width: 95% !important;
              height: auto !important;
            }
            h2 {
              font-size: 1.4rem !important;
            }
          }
        `}
      </style>
    </div>
  );
}
