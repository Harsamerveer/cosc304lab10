<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Link to Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

<!-- Header-specific styles -->
<style>
    nav {
        font-family: 'Poppins', sans-serif;
        background-color: black;
        color: white;
    }

    nav ul {
        list-style: none;
        display: flex;
        gap: 15px;
        padding: 0;
        margin: 0;
    }

    nav ul li a {
        color: white;
        text-decoration: none;
    }

    nav ul li a:hover {
        color: #ccc;
    }

    nav button {
        background-color: transparent;
        border: 1px solid white;
        padding: 5px 10px;
        cursor: pointer;
    }

    nav button a {
        color: white;
        text-decoration: none;
    }

    nav button a:hover {
        color: #ccc;
    }

    .logo {
        margin-bottom: 5px;
        margin-left: 30px;
        height: 80px;
        width: fit-content;
        margin-right: 20px;
    }
</style>

<!-- Header HTML with Navigation and Dropdown -->
<nav>
    <!-- Logo -->
    <img src="img/logotypemon.png" alt="Mondo Books" class="logo">
    
    <!-- Navigation Links -->
    <ul>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="listprod.jsp">Begin Shopping</a></li>
        <li><a href="listorder.jsp">List All Orders</a></li>
        <li><a href="customer.jsp">My Profile</a></li>
        <li><a href="admin.jsp">Administrators</a></li>
        <li><a href="logout.jsp">Log out</a></li>
    </ul>

    <!-- Cart Button -->
    <button><a href="showcart.jsp">Cart</a></button>
</nav>
