<!DOCTYPE html>
<html>
<head>
    <title>Add/Update Product</title>
    <style>
        /* Basic styling for form */
        form {
            width: 50%;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-bottom: 8px;
        }
        input, textarea, select {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
        }
        input[type="submit"] {
            width: auto;
        }
    </style>
</head>
<body>

<h1>Add or Update Product</h1>


<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<% 
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";        
String uid = "sa";
String pw = "304#sa#pw";



    String action = request.getParameter("action");
    String productId = request.getParameter("productId");
    String productName = "";
    String productPrice = "";
    String productImageURL = "";
    String productDesc = "";
    String categoryId = "";

    if (action != null && action.equals("update") && productId != null) {
        // Fetch existing product details for update
        try (Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt = con.createStatement()) {
            String sql = "SELECT * FROM product WHERE productId = ?";
            PreparedStatement pstmt = con.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(productId));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                productName = rs.getString("productName");
                productPrice = rs.getString("productPrice");
                productImageURL = rs.getString("productImageURL");
                productDesc = rs.getString("productDesc");
                categoryId = rs.getString("categoryId");
            }
        } catch (SQLException e) {
            out.println("Error fetching product: " + e.getMessage());
        }
    }
%>

<form action="addorupdateproduct.jsp" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="action" value="<%= (action != null && action.equals("update")) ? "update" : "add" %>">
    <input type="hidden" name="productId" value="<%= productId != null ? productId : "" %>">
    
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

    <label for="categoryId">Category:</label>
    <select id="categoryId" name="categoryId" required>
        <!-- Fetch categories from the database to populate this dropdown -->
        <% 
            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 Statement stmt = con.createStatement()) {
                String sql = "SELECT * FROM category";
                ResultSet rs = stmt.executeQuery(sql);

                while (rs.next()) {
                    int catId = rs.getInt("categoryId");
                    String catName = rs.getString("categoryName");
        %>
            <option value="<%= catId %>" <%= categoryId.equals(String.valueOf(catId)) ? "selected" : "" %> >
                <%= catName %>
            </option>
        <% 
                }
            } catch (SQLException e) {
                out.println("Error fetching categories: " + e.getMessage());
            }
        %>
    </select>

    <input type="submit" value="<%= (action != null && action.equals("update")) ? "Update Product" : "Add Product" %>">
</form>

</body>
</html>