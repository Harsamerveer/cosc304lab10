<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    // Declare variables to hold username, password, and the result string
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String retStr = null;

    // Validate username and password
    if (username == null || password == null || username.length() == 0 || password.length() == 0) {
        retStr = "Username and password must not be empty.";
    } else {
     

        try 
		{
			getConnection();
			
			// TODO: Check if userId and password match some customer account. If so, set retStr to be the username.
			
				String sql = "SELECT userid, password FROM customer WHERE userid = ? ";
				PreparedStatement pstmt = con.prepareStatement(sql);  // Correct method for preparing a statement
				pstmt.setString(1, username);  // Ensure "username" matches the parameter type for userId
				ResultSet rs = pstmt.executeQuery();
				out.println("Input Username: "+username);
                out.println("Input Password: "+password);
				while (rs.next()) {
					String usernamefromdatabase = rs.getString(1);
					String passwordfromdatabase =  rs.getString(2);
					
					out.println(" usernamefromdatabase:  "+ usernamefromdatabase + " passwordfromdatabase: "+ passwordfromdatabase);

					if(password.equals(passwordfromdatabase)){
						retStr = usernamefromdatabase;
						out.print(retStr);
						break;
					}
				}
						
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
</head>
<body>
    <h1>Login Page</h1>
    <form name="MyForm" method="post" action="testlogin.jsp">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br>
        <input type="submit" value="Login">
    </form>

    <div>
        <h2>Result:</h2>
        <p><%= retStr != null ? retStr : "" %></p>
    </div>
</body>
</html>