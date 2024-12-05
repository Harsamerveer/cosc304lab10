<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
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
<h1>Administrator Dashboard</h1>
<nav>
    <a href="customers.jsp">View Customers</a>
</nav>
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
