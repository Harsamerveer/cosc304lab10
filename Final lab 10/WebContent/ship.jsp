<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery Shipment Processing</title>
<style>
    body { font-family: Arial, sans-serif; }
    h2, h3 { color: purple; }
    table { border-collapse: collapse; width: 80%; margin: 20px auto; }
    table, th, td { border: 1px solid black; }
    th, td { padding: 10px; text-align: left; }
    .success { color: green; font-weight: bold; }
    .error { color: red; font-weight: bold; }
    .center { text-align: center; }
</style>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
String ordid = request.getParameter("orderId"); 
Connection con = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

if (ordid != null && !ordid.isEmpty()) {
    try {
        getConnection(); 
        con = this.con; 
        con.setAutoCommit(false);
        String retrieveItemsQuery = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
        pstmt = con.prepareStatement(retrieveItemsQuery, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        pstmt.setString(1, ordid);
        rs = pstmt.executeQuery();

        boolean sufficientInventory = true;
        StringBuilder shipmentDetails = new StringBuilder();
        shipmentDetails.append("<table><tr><th>Product ID</th><th>Ordered Quantity</th><th>Previous Inventory</th><th>New Inventory</th></tr>");
        
        while (rs.next()) {
            int productId = rs.getInt("productId");
            int orderQuantity = rs.getInt("quantity");
            String inventoryCheckQuery = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
            PreparedStatement checkStmt = con.prepareStatement(inventoryCheckQuery);
            checkStmt.setInt(1, productId);
            ResultSet rsi = checkStmt.executeQuery();

            if (rsi.next()) {
                int inventory = rsi.getInt("quantity");
                if (inventory < orderQuantity) {
                    sufficientInventory = false;
                    shipmentDetails.append("<tr><td>").append(productId)
                                   .append("</td><td>").append(orderQuantity)
                                   .append("</td><td>").append(inventory)
                                   .append("</td><td>Insufficient</td></tr>");
                } else {
                    int newInventory = inventory - orderQuantity;
                    shipmentDetails.append("<tr><td>").append(productId)
                                   .append("</td><td>").append(orderQuantity)
                                   .append("</td><td>").append(inventory)
                                   .append("</td><td>").append(newInventory)
                                   .append("</td></tr>");
                }
            } else {
                sufficientInventory = false;
                shipmentDetails.append("<tr><td>").append(productId)
                               .append("</td><td>").append(orderQuantity)
                               .append("</td><td>Not Found</td><td>Insufficient</td></tr>");
            }
            rsi.close();
            checkStmt.close();
        }

        shipmentDetails.append("</table>");
        
        if (!sufficientInventory) {
            con.rollback();
            out.println("<h3 class='error center'>Shipment not done. Insufficient inventory for one or more products.</h3>");
            out.println(shipmentDetails.toString());
        } else {
            
            String createShipmentQuery = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
            PreparedStatement shipmentStmt = con.prepareStatement(createShipmentQuery);
            shipmentStmt.setTimestamp(1, new java.sql.Timestamp(System.currentTimeMillis())); // Current date and time
            shipmentStmt.setString(2, "Order shipment for order ID " + ordid); // Example description
            shipmentStmt.setInt(3, 1); // Example: warehouseId = 1
            shipmentStmt.executeUpdate();
            shipmentStmt.close();

            
            rs.beforeFirst(); 
            while (rs.next()) {
                int productId = rs.getInt("productId");
                int orderQuantity = rs.getInt("quantity");

                String updateInventoryQuery = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
                PreparedStatement updateStmt = con.prepareStatement(updateInventoryQuery);
                updateStmt.setInt(1, orderQuantity);
                updateStmt.setInt(2, productId);
                updateStmt.executeUpdate();
                updateStmt.close();
            }

            
            con.commit();
            out.println("<h3 class='success center'>Shipment successfully processed.</h3>");
            out.println(shipmentDetails.toString());
			con.setAutoCommit(true);
        }
    } catch (SQLException e) {
        if (con != null) {
            try {
                con.rollback();
                out.println("<h3 class='error center'>Transaction rolled back due to error: " + e.getMessage() + "</h3>");
            } catch (SQLException se) {
                out.println("<h3 class='error center'>Error during rollback: " + se.getMessage() + "</h3>");
            }
        }
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            closeConnection(); // Close the connection
        } catch (SQLException e) {
            out.println("<h3 class='error center'>Error closing resources: " + e.getMessage() + "</h3>");
        }
    }
} else {
    out.println("<h3 class='error center'>Order ID is required.</h3>");
}
%>

<h2 class="center"><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
