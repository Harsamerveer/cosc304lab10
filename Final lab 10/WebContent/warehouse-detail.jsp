<%@ page import="java.util.List" %>
<%@ page import="your.package.ProductInventory" %>
<%@ page import="your.package.Warehouse" %>
<%@ page import="your.package.DatabaseHelper" %>

<html>
<head>
    <title>Warehouse Inventory</title>
</head>
<body>
    <h1>Product Inventory for Warehouse ${param.warehouseId}</h1>
    
    <%
        // Get warehouseId from the request parameter
        int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
        
        // Query the database for products in this warehouse
        List<ProductInventory> inventoryList = DatabaseHelper.getProductInventoryByWarehouse(warehouseId);
    %>

    <table border="1">
        <tr>
            <th>Product Name</th>
            <th>Quantity</th>
            <th>Price</th>
        </tr>
        <%-- Loop through the inventory list and display the details --%>
        <c:forEach var="inventory" items="${inventoryList}">
            <tr>
                <td>${inventory.productName}</td>
                <td>${inventory.quantity}</td>
                <td>${inventory.price}</td>
            </tr>
        </c:forEach>
    </table>

    <br>
    <a href="warehouse.jsp">Back to Warehouse List</a>
</body>
</html>
