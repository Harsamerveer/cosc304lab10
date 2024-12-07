<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Harsamerveer Singh Grocery Order List</title>
<link rel="stylesheet" href="index.css">
</head>
<body>
    <%@ include file="header.jsp" %>


<h1>Order List</h1>

<%
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

    // Write query to retrieve all order summary records
    ResultSet rst = stmt.executeQuery("SELECT * from ordersummary os join customer c on os.customerId = c.customerId;");

    while (rst.next()) {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        String oId = rst.getString("orderId");
        String customerId = rst.getString("customerId");
        String firstName = rst.getString("firstName");
        String lastName = rst.getString("lastName");
        String orderDate = rst.getString("orderDate");
        String totalAmount = currFormat.format(rst.getDouble("totalAmount"));
      
        %>
        <div>
            <table border="1">
                <tr>
                    <th>Order Id</th>    
                    <th>Order Date</th>
                    <th>Customer Id</th>
                    <th>Customer Name</th>
                    <th>Total Amount</th>
                </tr>
                <tr>
                    <td><%= oId %></td>
                    <td><%= orderDate %></td>
                    <td><%= customerId %></td>
                    <td><%= firstName %> <%= lastName %></td>
                    <td><%= totalAmount %></td>
                </tr>
                <br><br>
                <tr>
                    <th>Product Id</th>
                    <th>Quantity</th>
                    <th>Price</th>
                </tr>
                <%
                String productQuery = "SELECT op.productId, op.quantity, op.price FROM orderproduct op WHERE orderId = ?";
                PreparedStatement productsStmt = con.prepareStatement(productQuery);
                productsStmt.setString(1, oId);
                ResultSet productsResultSet = productsStmt.executeQuery();

                while (productsResultSet.next()) {
                    String productId = productsResultSet.getString("productId");
                    String quantity = productsResultSet.getString("quantity");
                    String price = currFormat.format(productsResultSet.getDouble("price"));
                %>
                <tr>
                    <td><%= productId %></td>
                    <td><%= quantity %></td>
                    <td><%= price %></td>
                </tr>
                <%
                }
                productsResultSet.close();
                productsStmt.close();
                %>
            </table>
        </div>
        <%
    }
} catch (SQLException ex) {
    ex.printStackTrace();
    out.println("SQLException: " + ex.getMessage());
} 
%>


</body>
</html>

