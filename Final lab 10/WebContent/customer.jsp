<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>


<%
	String userName = (String) session.getAttribute("authenticatedUser");

// TODO: Print Customer information

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

String sql = "SELECT * FROM customer WHERE userid = ?";
PreparedStatement pstmt = con.prepareStatement(sql); 
pstmt.setString(1, userName);  

ResultSet rs = pstmt.executeQuery();
 if (rs.next()) {
        out.print("<table border='1'>");
  
       do {
            out.print("<!-- Customer Info Table Rows -->");
            out.print("<tr>");
            out.print("<th>Customer ID</th>");
            out.print("<td>" + rs.getInt("customerId") + "</td>");
            out.print("<tr>");
            out.print("<th>First Name</th>");
            out.print("<td>" + rs.getString("firstName") + "</td>");
            out.print("<tr>");
            out.print("<th>Last Name</th>");
            out.print("<td>" + rs.getString("lastName") + "</td>");
            out.print("<tr>");
            out.print("<th>Email</th>");
            out.print("<td>" + rs.getString("email") + "</td>");
            out.print("<tr>");
                out.print("<th>Phone Number</th>");
                
            out.print("<td>" + rs.getString("phonenum") + "</td>");
            out.print("<tr>");
                out.print("<th>Address</th>");

            out.print("<td>" + rs.getString("address") + "</td>");
            out.print("<tr>");
                out.print("<th>City</th>");

            out.print("<td>" + rs.getString("city") + "</td>");
            out.print("<tr>");
                out.print("<th>State</th>");

            out.print("<td>" + rs.getString("state") + "</td>");
            out.print("<tr>");
                out.print("<th>Postal Code</th>");

            out.print("<td>" + rs.getString("postalCode") + "</td>");
            out.print("<tr>");
                out.print("<th>Country</th>");

            out.print("<td>" + rs.getString("country") + "</td>");
            out.print("<tr>");
                out.print("<th>User ID</th>");

            out.print("<td>" + rs.getString("userid") + "</td>");
            out.print("<tr>");
                out.print("<th>Password</th>");

            out.print("<td>" + rs.getString("password") + "</td>");
            out.print("</tr>");
        } while (rs.next());
        out.print("</table>");
    } else {
        out.print("No customer information found for user.");
    }

    String sql2 = "SELECT * from ordersummary os join customer c on os.customerId = c.customerId WHERE userid = ?";
    String sql3 = "SELECT * from orderproduct op join product p on op.productId = p.productId WHERE orderId = ?";

    PreparedStatement pstmt2 = con.prepareStatement(sql2); 
    PreparedStatement pstmt3 = con.prepareStatement(sql3); 

    pstmt2.setString(1, userName);  
    
    ResultSet rs2 = pstmt2.executeQuery();

    out.print("<h1>List all my orders</h1>");
    if (rs2.next()) {
    do {
        out.print("<table border='1' style='margin-bottom: 50px;'>");
        out.print("<!-- All the Orders Table -->");
        out.print("<tr>");
        out.print("<th>Order Id</th>");
        out.print("<td>" + rs2.getInt("orderId") + "</td>");
        out.print("<tr>");
        out.print("<th>Order Date</th>");
        out.print("<td>" + rs2.getString("orderDate") + "</td>");
        out.print("<tr>");
        out.print("<th>Shipped to</th>");
        out.print("<td>" + rs2.getString("address") +"</td>");
        out.print("<tr>");
        
        // Retrieve products for the current order
        pstmt3.setInt(1, rs2.getInt("orderId"));
        ResultSet rs3 = pstmt3.executeQuery();

        out.print("<tr>");
        out.print("<th>Items</th>");
        out.print("<td>");

        boolean hasItems = false;
        while (rs3.next()) { // Iterate through the products for this order
            hasItems = true;
            out.print(rs3.getString("productName") + "<br>"); // List each product
        }
        if (!hasItems) {
            out.print("No items for this order.");
        }
        out.print("</td>");
        out.print("</tr>");
        out.print("</table>"); // Close the table for this order
    } while (rs2.next());
    } else {
    out.print("No orders found for user.");
    }
    out.print("</table>");

// Make sure to close connection
	rs.close();
	con.close();
} catch (SQLException ex) {
    ex.printStackTrace();
    out.println("SQLException: " + ex.getMessage());
} 
%>

</body>
</html>

