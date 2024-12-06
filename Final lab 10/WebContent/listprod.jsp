<%@ page import="java.sql.*, java.net.URLEncoder" %> 
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Product Search</title>
    <link rel="stylesheet" type="text/css" href="listprod.css">
</head>
<body>
    <div class="container">
        <h1>Search for the products you want to buy:</h1>

        <form method="get" action="listprod.jsp" class="search-form">
            <input type="text" name="productName" size="50" placeholder="Enter product name...">
            <button type="submit" class="btn submit">Search</button>
            <button type="reset" class="btn reset">Reset</button>
        </form>

        <%
        // Get product name to search for
        String name = request.getParameter("productName");
        
        // Load SQL Server driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }
        
        // Connection parameters
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
        String uid = "sa";
        String pw = "304#sa#pw";
        
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String SQL = "SELECT * FROM product WHERE productName LIKE ?";
            PreparedStatement pstmt = con.prepareStatement(SQL);
            
            // If no search term is provided, fetch all products
            if (name == null || name.trim().isEmpty()) {
                pstmt.setString(1, "%");
            } else {
                pstmt.setString(1, "%" + name + "%");
            }
            
            ResultSet rst = pstmt.executeQuery();
        %>
        
        <table class="product-table">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                // Display the filtered results in the table
                while (rst.next()) {
                    String productId = rst.getString("productId");
                    String productName = rst.getString("productName");
                    double productPrice = rst.getDouble("productPrice");
                    String productDesc = rst.getString("productDesc");
                    
                    String productPage = "product.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + "&desc=" + URLEncoder.encode(productDesc, "UTF-8");
                    String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
                %>
                <tr>
                    <td><a href="<%= productPage %>" class="product-link"><%= productName %></a></td>
                    <td>$<%= productPrice %></td>
                    <td><a href="<%= addToCartLink %>" class="add-to-cart">Add to cart</a></td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>
        
        <%
            con.close();
        } catch (SQLException ex) {
            out.println("SQLException: " + ex);
        }
        %>
    </div>
</body>
</html>
