<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>


<%
	String userName = (String) session.getAttribute("authenticatedUser");

// TODO: Print Customer information

try {
    // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

// Connection parameters
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
     Statement stmt = con.createStatement()) {

String sql = "SELECT * FROM customer WHERE userid = ?";
PreparedStatement pstmt = con.prepareStatement(sql); 
pstmt.setString(1, userName);  

ResultSet rs = pstmt.executeQuery();
 if (rs.next()) {
        out.print("<table border='1'>");
  
       do {
            out.print("<!-- Table Rows -->");
            out.print("<tr>");
            out.print("<th>Customer ID</th>");
            out.print("<td>" + rs.getInt("customerId") + "</td>");
            out.print("<tr>");
            out.print("<th>First Name</th>");
            out.print("<td>" + rs.getString("firstName") + "</td>");
            out.print("<tr>");
            out.print("<th>Last Name</th>");
            out.print("<td>" + rs.getString("lastName") + "</td>");
            out.print("<tr>");
            out.print("<th>Email</th>");
            out.print("<td>" + rs.getString("email") + "</td>");
            out.print("<tr>");
                out.print("<th>Phone Number</th>");

            out.print("<td>" + rs.getString("phonenum") + "</td>");
            out.print("<tr>");
                out.print("<th>Address</th>");

            out.print("<td>" + rs.getString("address") + "</td>");
            out.print("<tr>");
                out.print("<th>City</th>");

            out.print("<td>" + rs.getString("city") + "</td>");
            out.print("<tr>");
                out.print("<th>State</th>");

            out.print("<td>" + rs.getString("state") + "</td>");
            out.print("<tr>");
                out.print("<th>Postal Code</th>");

            out.print("<td>" + rs.getString("postalCode") + "</td>");
            out.print("<tr>");
                out.print("<th>Country</th>");

            out.print("<td>" + rs.getString("country") + "</td>");
            out.print("<tr>");
                out.print("<th>User ID</th>");

            out.print("<td>" + rs.getString("userid") + "</td>");
            out.print("<tr>");
                out.print("<th>Password</th>");

            out.print("<td>" + rs.getString("password") + "</td>");
            out.print("</tr>");
        } while (rs.next());
        out.print("</table>");
    } else {
        out.print("No customer information found for user.");
    }
// Make sure to close connection
	rs.close();
	con.close();
} catch (SQLException ex) {
    ex.printStackTrace();
    out.println("SQLException: " + ex.getMessage());
} 
%>

</body>
</html>

