<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>   
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <link rel="stylesheet" href="index.css">
   <title>Mondo Books</title>

    <!-- CSS to limit image size -->
    <style>
        img.product-image {
            max-width: 300px; /* Max width for the image */
            max-height: 300px; /* Max height for the image */
            width: auto;
            height: auto;
            object-fit: contain; /* Maintains aspect ratio */
        }
    </style>
    
   <script>
       // JavaScript function to toggle the dropdown
       function myFunction() {
           document.getElementById("myDropdown").classList.toggle("show");
       }

       // Close the dropdown if the user clicks anywhere outside of it
       window.onclick = function(event) {
           if (!event.target.matches('.dropbtn')) {
               var dropdowns = document.getElementsByClassName("dropdown-content");
               for (var i = 0; i < dropdowns.length; i++) {
                   var openDropdown = dropdowns[i];
                   if (openDropdown.classList.contains('show')) {
                       openDropdown.classList.remove('show');
                   }
               }
           }
       }
   </script>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>



<div class="container">

    <nav>
        <ul>
            <li><a href="listprod.jsp">Begin Shopping</a></li>
            <li><a href="listorder.jsp">List All Orders</a></li>
            <li><a href="customer.jsp">My Profile</a></li>
            <li><a href="admin.jsp">Administrators</a></li>
            <li><a href="logout.jsp">Log out</a></li>
        </ul>
        <button class="btn"> <a href="showcart.jsp">Cart </a></button>
    </nav>

    <div style="display: flex; justify-content: center; align-items: center; height: 100px; text-align: center;">
        <%
        // Display current user login information
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null) {
            out.println("<p style='color: white; font-family: \"Poppins\", sans-serif; font-weight: 100; font-size: 30px;'>Welcome, " + userName + "</p>");
        }
        %>
    </div>

    <nav>
        <img src="img/logotypemon.png" alt="Mondo Books" class="logo">
        <li>
            <div class="searchform">
                <form method="get" action="listprod.jsp">
                    <input type="text" placeholder="Search" name="productName" size="50">
                </form>
            </div>
        </li>
        <!-- Dropdown for Language Selection -->
        <div class="dropdown">
            <button onclick="myFunction()" class="dropbtn">Select Language</button>
            <div id="myDropdown" class="dropdown-content">
                <a href="#">Arabic</a>
                <a href="#">Bengali</a>
                <a href="#">Chinese</a>
                <a href="#">Dutch</a>
                <a href="#">German</a>
                <a href="#">Hindi</a>
                <a href="#">Korean</a>
                <a href="#">Japanese</a>
                <a href="#">Tibetan</a>
                <a href="#">Ukrainian</a>
            </div>
        </div>
    </nav>


    <%
    // Define the color mapping for categories
    java.util.Map<String, String> categoryColors = new java.util.HashMap<>();
    categoryColors.put("Bengali", "purple");
    categoryColors.put("Arabic", "darkgreen");
    categoryColors.put("Chinese", "darkred");
    categoryColors.put("German", "orange");
    categoryColors.put("Japanese", "darkyellow");
    categoryColors.put("Tibetan", "blue");
    categoryColors.put("Ukrainian", "yellow");
    // Add other categories as needed
%>


    <div class="content">
        <h2>Most popular</h2>
        <div class="most-popular">
        <% 
        //get the products with the highest sales

        // Load SQL Server driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        // Connection parameters
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
        String uid = "sa";
        String pw = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, uid, pw);
        Statement stmt= con.createStatement();)
         {
            //Select the top three books in the sales!
            String SQL = "SELECT TOP 3 productId, SUM(quantity) AS totalSale FROM orderproduct GROUP BY productId ORDER BY totalSale DESC";
            String SQL2 = "SELECT * FROM product P JOIN category C ON P.categoryId = C.categoryId WHERE productId = ?";

            ResultSet rst= stmt.executeQuery(SQL);
            
            while (rst.next()) {
                String productId = rst.getString("productId");
                PreparedStatement pstmt = con.prepareStatement(SQL2);
                pstmt.setString(1, productId);
                ResultSet rst2 = pstmt.executeQuery();
                while (rst2.next()) {
            
                // Retrieve the productImageURL from the ResultSet
                String productName = rst2.getString("productName");
                String productImageURL = rst2.getString("productImageURL"); 
                String productPrice = rst2.getString("productPrice");
                String categoryName = rst2.getString("categoryName");//display category name
                String productDesc = rst2.getString("productDesc");
                String totalSale = rst.getString("totalSale");

                String productPage = "product.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + "&desc=" + URLEncoder.encode(productDesc, "UTF-8");
               
                // Get the color for the category
                String categoryColor = categoryColors.getOrDefault(categoryName, "black"); // Default to black if no color found

                if (productImageURL != null && !productImageURL.isEmpty()) {
                    %>
                    <!-- Displaying image with restricted size -->
                
                    <div class="product-item">
                    <img class="product-image" src="<%= productImageURL %>" alt="Product Image" />
                    <p class="product-name"><a href="<%= productPage %>"><%= productName %></p></a>
                    <p class="product-price">$<%= productPrice %></p>
                    <p class="product-category" style = "color: <%= categoryColor %>;"><%= categoryName %></p>
                    <p class="product-sales">
                        <%= totalSale %> <span>copies sold!</span>
                    </p>
                   
                </div>
                    <% 
                    }  
                }
            }
            %>
        </div>
        <h2>Recommended for you</h2>
    </div>
</div>
<%
con.close();
	} catch (SQLException ex) {
		out.println("SQLException: " + ex);
	}
	%>
</body>
</html>
