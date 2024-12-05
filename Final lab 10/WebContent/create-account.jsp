<%@ page import="java.sql.*, java.io.*" %>
<%@ include file="jdbc.jsp" %>

<%


// Connection parameters
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=bookstore;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";



    // Declare variables to store form input values
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phoneNum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String userId = request.getParameter("userid");
    String password = request.getParameter("password");

    // If the form is submitted, process the data
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // Validate required fields
        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || userId.isEmpty() || password.isEmpty()) {
            out.println("<p style='color:red;'>All required fields must be filled out.</p>");
        } else {
            // Database connection
            try (Connection conn = DriverManager.getConnection(url, uid, pw);) {
           
                // Prepare SQL query for inserting a new customer
                String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, isAdmin) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    // Set the values for the SQL query parameters
                    ps.setString(1, firstName);
                    ps.setString(2, lastName);
                    ps.setString(3, email);
                    ps.setString(4, phoneNum);
                    ps.setString(5, address);
                    ps.setString(6, city);
                    ps.setString(7, state);
                    ps.setString(8, postalCode);
                    ps.setString(9, country);
                    ps.setString(10, userId);
                    ps.setString(11, password); // Note: Ideally, password should be hashed before storing it
                    ps.setInt(12, 0); // Set isAdmin to 0 (for customers)

                    // Execute the SQL query
                    int rowsAffected = ps.executeUpdate();

                    if (rowsAffected > 0) {
                        out.println("<p style='color:green;'>Account created successfully! Please <a href='login.jsp'>log in here</a>.</p>");
                    } else {
                        out.println("<p style='color:red;'>Failed to create account. Please try again.</p>");
                    }
                    
                } catch (SQLException e) {
                    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
                }
            } catch (SQLException e) {
                out.println("<p style='color:red;'>Connection error: " + e.getMessage() + "</p>");
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="create-account.css">
    <title>Create Account</title>
    <script>
        function validateForm() {
            let firstName = document.getElementById("firstName").value;
            if (firstName === "") {
                alert("First name is required");
                return false;
            }
            let lastName = document.getElementById("lastName").value;
            if (lastName === "") {
                alert("Last name is required");
                return false;
            }
            let email = document.getElementById("email").value;
            let emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
            if (!email.match(emailPattern)) {
                alert("Please enter a valid email address");
                return false;
            }
            let userId = document.getElementById("userid").value;
            if (userId === "") {
                alert("User ID is required");
                return false;
            }
            let password = document.getElementById("password").value;
            if (password === "") {
                alert("Password is required");
                return false;
            }
            let confirmPassword = document.getElementById("confirmPassword").value;
            if (confirmPassword !== password) {
                alert("Passwords do not match");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <h2>Create Account</h2>
    <form action="create-account.jsp" method="POST" onsubmit="return validateForm()">
        <label for="firstName">First Name:</label><br>
        <input type="text" id="firstName" name="firstName" required><br><br>

        <label for="lastName">Last Name:</label><br>
        <input type="text" id="lastName" name="lastName" required><br><br>

        <label for="email">Email:</label><br>
        <input type="email" id="email" name="email" required><br><br>

        <label for="phonenum">Phone Number (Optional):</label><br>
        <input type="text" id="phonenum" name="phonenum"><br><br>

        <label for="address">Address (Optional):</label><br>
        <input type="text" id="address" name="address"><br><br>

        <label for="city">City (Optional):</label><br>
        <input type="text" id="city" name="city"><br><br>

        <label for="state">State (Optional):</label><br>
        <input type="text" id="state" name="state"><br><br>

        <label for="postalCode">Postal Code (Optional):</label><br>
        <input type="text" id="postalCode" name="postalCode"><br><br>

        <label for="country">Country (Optional):</label><br>
        <input type="text" id="country" name="country"><br><br>

        <label for="userid">User ID:</label><br>
        <input type="text" id="userid" name="userid" required><br><br>

        <label for="password">Password:</label><br>
        <input type="password" id="password" name="password" required><br><br>

        <label for="confirmPassword">Confirm Password:</label><br>
        <input type="password" id="confirmPassword" name="confirmPassword" required><br><br>

        <button type="submit">Create Account</button>
    </form>
</body>
</html>
