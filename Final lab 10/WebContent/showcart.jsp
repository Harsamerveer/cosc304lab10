<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ include file="auth.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
	<link rel="stylesheet" type="text/css" href="showcart.css">
</head>
<body>

<%
    // Get the current list of products
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    if (productList == null) {
        out.println("<H1>Your shopping cart is empty!</H1>");
        productList = new HashMap<>();
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        // Database connection setup
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
			String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
			String uid = "sa";
			String pw = "304#sa#pw";
			
			conn = DriverManager.getConnection(url,uid,pw);

            // Handle Update/Delete requests
            String action = request.getParameter("action");
            String productId = request.getParameter("productId");
            String quantity = request.getParameter("quantity");

			if ("update".equalsIgnoreCase(action) && productId != null) {
				if (productList.containsKey(productId)) {
					ArrayList<Object> product = productList.get(productId);
					if (product != null) {
						int currentQuantity = (int) product.get(3); // Get current quantity
			
						// Increment the quantity by 1
						product.set(3, currentQuantity + 1);
			
						// Update the quantity in the database by incrementing it by 1
						String updateSQL = "UPDATE productinventory SET quantity = quantity + 1 WHERE productId = ?";
						stmt = conn.prepareStatement(updateSQL);
						stmt.setInt(1, Integer.parseInt(productId));
						int rowsUpdated = stmt.executeUpdate();
						session.setAttribute("productList", productList); // Save updated session
						
					} else {
						out.println("<p style='color:red;'>Product not found in the cart.</p>");
					}
				} else {
					out.println("<p style='color:red;'>Product not found in the cart.</p>");
				}
			
		}
		else if ("delete".equalsIgnoreCase(action) && productId != null) {
   		 if (productList.containsKey(productId)) {
      	  ArrayList<Object> product = productList.get(productId);
        	if (product != null) {
            int currentQuantity = (int) product.get(3); // Get current quantity

            if (currentQuantity > 1) {
                // Reduce quantity by 1 and update in session
                product.set(3, currentQuantity - 1);

                // Update the database to reduce the quantity by 1
                String updateSQL = "UPDATE productinventory SET quantity = quantity - 1 WHERE productId = ?";
                stmt = conn.prepareStatement(updateSQL);
                stmt.setInt(1, Integer.parseInt(productId));
                int rowsUpdated = stmt.executeUpdate();
				session.setAttribute("productList", productList); // Save updated session
                
            } else {
                // If quantity is 1, delete the product from cart and database
                String deleteSQL = "DELETE FROM productinventory WHERE productId = ?";
                stmt = conn.prepareStatement(deleteSQL);
                stmt.setInt(1, Integer.parseInt(productId));
                int rowsDeleted = stmt.executeUpdate();

                if (rowsDeleted > 0) {
                    productList.remove(productId); // Remove from cart if quantity is 0
                    session.setAttribute("productList", productList); // Save updated session
                    out.println("<p style='color:green;'>Product removed from cart and database successfully!</p>");
							} else {
								out.println("<p style='color:red;'>Failed to delete product from the database.</p>");
							}
						}
					} else {
						out.println("<p style='color:red;'>Product not found in the cart.</p>");
					}
				} else {
					out.println("<p style='color:red;'>Product not found in the cart.</p>");
				}
			}
						
			out.println("<h1>Your Shopping Cart</h1>");
            out.print("<table border=\"1\"><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
            out.println("<th>Price</th><th>Subtotal</th><th>Actions</th></tr>");

            double total = 0;
            Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
            while (iterator.hasNext()) {
                Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                ArrayList<Object> product = entry.getValue();
                if (product.size() < 4) {
                    out.println("Expected product with four entries. Got: " + product);
                    continue;
                }

                String id = product.get(0).toString();
                String name = product.get(1).toString();
                double price = Double.parseDouble(product.get(2).toString());
                int qty = Integer.parseInt(product.get(3).toString());
                double subtotal = price * qty;

                out.print("<tr>");
                out.print("<td>" + id + "</td>");
                out.print("<td>" + name + "</td>");
                out.print("<td align=\"center\">" + qty + "</td>");
                out.print("<td align=\"right\">" + currFormat.format(price) + "</td>");
                out.print("<td align=\"right\">" + currFormat.format(subtotal) + "</td>");
                total += subtotal;

                // Update and Delete forms
                out.print("<td>");
                out.print("<form action=\"showcart.jsp\" method=\"POST\" style=\"display:inline;\">");
                out.print("<input type=\"hidden\" name=\"action\" value=\"update\">");
                out.print("<input type=\"hidden\" name=\"productId\" value=\"" + id + "\">");
                out.print("<input type=\"number\" name=\"quantity\" value=\"" + qty + "\" min=\"1\">");
                out.print("<button type=\"submit\">Update</button>");
                out.print("</form>");
                out.print("<form action=\"showcart.jsp\" method=\"POST\" style=\"display:inline;\">");
                out.print("<input type=\"hidden\" name=\"action\" value=\"delete\">");
                out.print("<input type=\"hidden\" name=\"productId\" value=\"" + id + "\">");
                out.print("<button type=\"submit\">Delete</button>");
                out.print("</form>");
                out.print("</td>");
                out.print("</tr>");
            }

            out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
                    + "<td align=\"right\">" + currFormat.format(total) + "</td><td></td></tr>");
            out.println("</table>");

            out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>