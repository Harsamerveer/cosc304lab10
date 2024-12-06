<%@ page import="java.sql.*" %>
<%
    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection conn = null;
    PreparedStatement pstmt = null;

    // Action and warehouseId from query parameters
    String action = request.getParameter("action");
    String warehouseId = request.getParameter("warehouseId");

    // Variable for feedback message
    String message = "";
            
    // Check if the form was submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
                        // Load the SQL Server JDBC driver
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        conn = DriverManager.getConnection(url, uid, pw);
                        
                        // Get form parameters
                        String warehouseName = request.getParameter("warehouseName");

                        if ("update".equalsIgnoreCase(action) && warehouseId != null && !warehouseId.isEmpty()) {
                            // Update existing warehouse
                            String updateSQL = "UPDATE warehouse SET warehouseName = ? WHERE warehouseId = ?";
                            pstmt = conn.prepareStatement(updateSQL);
                            pstmt.setString(1, warehouseName);
                            pstmt.setInt(2, Integer.parseInt(warehouseId));
                            int rows = pstmt.executeUpdate();
                            message = rows > 0 ? "Warehouse updated successfully!" : "Warehouse update failed.";
                        } else if ("add".equalsIgnoreCase(action)) {
                            // Add new warehouse
                            String insertSQL = "INSERT INTO warehouse (warehouseName) VALUES (?)";
                            pstmt = conn.prepareStatement(insertSQL);
                            pstmt.setString(1, warehouseName);
                            int rows = pstmt.executeUpdate();
                            message = rows > 0 ? "Warehouse added successfully!" : "Warehouse addition failed.";
                        } else {
                            message = "Invalid action or missing warehouseId for update.";
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
                    <title>Add or Update Warehouse</title>
                </head>
                <body>
                    <h1><%= "update".equalsIgnoreCase(action) ? "Update Warehouse" : "Add Warehouse" %></h1>
                    <form method="post" action="addupdatewarehouse.jsp?action=<%= action %>&warehouseId=<%= warehouseId %>">
                        <% if ("update".equalsIgnoreCase(action)) { %>
                            <label for="warehouseId">Warehouse ID:</label>
                            <input type="text" name="warehouseId" id="warehouseId" value="<%= warehouseId %>" readonly><br><br>
                        <% } %>
                <label for="warehouseName">Warehouse Name:</label>
                <input type="text" id="warehouseName" name="warehouseName" required>
                
                <button type="submit">Submit</button>
            </form>
            <p><%= message %></p>
        </section>
    </main>

</body>
</html>