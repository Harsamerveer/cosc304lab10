<%@ page import="java.sql.*" %>
<%@ page import="java.sql.*, java.io.InputStream, java.math.BigDecimal" %>
<%
    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection conn = null;
    PreparedStatement pstmt = null;

    // Action and productId from query parameters
    String action = request.getParameter("action");
    String productId = request.getParameter("productId");

    // Initialize form variables
    String productName = "";
    String productPrice = "";
    String productImageURL = "";
    String productDesc = "";
    String categoryId = "";

    // Variable for feedback message
    String message = "";

    // Check if the form was submitted
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            // Load the SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(url, uid, pw);

            // Get form parameters for the product
            productName = request.getParameter("productName");
            productPrice = request.getParameter("productPrice");
            productImageURL = request.getParameter("productImageURL");
            Part productImagePart = request.getPart("productImage"); // for file upload
            productDesc = request.getParameter("productDesc");
            categoryId = request.getParameter("categoryId");

            // Check if action is "update" and productId is provided
            if ("update".equalsIgnoreCase(action) && productId != null && !productId.isEmpty()) {
                // Update existing product
                String updateSQL = "UPDATE product SET productName = ?, productPrice = ?, productImageURL = ?, productImage = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, productName);
                pstmt.setBigDecimal(2, new BigDecimal(productPrice));  // Use BigDecimal for price
                pstmt.setString(3, productImageURL);
                
                if (productImagePart != null) {
                    InputStream inputStream = productImagePart.getInputStream();
                    pstmt.setBinaryStream(4, inputStream);
                } else {
                    pstmt.setNull(4, Types.BINARY); // In case no image is uploaded
                }

                pstmt.setString(5, productDesc);
                pstmt.setInt(6, Integer.parseInt(categoryId));
                pstmt.setInt(7, Integer.parseInt(productId));

                int rows = pstmt.executeUpdate();
                message = rows > 0 ? "Product updated successfully!" : "Product update failed.";
            } else if ("add".equalsIgnoreCase(action)) {
                // Add new product
                String insertSQL = "INSERT INTO product (productName, productPrice, productImageURL, productImage, productDesc, categoryId) VALUES (?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, productName);
                pstmt.setBigDecimal(2, new BigDecimal(productPrice));  // Use BigDecimal for price
                pstmt.setString(3, productImageURL);
                
                if (productImagePart != null) {
                    InputStream inputStream = productImagePart.getInputStream();
                    pstmt.setBinaryStream(4, inputStream);
                } else {
                    pstmt.setNull(4, Types.BINARY); // In case no image is uploaded
                }

                pstmt.setString(5, productDesc);
                pstmt.setInt(6, Integer.parseInt(categoryId));

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
%>


<html>
<head>
    <link rel="stylesheet" href="generaladdupdate.css">
    <title>Add or Update Product</title>
</head>
<body>
    <h1><%= "update".equalsIgnoreCase(action) ? "Update Product" : "Add Product" %></h1>
    <form method="post" enctype="multipart/form-data" action="addupdateproduct.jsp?action=<%= action %>&productId=<%= productId %>">
        <% if ("update".equalsIgnoreCase(action)) { %>
            <label for="productId">Product ID:</label>
            <input type="text" name="productId" id="productId" value="<%= productId %>" readonly><br><br>
        <% } %>

    <label for="productName">Product Name:</label>
    <input type="text" id="productName" name="productName" value="<%= productName %>" required>

    <label for="productPrice">Product Price:</label>
    <input type="text" id="productPrice" name="productPrice" value="<%= productPrice %>" required>

    <label for="productImageURL">Product Image URL:</label>
    <input type="text" id="productImageURL" name="productImageURL" value="<%= productImageURL %>">

    <label for="productImage">Product Image:</label>
    <input type="file" id="productImage" name="productImage">

    <label for="productDesc">Product Description:</label>
    <textarea id="productDesc" name="productDesc" rows="5" required><%= productDesc %></textarea>

    <input type="submit" value="<%= "update".equalsIgnoreCase(action) ? "Update Product" : "Add Product" %>">
</form>
<p><%= message %></p>   
</body>
</html>