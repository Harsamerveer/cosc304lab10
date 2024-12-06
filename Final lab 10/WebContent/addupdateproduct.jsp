<%@ page import="java.sql.*, java.util.List, java.util.ArrayList" %>

<%
    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Action and productId from query parameters
    String action = request.getParameter("action");
    String productId = request.getParameter("productId");

    // Variable for feedback message
    String message = "";
    String selectedCategoryId = "";

    // List to hold category options
    List<String> categories = new ArrayList<>();

    // Check if the form was submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Load the SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url, uid, pw);
                        
            // Get form parameters
            String productName = request.getParameter("productName");
            String productPrice = request.getParameter("productPrice");
            String productDesc = request.getParameter("productDesc");
            selectedCategoryId = request.getParameter("categoryId");

            if ("update".equalsIgnoreCase(action) && productId != null && !productId.isEmpty()) {
                // Update existing product
                String updateSQL = "UPDATE product SET productName = ?, productPrice = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, productName);
                pstmt.setBigDecimal(2, new java.math.BigDecimal(productPrice));
                pstmt.setString(3, productDesc);
                pstmt.setInt(4, Integer.parseInt(selectedCategoryId));
                pstmt.setInt(5, Integer.parseInt(productId));
                int rows = pstmt.executeUpdate();
                message = rows > 0 ? "Product updated successfully!" : "Product update failed.";
            } else if ("add".equalsIgnoreCase(action)) {
                // Add new product
                String insertSQL = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, productName);
                pstmt.setBigDecimal(2, new java.math.BigDecimal(productPrice));
                pstmt.setString(3, productDesc);
                pstmt.setInt(4, Integer.parseInt(selectedCategoryId));
                int rows = pstmt.executeUpdate();
                message = rows > 0 ? "Product added successfully!" : "Product addition failed.";
            } else {
                message = "Invalid action or missing productId for update.";
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

    // Retrieve categories for the dropdown
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(url, uid, pw);
        String categorySQL = "SELECT categoryId, categoryName FROM category";
        pstmt = conn.prepareStatement(categorySQL);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            categories.add(rs.getString("categoryId") + ":" + rs.getString("categoryName"));
        }
    } catch (Exception e) {
        message = "Error retrieving categories: " + e.getMessage();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            message += " (Closing connection failed: " + e.getMessage() + ")";
        }
    }
%>

<html>
    <head>
        <link rel="stylesheet" href="generaladdupdate.css">
        <title>Add or Update Product</title>
    </head>
    <body>
        <h1><%= "update".equalsIgnoreCase(action) ? "Update Product" : "Add Product" %></h1>
        <form method="post" action="addupdateproduct.jsp?action=<%= action %>&productId=<%= productId %>">
            <% if ("update".equalsIgnoreCase(action)) { %>
                <label for="productId">Product ID:</label>
                <input type="text" name="productId" id="productId" value="<%= productId %>" readonly><br><br>
            <% } %>

            <label for="productName">Product Name:</label>
            <input type="text" id="productName" name="productName" required><br><br>

            <label for="productPrice">Product Price:</label>
            <input type="text" id="productPrice" name="productPrice" required><br><br>

            <label for="productDesc">Product Description:</label>
            <textarea id="productDesc" name="productDesc" required></textarea><br><br>

            <label for="categoryId">Category:</label>
            <select id="categoryId" name="categoryId" required>
                <option value="">--Select Category--</option>
                <% for (String category : categories) { 
                        String[] categoryParts = category.split(":");
                        String categoryId = categoryParts[0];
                        String categoryName = categoryParts[1];
                        // Check if the current category is selected
                        String selected = categoryId.equals(selectedCategoryId) ? "selected" : "";
                %>
                    <option value="<%= categoryId %>" <%= selected %>><%= categoryName %></option>
                <% } %>
            </select><br><br>

            <button type="submit">Submit</button>
        </form>
        <p><%= message %></p>
        <!-- Admin Dashboard Button -->
	<a href="admin.jsp" class="b1">Admin Dashboard</a>
    </body>
</html>
