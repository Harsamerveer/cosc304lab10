<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%
    // Database connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    String productId = request.getParameter("productId");
    String message = "";
    String productName = "";
    double productPrice = 0.0;
    String productDesc = "";

    if (productId != null && !productId.isEmpty()) {
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            // Fetch the product details before deletion
            String selectSQL = "SELECT productName, productPrice, productDesc FROM product WHERE productId = ?";
            PreparedStatement pstmt = con.prepareStatement(selectSQL);
            pstmt.setInt(1, Integer.parseInt(productId));
            ResultSet rst = pstmt.executeQuery();

            if (rst.next()) {
                productName = rst.getString("productName");
                productPrice = rst.getDouble("productPrice");
                productDesc = rst.getString("productDesc");

                // SQL query to delete the product
                String deleteSQL = "DELETE FROM product WHERE productId = ?";
                pstmt = con.prepareStatement(deleteSQL);
                pstmt.setInt(1, Integer.parseInt(productId));

                // Execute the deletion
                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    message = "Product '" + productName + "' deleted successfully!<br>"
                            + "Price: $" + productPrice + "<br>"
                            + "Description: " + productDesc;
                } else {
                    message = "Product deletion failed. Product not found.";
                }
            } else {
                message = "Product not found with ID: " + productId;
            }
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    } else {
        message = "Invalid product ID.";
    }
%>

<html>
    <head>
        <title>Delete Product</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                padding: 20px;
            }

            h1 {
                color: #333;
            }

            .message {
                padding: 15px;
                background-color: #e7f3e7;
                border: 1px solid #d4e8d4;
                color: #2e7d32;
                border-radius: 5px;
                margin-bottom: 20px;
            }

            .button {
                display: inline-block;
                padding: 10px 20px;
                background-color: #4CAF50;
                color: white;
                text-align: center;
                text-decoration: none;
                border-radius: 5px;
                border: none;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s ease;
            }

            .button:hover {
                background-color: #45a049;
            }

            .button:focus {
                outline: none;
            }
        </style>
    </head>
    <body>
        <h1>Delete Product</h1>
        <div class="message">
            <%= message %>
        </div>
       <!-- Admin Dashboard Button -->
	    <a href="admin.jsp" class="button">Admin Dashboard</a>
    </body>
</html>
