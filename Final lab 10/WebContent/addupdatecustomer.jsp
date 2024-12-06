<%@ page import="java.sql.*" %>
<%
    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection conn = null;
    PreparedStatement pstmt = null;

    // Action and customerId from query parameters
    String action = request.getParameter("action");
    String customerId = request.getParameter("customerId");

    // Variable for feedback message
    String message = "";

    // Check if the form was submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Load the SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url, uid, pw);

            // Get form parameters
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phonenum = request.getParameter("phonenum");
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            String postalCode = request.getParameter("postalCode");
            String country = request.getParameter("country");
            String userid = request.getParameter("userid");
            String password = request.getParameter("password");

            if ("update".equalsIgnoreCase(action) && customerId != null && !customerId.isEmpty()) {
                // Update existing customer
                String updateSQL = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, userid = ?, password = ? WHERE customerId = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phonenum);
                pstmt.setString(5, address);
                pstmt.setString(6, city);
                pstmt.setString(7, state);
                pstmt.setString(8, postalCode);
                pstmt.setString(9, country);
                pstmt.setString(10, userid);
                pstmt.setString(11, password);
                pstmt.setInt(12, Integer.parseInt(customerId));
                int rows = pstmt.executeUpdate();
                message = rows > 0 ? "Customer updated successfully!" : "Customer update failed.";
            } else if ("add".equalsIgnoreCase(action)) {
                // Add new customer
                String insertSQL = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, firstName);
                pstmt.setString(2, lastName);
                pstmt.setString(3, email);
                pstmt.setString(4, phonenum);
                pstmt.setString(5, address);
                pstmt.setString(6, city);
                pstmt.setString(7, state);
                pstmt.setString(8, postalCode);
                pstmt.setString(9, country);
                pstmt.setString(10, userid);
                pstmt.setString(11, password);
                int rows = pstmt.executeUpdate();
                message = rows > 0 ? "Customer added successfully!" : "Customer addition failed.";
            } else {
                message = "Invalid action or missing customerId for update.";
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                message += " (Closing connection failed: " + e.getMessage() + ")";
            }
        }
    }
%>
<html>
<head>
    <link rel="stylesheet" href="generaladdupdate.css">
    <title>Add or Update Customer</title>
</head>
<body>
    <h1><%= "update".equalsIgnoreCase(action) ? "Update Customer" : "Add Customer" %></h1>
    <form method="post" action="addupdatecustomer.jsp?action=<%= action %>&customerId=<%= customerId %>">
        <% if ("update".equalsIgnoreCase(action)) { %>
            <label for="customerId">Customer ID:</label>
            <input type="text" name="customerId" id="customerId" value="<%= customerId %>" readonly><br><br>
        <% } %>
        <label for="firstName">First Name:</label>
        <input type="text" name="firstName" id="firstName" required><br><br>
        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName" id="lastName" required><br><br>
        <label for="email">Email:</label>
        <input type="email" name="email" id="email" required><br><br>
        <label for="phonenum">Phone Number:</label>
        <input type="text" name="phonenum" id="phonenum"><br><br>
        <label for="address">Address:</label>
        <input type="text" name="address" id="address"><br><br>
        <label for="city">City:</label>
        <input type="text" name="city" id="city"><br><br>
        <label for="state">State:</label>
        <input type="text" name="state" id="state"><br><br>
        <label for="postalCode">Postal Code:</label>
        <input type="text" name="postalCode" id="postalCode"><br><br>
        <label for="country">Country:</label>
        <input type="text" name="country" id="country"><br><br>
        <label for="userid">User ID:</label>
        <input type="text" name="userid" id="userid" required><br><br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br><br>
        <button type="submit">Submit</button>
    </form>
    <p><%= message %></p>
</body>
</html>