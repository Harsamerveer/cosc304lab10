<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
    
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
    
        .product-details {
            text-align: center;
        }
    
        .product-details img {
            margin: 15px auto;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
    
        .product-details p {
            font-size: 16px;
            line-height: 1.5;
        }
    
        .product-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }
    
        .product-actions a {
            text-decoration: none;
            background: #007bff;
            color: #fff;
            padding: 10px 15px;
            border-radius: 4px;
            transition: background 0.3s;
        }
    
        .product-actions a:hover {
            background: #0056b3;
        }
        img.product-image {
            max-width: 300px; /* Adjust this value for the maximum width */
            max-height: 300px; /* Adjust this value for the maximum height */
            width: auto; /* Ensures aspect ratio is maintained */
            height: auto; /* Ensures aspect ratio is maintained */
            object-fit: contain; /* Keeps the image content within bounds without distortion */
            border: 1px solid #ddd; /* Optional: Add a border for better visuals */
            border-radius: 8px; /* Optional: Rounded corners */
            margin: 10px 0; /* Optional: Add spacing around the image */
            }
        .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0, 0, 0, 0.8);
    }

    .modal-content {
        margin: 10% auto;
        display: block;
        max-width: 80%;
        border-radius: 8px;
    }

    .close {
        position: absolute;
        top: 10px;
        right: 25px;
        color: white;
        font-size: 35px;
        font-weight: bold;
        cursor: pointer;
    }
    </style>
    <script>
        // Modal functionality
        document.addEventListener('DOMContentLoaded', () => {
            const modal = document.getElementById('imageModal');
            const modalImg = document.getElementById('modalImage');
            const images = document.querySelectorAll('.product-image');
            const closeModal = document.querySelector('.close');
    
            images.forEach(img => {
                img.onclick = function () {
                    modal.style.display = "block";
                    modalImg.src = this.src;
                }
            });
    
            closeModal.onclick = function () {
                modal.style.display = "none";
            };
    
            window.onclick = function (event) {
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            };
        });
    </script>
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
String productName = request.getParameter("name");
String productId = request.getParameter("id");
String productPrice = request.getParameter("price");
String productDesc = request.getParameter("desc");

try {
    // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

// Connection parameters
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
     Statement stmt = con.createStatement()) {

    String sql = "select * from product where productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);  

    pstmt.setString(1,productId);  
    ResultSet rs = pstmt.executeQuery();

    while (rs.next()) {
        String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + productName + "&price=" + productPrice + "&desc=" + productDesc;
        System.out.println("Product description: " + productDesc);
        %>
        <div class="container">
            <div class="product-details">
                <h2><b><%= productName %></b></h2>
                <p style="color: rgb(190, 134, 29);">Price: $<%= productPrice %></p>
                <p>Description: <%= productDesc %></p>
                
            <%
            // Retrieve the productImageURL from the ResultSet
            String productImageURL = rs.getString("productImageURL"); 
            if (productImageURL != null && !productImageURL.isEmpty()) {
            %>
            <!-- Displaying image with restricted size -->
            <img class="product-image" src="<%= productImageURL %>" alt="Product Image" />
            <% 
            }            
            %> 
            <div class="product-actions">
            <a href="<%= addToCartLink %>">Add to cart</a>
            <h5><a href="listprod.jsp">Continue Shopping</a></h5>
        </div>
    </div>
</div>                <!-- Modal for Image -->
        <div id="imageModal" class="modal">
            <span class="close">&times;</span>
            <img class="modal-content" id="modalImage">
        </div>
            <%
    }

    rs.close();
    con.close();
} catch (SQLException ex) {
    ex.printStackTrace();
    out.println("SQLException: " + ex.getMessage());
} 

%>

</body>
</html>
