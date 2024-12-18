<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="index.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <title>Customer List</title>
    <style>
     

            h1 {
                text-align: center;
                padding: 20px;
                margin: 30px;
                color: rgb(205, 129, 129);
                border-radius: 10px;
                box-sizing: border-box;
            }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
            text-align: left;
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
    <h1>Customer List</h1>
    <table>
        <thead>
            <tr>
                <th>Customer ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Address</th>
                <th>City</th>
                <th>State</th>
                <th>Postal Code</th>
                <th>Country</th>
            </tr>
        </thead>
        <tbody>
            <%
            // Connection parameters
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
            String uid = "sa";
            String pw = "304#sa#pw";

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Load the SQL Server JDBC driver
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                conn = DriverManager.getConnection(url, uid, pw);
                stmt = conn.createStatement();
                String sql = "SELECT * FROM customer";
                rs = stmt.executeQuery(sql);

                // Loop through the result set and display data
                while (rs.next()) {
            %>
                    <tr>
                        <td><%= rs.getInt("customerId") %></td>
                        <td><%= rs.getString("firstName") %></td>
                        <td><%= rs.getString("lastName") %></td>
                        <td><%= rs.getString("email") %></td>
                        <td><%= rs.getString("phonenum") %></td>
                        <td><%= rs.getString("address") %></td>
                        <td><%= rs.getString("city") %></td>
                        <td><%= rs.getString("state") %></td>
                        <td><%= rs.getString("postalCode") %></td>
                        <td><%= rs.getString("country") %></td>
                    </tr>
            <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            %>
                <tr>
                    <td colspan="10">Error fetching customer data: <%= e.getMessage() %></td>
                </tr>
            <%
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            %>
        </tbody>
    </table>
    <!-- Admin Dashboard Button -->
	<a href="admin.jsp" class="button">Admin Dashboard</a>
   
</body>
</html>
