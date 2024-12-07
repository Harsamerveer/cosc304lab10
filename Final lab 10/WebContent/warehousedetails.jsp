<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>Warehouse Details</title>
    <style>
        table {
            border-collapse: collapse;
            width: 50%;
            margin: 20px auto;
            font-family: Arial, sans-serif;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        h1 {
            text-align: center;
            font-family: Arial, sans-serif;
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
            margin: 20px;
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

    <h1>Warehouse Details</h1>
    
<%
// Retrieve the warehouseId and name from the URL query parameter and convert it to an integer
int warehouseId = Integer.parseInt(request.getParameter("id"));
String warehouseName = request.getParameter("name");

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
     PreparedStatement pstmt = con.prepareStatement("SELECT * FROM warehouse W JOIN productinventory PI ON W.warehouseId = PI.warehouseId JOIN product P ON PI.productId = P.productId WHERE W.warehouseId = ?")) {

    pstmt.setInt(1, warehouseId);  // Set warehouseId parameter
    ResultSet rs = pstmt.executeQuery();
    
    %>
    <table>
        <tr>
            <th>Product Id</th>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price</th>
        </tr>
        <%
       out.println("<p style='text-align: center;'><strong>Warehouse Name:</strong> " + warehouseName + "</p>");

    while (rs.next()) {
        String productId = rs.getString("productId");
        String quantity = rs.getString("quantity");
        String price = rs.getString("price");
        String productName = rs.getString("productName");
        
        %>

        <tr>
            <td><%= productId %></td>
            <td><%= productName %></td>
            <td><%= quantity %></td>
            <td>$<%= price %></td>
        </tr>

        <%
    }

    rs.close();
    con.close();
} catch (SQLException ex) {
    ex.printStackTrace();
    out.println("SQLException: " + ex.getMessage());
} 

%>
<!-- Admin Dashboard Button -->
<a href="admin.jsp" class="button">Admin Dashboard</a>
</body>
</html>
