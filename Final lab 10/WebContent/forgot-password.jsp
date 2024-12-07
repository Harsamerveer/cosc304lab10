<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*, java.io.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <style>
        /* Reset some default styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        .message {
            text-align: center;
            margin-top: 20px;
            color: #28a745;
        }

        .error {
            text-align: center;
            margin-top: 20px;
            color: #dc3545;
        }

        .form-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #888;
        }

        .form-footer a {
            color: #007bff;
            text-decoration: none;
        }

        .form-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Forgot Password</h2>
        <form action="forgot-password.jsp" method="post">
            <label for="email">Enter your email:</label>
            <input type="email" name="email" id="email" required placeholder="Email address">
            <button type="submit">Submit</button>
        </form>

        <!-- Success/Error Messages -->
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String email = request.getParameter("email");

                if (email == null || email.isEmpty()) {
                    out.println("<div class='error'>Email is required.</div>");
                } else {
                    // Make connection
                    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
                    String uid = "sa";
                    String pw = "304#sa#pw";
                    
                    try (Connection connection = DriverManager.getConnection(url, uid, pw)) {
                        String query = "SELECT * FROM customer WHERE email=?";
                        try (PreparedStatement stmt = connection.prepareStatement(query)) {
                            stmt.setString(1, email);
                            ResultSet rs = stmt.executeQuery();

                            if (rs.next()) {
                                out.println("<div class='message'>Email found. Please check your inbox for password reset instructions.</div>");
                            } else {
                                out.println("<div class='error'>Email not found.</div>");
                            }
                        } catch (SQLException e) {
                            out.println("<div class='error'>Error executing query: " + e.getMessage() + "</div>");
                        }
                    } catch (SQLException e) {
                        out.println("<div class='error'>Database connection error: " + e.getMessage() + "</div>");
                    }
                }
            }
        %>

        <div class="form-footer">
            <p>Remember your password? <a href="login.jsp">Login here</a></p>
        </div>
    </div>
</body>
</html>
