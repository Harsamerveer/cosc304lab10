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
        <!-- First Name and Last Name -->
        <div class="form-row">
            <div>
                <label for="firstName">First Name <span style="color: red;">*</span></label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div>
                <label for="lastName">Last Name <span style="color: red;">*</span></label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
        </div>
    
        <!-- Email -->
        <div class="form-row full-width">
            <label for="email">Email <span style="color: red;">*</span></label>
            <input type="email" id="email" name="email" required>
        </div>
    
        <!-- Phone Number -->
        <div class="form-row full-width">
            <label for="phonenum">Phone Number (optional) <span style="color: red;">*</span></label>
            <input type="text" id="phonenum" name="phonenum">
        </div>
    
        <!-- Country and City -->
        <div class="form-row">
            <div>
                <label for="country">Country <span style="color: red;">*</span></label>
                <input type="text" id="country" name="country" required>
            </div>
            <div>
                <label for="city">City <span style="color: red;">*</span></label>
                <input type="text" id="city" name="city" required>
            </div>
        </div>
    
        <!-- Address and Postal Code -->
        <div class="form-row">
            <div>
                <label for="address">Address <span style="color: red;">*</span></label>
                <input type="text" id="address" name="address" required>
            </div>
            <div>
                <label for="postalCode">Postal Code <span style="color: red;">*</span></label>
                <input type="text" id="postalCode" name="postalCode" required>
            </div>
        </div>
    
        <!-- User ID -->
        <div class="form-row full-width">
            <label for="userid">User ID <span style="color: red;">*</span></label>
            <input type="text" id="userid" name="userid" required>
        </div>
    
        <!-- Password -->
        <div class="form-row full-width">
            <label for="password">Password <span style="color: red;">*</span></label>
            <input type="password" id="password" name="password" required>
        </div>
    
        <!-- Confirm Password -->
        <div class="form-row full-width">
            <label for="confirmPassword">Confirm Password <span style="color: red;">*</span></label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
    
        <!-- Submit Button -->
        <button type="submit">Create Account</button>
    </form>
    
</body>
</html>
