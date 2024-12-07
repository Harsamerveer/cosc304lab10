<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>Warehouse Details</title>
    <style>
        /* Your existing CSS styles */
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Retrieve the warehouseId from the URL query parameter
String warehouseId = request.getParameter("id");

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
     PreparedStatement pstmt = con.prepareStatement("SELECT * FROM warehouse WHERE warehouseId = ?")) {

    pstmt.setInt(1, Integer.parseInt(warehouseId));  // Set warehouseId parameter
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        String warehouseName = rs.getString("warehouseName");
        String warehouseLocation = rs.getString("location");
        String warehouseManager = rs.getString("manager");
        // Retrieve other details if necessary

        %>
        <div class="container">
            <h2>Warehouse Details</h2>
            <p><strong>Warehouse Name:</strong> <%= warehouseName %></p>
            <p><strong>Location:</strong> <%= warehouseLocation %></p>
            <p><strong>Manager:</strong> <%= warehouseManager %></p>
            <!-- Display other details as needed -->
        </div>
        <%
    } else {
        out.println("<p>No warehouse found with the provided ID.</p>");
    }

    rs.close();
    con.close();
} catch (SQLException ex) {
    ex.printStackTrace();
    out.println("SQLException: " + ex.getMessage());
} 

%>

</body>
</html>
