<!-- header.jsp -->
<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Header HTML with Navigation and Dropdown -->
<nav style="background-color: black; color: white;">
    <!-- Logo -->
    <img src="img/logotypemon.png" alt="Mondo Books" class="logo">
    
    <!-- Navigation Links -->
    <ul>
        <li><a href="listprod.jsp">Begin Shopping</a></li>
        <li><a href="listorder.jsp">List All Orders</a></li>
        <li><a href="customer.jsp">My Profile</a></li>
        <li><a href="admin.jsp">Administrators</a></li>
        <li><a href="logout.jsp">Log out</a></li>
    </ul>

    <!-- Cart Button -->
    <button class="btn"><a href="showcart.jsp">Cart</a></button>
</nav>

