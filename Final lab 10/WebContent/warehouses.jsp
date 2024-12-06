<%@ page import="java.sql.*" %>
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
        %>
        <tr>
            <td><%= resultSet.getInt("warehouseId") %></td>
            <td><%= resultSet.getString("warehouseName") %></td>
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
</body>
</html>
