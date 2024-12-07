<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Order Summary</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 0;
        color: #333;
    }
    h2 {
        color: #2c3e50;
        text-align: center;
    }
    table {
        width: 80%;
        margin: 0 auto;
        border-collapse: collapse;
        margin-top: 20px;
        background-color: #ffffff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    th, td {
        padding: 12px;
        border: 1px solid #ddd;
        text-align: left;
    }
    th {
        background-color: #2c3e50;
        color: #fff;
    }
    td {
        background-color: #f9f9f9;
    }
    td.align-right {
        text-align: right;
    }
    .order-total {
        font-weight: bold;
        background-color: #f0f0f0;
    }
    .error {
        color: red;
        font-size: 16px;
        text-align: center;
        margin-top: 20px;
    }
</style>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
if (custId == null || custId.isEmpty()) {
	out.println("Invalid Customer Id");
} else {
	try {
		Integer.parseInt(custId); // Try to parse the string as an integer
	} catch (NumberFormatException e) {
		out.println(custId + " is not a valid integer.");
		return; // Exit if invalid customer ID
	}
	// Determine if there are products in the shopping cart
	if (productList == null || productList.isEmpty()) {
		out.println("<H1>Your shopping cart is empty!</H1>");
		return; // Exit if cart is empty
	}

// Make connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";


String sql = "INSERT INTO ordersummary (customerId, orderDate) VALUES (?, ?)";


try (Connection connection = DriverManager.getConnection(url,uid,pw);
     PreparedStatement pstmt = connection.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)) {
		
		String sqlc = "select * from customer";
		int countcustomerid = 0;
		Statement pstmt4 = connection.createStatement();
		ResultSet rst4 = pstmt4.executeQuery(sqlc);
		
		while (rst4.next()) {
			 int cidcount = rst4.getInt("customerId");
			 countcustomerid++;
		}
		
	
			int custidint = Integer.parseInt(custId);
			
			if (custidint > countcustomerid) {
				out.println("Invalid customerId, Please try again");
				return;
			}
		

	// Set parameters
	pstmt.setString(1, custId);
	pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis())); // Use current time
    
	int rowsAffected = pstmt.executeUpdate();
    if (rowsAffected == 0) {
        throw new SQLException("Creating order failed, no rows affected.");
    }

	ResultSet keys = pstmt.getGeneratedKeys();
	if (keys.next()) {
		int orderId = keys.getInt(1);

		// Insert each item into OrderProduct table using OrderId from previous INSERT
		String insertItemSql = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
		PreparedStatement pstmt1 = connection.prepareStatement(insertItemSql);

		pstmt1.setInt(1,orderId);

		double total = 0;

		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
				double subtotal = pr * qty;
				total += subtotal;

				pstmt1.setString(2,productId);
				pstmt1.setInt(3,qty);
				pstmt1.setString(4,price);

				rowsAffected = pstmt1.executeUpdate();
				if (rowsAffected == 0) {
					throw new SQLException("Creating order failed, no rows affected.");
				}

			}

			// Update total amount for order record

			String updatetotalamount = "UPDATE ordersummary SET totalAmount = ? where orderId = ?";
			PreparedStatement pstmt2 = connection.prepareStatement(updatetotalamount);
			pstmt2.setDouble(1,total);
			pstmt2.setInt(2,orderId);


			rowsAffected = pstmt2.executeUpdate();
			if (rowsAffected == 0) {
				throw new SQLException("Creating order failed, no rows affected.");
			}

			// Create Ordered table
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();
				out.print("<h2>Order Details:</h2>");
				out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
				out.println("<th>Price</th><th>Subtotal</th></tr>");

				double dtotal =0;
				Iterator<Map.Entry<String, ArrayList<Object>>> diterator = productList.entrySet().iterator();
				while (diterator.hasNext()) 
				{	Map.Entry<String, ArrayList<Object>> entry = diterator.next();
					ArrayList<Object> dproduct = (ArrayList<Object>) entry.getValue();
					
					out.print("<tr><td>"+dproduct.get(0)+"</td>");
					out.print("<td>"+dproduct.get(1)+"</td>");

					out.print("<td align=\"center\">"+dproduct.get(3)+"</td>");
					Object dprice = dproduct.get(2);
					Object ditemqty = dproduct.get(3);
					double dpr = 0;
					int dqty = 0;
					
					try
					{
						dpr = Double.parseDouble(dprice.toString());
					}
					catch (Exception e)
					{
						out.println("Invalid price for product: "+dproduct.get(0)+" price: "+dprice);
					}
					try
					{
						dqty = Integer.parseInt(ditemqty.toString());
					}
					catch (Exception e)
					{
						out.println("Invalid quantity for product: "+dproduct.get(0)+" quantity: "+dqty);
					}		

					out.print("<td align=\"right\">"+currFormat.format(dpr)+"</td>");
					out.print("<td align=\"right\">"+currFormat.format(dpr*dqty)+"</td></tr>");
					out.println("</tr>");
					dtotal = dtotal +dpr*dqty;
				}
				out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
						+"<td align=\"right\">"+currFormat.format(dtotal)+"</td></tr>");
				out.println("</table>");

				String getcustomerinfo = "select * from customer where customerId = ?";
				PreparedStatement pstmt3 = connection.prepareStatement(getcustomerinfo);
				pstmt3.setString(1,custId);
				ResultSet rst3 = pstmt3.executeQuery();
				while (rst3.next()) {
					String firstname = rst3.getString("firstName");
					String lastname = rst3.getString("lastname");
					out.print("<h2>Your order is ready to pick up, " + firstname + " " + lastname + ".</h2>");
				}

		// Clear cart if order placed successfully
		session.removeAttribute("productList");
		session.removeAttribute("custId");
	} else {
		throw new SQLException("Creating order failed, no ID obtained.");
	}
} catch (SQLException ex) {
	out.println("SQLException: " + ex.getMessage());
}
}
%>
</BODY>
</HTML>




