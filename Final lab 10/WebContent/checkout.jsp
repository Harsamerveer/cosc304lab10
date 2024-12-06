<%@ page language="java" import="java.io.*, java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout</title>
    <link rel="stylesheet" type="text/css" href="checkout.css">
</head>
<body>
    <div class="checkout-container">

    <form method="post" action="order.jsp">
        <%
            String authenticatedUser = (String) session.getAttribute("authenticatedUser");
            if (authenticatedUser != null) {
                // Assuming the customerId and other fields will be retrieved using the username (authenticatedUser)
                String customerId = null;
                String firstName = null;
                String lastName = null;
                String email = null;
                String phonenum = null;
                String address = null;
                String city = null;
                String state = null;
                String postalCode = null;
                String country = null;

                // Database connection and query to retrieve customer info
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";       
                    String uid = "sa";
                    String pw = "304#sa#pw";
                    
                    conn = DriverManager.getConnection(url, uid, pw);
                  

                    String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country FROM customer WHERE userid = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, authenticatedUser);
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        customerId = rs.getString("customerId");
                        firstName = rs.getString("firstName");
                        lastName = rs.getString("lastName");
                        email = rs.getString("email");
                        phonenum = rs.getString("phonenum");
                        address = rs.getString("address");
                        city = rs.getString("city");
                        state = rs.getString("state");
                        postalCode = rs.getString("postalCode");
                        country = rs.getString("country");

                        if (customerId != null) {
        %>            
        <div class="checkout-container">
            <form method="post" action="order.jsp">
                <div class="window">
                    <h3>Checkout - Customer Information</h3>
                    <div class="popup-container">
                        <div class="popup-content">
                        <table>
                            <tr>
                                <th>Customer ID</th>
                                <td><input type="text" name="customerId" value="<%= customerId %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>First Name</th>
                                <td><input type="text" name="firstName" value="<%= firstName %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>Last Name</th>
                                <td><input type="text" name="lastName" value="<%= lastName %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>Email</th>
                                <td><input type="email" name="email" value="<%= email %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>Phone Number</th>
                                <td><input type="text" name="phonenum" value="<%= phonenum %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>Address</th>
                                <td><input type="text" name="address" value="<%= address %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>City</th>
                                <td><input type="text" name="city" value="<%= city %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>State</th>
                                <td><input type="text" name="state" value="<%= state %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>Postal Code</th>
                                <td><input type="text" name="postalCode" value="<%= postalCode %>" readonly /></td>
                            </tr>
                            <tr>
                                <th>Country</th>
                                <td><input type="text" name="country" value="<%= country %>" readonly /></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>

            <div class="window">
                <h3>Checkout - Billing Information</h3>
                    <div class="popup-container">
                        <div class="popup-content">
                            <table>
                                <tr>
                                    <th>Address</th>
                                    <td><input type="text" name="address" value="<%= address %>" readonly /></td>
                                </tr>
                                <tr>
                                    <th>City</th>
                                    <td><input type="text" name="city" value="<%= city %>" readonly /></td>
                                </tr>
                                <tr>
                                    <th>State</th>
                                    <td><input type="text" name="state" value="<%= state %>" readonly /></td>
                                </tr>
                                <tr>
                                    <th>Postal Code</th>
                                    <td><input type="text" name="postalCode" value="<%= postalCode %>" readonly /></td>
                                </tr>
                                <tr>
                                    <th>Country</th>
                                    <td><input type="text" name="country" value="<%= country %>" readonly /></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                        <div class="window shipping-payment">
                            <h4>Shipping Address</h4>
                            <label for="shiptoAddress">Address</label>
                            <input type="text" name="shiptoAddress" required /><br>
                            
                            <label for="shiptoCity">City</label>
                            <input type="text" name="shiptoCity" required /><br>
                            
                            <label for="shiptoState">State</label>
                            <input type="text" name="shiptoState" required /><br>
                            
                            <label for="shiptoPostalCode">Postal Code</label>
                            <input type="text" name="shiptoPostalCode" required /><br>
                            
                            <label for="shiptoCountry">Country</label>
                            <input type="text" name="shiptoCountry" required /><br>
                       
                            <h4>Payment Information</h4>
                            <label for="paymentType">Payment Type</label>
                            <select name="paymentType" required>
                                <option value="Credit Card">Credit Card</option>
                                <option value="Debit Card">Debit Card</option>
                                <option value="PayPal">PayPal</option>
                                <!-- Add more payment types as needed -->
                            </select><br>
                            
                            <label for="paymentNumber">Card Number</label>
                            <input type="text" name="paymentNumber" required /><br>
                            
                            <label for="paymentExpiryDate">Expiry Date (MM/YYYY)</label>
                            <input type="month" name="paymentExpiryDate" required /><br>
                        </div>
                        <br>
                        <input type="submit" value="Submit Checkout" />

        <%
                        } else {
                            out.println("Customer ID not found.<br>");
                        }
                    } else {
                        out.println("No data returned from the database.<br>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("Error: " + e.getMessage() + "<br>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            } else {
                out.println("User is not authenticated.<br>");
            }
        %>
    </form>
</body>
</html>
