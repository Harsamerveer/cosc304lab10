
<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="viewbooks.css">
    <title>Product Search</title>
</head>
<body>

    <h1>Search for the products you want to remove:</h1>


	<form method="get" action="viewbooks.jsp">
		<input type="text" name="productName" size="50">
		<input type="submit" value="Submit"><input type="reset" value="Reset"> 
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
		// Database connection parameters
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw";
	
		// Try-with-resources to manage database connection automatically
		try (Connection con = DriverManager.getConnection(url, uid, pw)) {
			String SQL = "SELECT p.productId, p.productName, p.productPrice, p.productDesc, c.categoryId, c.categoryName "
					   + "FROM product p "
					   + "JOIN category c ON p.categoryId = c.categoryId "
					   + "WHERE p.productName LIKE ?";
			PreparedStatement pstmt = con.prepareStatement(SQL);
	
			// If no search term is provided, fetch all products
			if (name == null || name.trim().isEmpty()) {
				pstmt.setString(1, "%");  // Use wildcard to select all products
			} else {
				pstmt.setString(1, "%" + name + "%");  // Filter by the provided name
			}
	
			ResultSet rst = pstmt.executeQuery();
	%>
	
	<!-- Display results in a table -->
	<table border="2">
		<tr>
			<th>Product Name</th>
			<th>Price</th>
			<th>Category Name</th>
		</tr>
		<%
			// Display the results in the table
			while (rst.next()) {
				String productId = rst.getString("productId");
				String productName = rst.getString("productName");
				double productPrice = rst.getDouble("productPrice");
				String productDesc = rst.getString("productDesc");
				int categoryId = rst.getInt("categoryId");
				String categoryName = rst.getString("categoryName");

				// Create the URL for deleting the product
				String deleteUrl = "deleteproduct.jsp?productId=" + productId;
				
		%>
		<tr>
			<td><%= productName %></a></td>
			<td>$<%= productPrice %></td>
			<td><%= categoryName %></td>
			<td><a href="<%= deleteUrl %>" onclick="return confirm('Are you sure you want to delete this product?');">Delete</a></td>

		</tr>
		<%
			}
		%>
	</table>
	
	<%
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	
	<!-- Admin Dashboard Button -->
	<a href="admin.jsp" class="button">Admin Dashboard</a>
   
	</body>
	</html>