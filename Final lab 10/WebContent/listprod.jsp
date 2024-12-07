<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="listprod.css">
    <title>Mondo Books - Product List</title>

    <!-- CSS to limit image size -->
    <style>
        img.product-image {
            max-width: 300px;
            max-height: 300px;
            width: auto;
            height: auto;
            object-fit: contain;
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

    // JavaScript function to handle filtering by category
    function filterCategory(category) {
        var currentUrl = window.location.href.split('?')[0]; // Get the current URL without any query parameters
        window.location.href = currentUrl + "?category=" + encodeURIComponent(category); // Redirect to the same page with the selected category as a query parameter
    }
</script>


</head>
<body>
    
    <h1>Search for the products you want to buy:</h1>

        <form method="get" action="listprod.jsp" class="search-form">
            <input type="text" name="productName" size="50" placeholder="Enter product name...">
            <button type="submit" class="btn submit">Search</button>
            <!-- Dropdown for Language Selection -->
            
            <button type="reset" class="btn reset">Reset</button>
        </form>

        <div class="dropdown">
            <button onclick="myFunction()" class="dropbtn">Select Language</button>
            <div id="myDropdown" class="dropdown-content">
                <a href="#" onclick="filterCategory('Arabic')">Arabic</a>
                <a href="#" onclick="filterCategory('Bengali')">Bengali</a>
                <a href="#" onclick="filterCategory('Chinese')">Chinese</a>
                <a href="#" onclick="filterCategory('Dutch')">Dutch</a>
                <a href="#" onclick="filterCategory('German')">German</a>
                <a href="#" onclick="filterCategory('Hindi')">Hindi</a>
                <a href="#" onclick="filterCategory('Korean')">Korean</a>
                <a href="#" onclick="filterCategory('Japanese')">Japanese</a>
                <a href="#" onclick="filterCategory('Tibetan')">Tibetan</a>
                <a href="#" onclick="filterCategory('Ukrainian')">Ukrainian</a>
            </div>
        </div>

    <div class="container">
        <div class="book-list">
            <% 
            // Get product name and category to filter/search
            String name = request.getParameter("productName");
            String category = request.getParameter("category");

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

            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                String SQL = "SELECT * FROM product P JOIN category C ON P.categoryId = C.categoryId WHERE productName LIKE ?";
                String SQL2 = "SELECT * FROM product P JOIN category C ON P.categoryId = C.categoryId WHERE categoryName = ?";
                
                PreparedStatement pstmt = con.prepareStatement(SQL);//filter product name
                PreparedStatement pstmt2 = con.prepareStatement(SQL2);//filter category

                // If no search term is provided, fetch all products
                if (name == null || name.trim().isEmpty()) {
                    pstmt.setString(1, "%");
                } else {
                    pstmt.setString(1, "%" + name + "%");
                }

                // If a category is selected, filter by category
                if (category != null && !category.trim().isEmpty()) {
                    pstmt2.setString(1, category);
                    pstmt = pstmt2;
                }

                ResultSet rst = pstmt.executeQuery();

                // Define the color mapping for categories
                java.util.Map<String, String> categoryColors = new java.util.HashMap<>();
                categoryColors.put("Bengali", "purple");
                categoryColors.put("Arabic", "darkgreen");
                categoryColors.put("Chinese", "darkred");
                categoryColors.put("Dutch", "yellow");
                categoryColors.put("German", "orange");
                categoryColors.put("Hindi", "#ff00ff");
                categoryColors.put("Korean", "#0F64CD");
                categoryColors.put("Japanese", "goldenrod");
                categoryColors.put("Tibetan", "blue");
                categoryColors.put("Ukrainian", "yellow");

                // Display the filtered results
                while (rst.next()) {
                    String productId = rst.getString("productId");
                    String productName = rst.getString("productName");
                    String productPrice = rst.getString("productPrice");
                    String productDesc = rst.getString("productDesc");
                    String productImageURL = rst.getString("productImageURL");
                    String categoryName = rst.getString("categoryName");

                    String productPage = "product.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice + "&desc=" + URLEncoder.encode(productDesc, "UTF-8");
                    String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;

                    // Get the color for the category
                    String categoryColor = categoryColors.getOrDefault(categoryName, "black");

                    if (productImageURL != null && !productImageURL.isEmpty()) {
            %>
                    
                    <div class="product-item">
                        <img class="product-image" src="<%= productImageURL %>" alt="Product Image" />
                        <p class="product-name"><a href="<%= productPage %>"><%= productName %></a></p>
                        <p class="product-price">$<%= productPrice %></p>
                        <p class="product-category" style="color: <%= categoryColor %>;"><%= categoryName %></p>
                        <a href="<%= addToCartLink %>" class="add-to-cart">Add to cart</a>
                    </div>
                    
            <% 
                    }
                }
                con.close();
            } catch (SQLException ex) {
                out.println("SQLException: " + ex);
            }
            %>
        </div>
    </div>
</body>
</html>
