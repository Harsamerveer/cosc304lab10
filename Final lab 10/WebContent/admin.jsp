<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
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

    // SQL query to calculate total order amount by day and retrieve the actual orderDate (TIMESTAMP)
    String sql = "SELECT CAST(orderDate AS DATE) AS order_day, SUM(totalAmount) AS total_amount " +
                 "FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY order_day;";

    PreparedStatement pstmt = con.prepareStatement(sql);
    ResultSet rs = pstmt.executeQuery();

    out.print("<table border='1'>");
    out.print("<tr><th>Order Day</th><th>Total Amount</th></tr>");

    while (rs.next()) {
        // Retrieve the TIMESTAMP for the order day
        Date orderDay = rs.getDate("order_day");  // This is a DATE, which should hold the 'yyyy-MM-dd' format
        String totalAmount = rs.getString("total_amount");

        out.print("<tr>");
        out.print("<td>" + orderDay + "</td>");  // Display the date
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

</body>
</html>