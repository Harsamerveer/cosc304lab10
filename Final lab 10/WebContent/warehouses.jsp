<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Warehouses</title>
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
    <h1>Warehouse List</h1>
    <%
    // Connection parameters
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection conn = null;
    Statement stmt = null;
    ResultSet resultSet = null;

    try {
        // Load the SQL Server JDBC driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(url, uid, pw);
        stmt = conn.createStatement();

        // Query to fetch all warehouses
        String query = "SELECT warehouseId, warehouseName FROM warehouse";

        // Execute the query
        resultSet = stmt.executeQuery(query);
    %>
    <table>
        <tr>
            <th>Warehouse ID</th>
            <th>Warehouse Name</th>
        </tr>
        <%
            // Loop through the result set and display the data
            while (resultSet.next()) {
                int warehouseId = resultSet.getInt("warehouseId");
                String warehouseName = resultSet.getString("warehouseName");

                // Construct the dynamic link for each warehouse
                String warehouseLink = "warehouseDetails.jsp?id=" + warehouseId + "&name=" + URLEncoder.encode(warehouseName, "UTF-8");
        %>
        <tr>
            <td><%= warehouseId %></td>
            <td><a href="<%= warehouseLink %>"><%= warehouseName %></a></td>
        </tr>
        <%
            }
        %>
    </table>
    <%
    } catch (Exception e) {
        out.println("<p style='color:red; text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        // Close resources
        if (resultSet != null) try { resultSet.close(); } catch (SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
    %>
    <!-- Admin Dashboard Button -->
    <a href="admin.jsp" class="button">Admin Dashboard</a>
</body>
</html>
