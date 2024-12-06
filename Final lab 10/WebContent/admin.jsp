<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link rel="stylesheet" href="admin.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        
        /* Styling for table and canvas for better layout */
        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th, table td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }

        canvas {
            display: block;
            width: 500px;
            height: 500px;
            margin: 20px auto;
        }
    </style>
</head>
<body>
<div>
    <main>
        <section>
            <h2>Welcome to the Admin Portal</h2>
            <p>Select an option from the menu to manage customers, products, or warehouses.</p>
        </section>
    </main>
    <nav>
    <ul>
        <li><a href="customers.jsp">View Customers</a></li>
        <li><a href="addupdatecustomer.jsp?action=add">Add Customer</a></li>
        <li><a href="javascript:void(0);" onclick="promptForCustomerId()">Update Customer</a></li>
        <li><a href="viewbooks.jsp">View Books</a></li>
        <li><a href="addupdateproduct.jsp?action=add">Add Book</a></li>
        <li><a href="javascript:void(0);" onclick="promptForProductId()">Update Book</a></li> 
        <li><a href="warehouses.jsp">View Warehouses</a></li>
        <li><a href="addupdatewarehouse.jsp?action=add">Add Warehouse</a></li>
        <li><a href="javascript:void(0);" onclick="promptForWarehouseId()">Update Warehouse</a></li>
        <li><a href="loaddata.jsp">Database Restore </a></li>
    </ul>
    <script>
       function promptForProductId() {
            // Ask the admin for the productId
            var productId = prompt("Please enter the Book ID to update:");
    
            // If a productId is provided, redirect to the update page with the productId
            if (productId) {
                window.location.href = "addupdateproduct.jsp?action=update&productId=" + productId;
            }
        } 

        function promptForCustomerId() {
            // Ask the admin for the customerId
            var customerId = prompt("Please enter the Customer ID to update:");
    
            // If a customerId is provided, redirect to the update page with the customerId
            if (customerId) {
                window.location.href = "addupdatecustomer.jsp?action=update&customerId=" + customerId;
            }
        }
        function promptForWarehouseId() {
            var warehouseId = prompt("Please enter the Warehouse ID to update:");
            if (warehouseId) {
                window.location.href = "addupdatewarehouse.jsp?action=update&warehouseId=" + warehouseId;
            }
        }
    </script></nav>
<hr>

<h2>Daily Sales Report</h2>

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

    StringBuilder labels = new StringBuilder();
    StringBuilder data = new StringBuilder();

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement()) {

        String sql = "SELECT CAST(orderDate AS DATE) AS order_day, SUM(totalAmount) AS total_amount " +
                     "FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY order_day;";

        PreparedStatement pstmt = con.prepareStatement(sql);
        ResultSet rs = pstmt.executeQuery();

        out.print("<table border='1'>");
        out.print("<tr><th>Order Day</th><th>Total Amount</th></tr>");

        while (rs.next()) {
            Date orderDay = rs.getDate("order_day");
            String totalAmount = rs.getString("total_amount");

            labels.append("'").append(orderDay).append("',");
            data.append(totalAmount).append(",");

            out.print("<tr>");
            out.print("<td>" + orderDay + "</td>");
            out.print("<td>" + totalAmount + "</td>");
            out.print("</tr>");
        }

        out.print("</table>");
        rs.close();
        pstmt.close();
    } catch (SQLException e) {
        out.print("Error: " + e.getMessage());
    }
%>

<!-- Add a canvas element for the chart -->
<h2>Sales Chart</h2>    
<canvas id="salesChart" ></canvas>
</div>
<script>
    const ctx = document.getElementById('salesChart').getContext('2d');
    const salesChart = new Chart(ctx, {
        type: 'line', // Chart type (e.g., line, bar, pie)
        data: {
            labels: [<%= labels.toString().isEmpty() ? "" : labels.substring(0, labels.length() - 1) %>],
            datasets: [{
                label: 'Sales Report',
                data: [<%= data.toString().isEmpty() ? "" : data.substring(0, data.length() - 1) %>],
                borderColor: 'rgba(75, 192, 192, 1)',
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                borderWidth: 2
            }]
        },
        options: {
            scales: {
                x: { title: { display: true, text: 'Order Day' } },
                y: { title: { display: true, text: 'Total Amount' } }
            }
        }
    });
</script>

</body>
</html>
