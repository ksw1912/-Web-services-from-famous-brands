<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="server.BrandDTO"%>
<%@ page import="server.BrandDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title> 귣       </title>
<link
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<style>
body {
    text-align: center;
    font-family: Arial, sans-serif; 
    background-color: #f0f0f0;
    padding: 20px;
}
</style>
<body>


	<%
	String brandName = "Apple";

	BrandDAO brandDAO = new BrandDAO();
	String brandAddress = brandDAO.getBrandAddress(brandName);
	%>


	<div class="container mt-5">
		<h1> 귣       </h1>
		<div class="card">
			<div class="card-body">
				<h3 class="card-title"> 귣    ̸ :</h3>
				<p class="card-text"><%= brandName %></p>
				<h3 class="card-title"> 귣    ּ :</h3>
				<p class="card-text"><%= brandAddress %></p>
				<button id="tryAgainButton" class="btn btn-primary"> ٽ  ϱ </button>
			</div>
		</div>
	</div>



	<script>
        document.getElementById("tryAgainButton").addEventListener("click", function() {
          window.location.href = "index.jsp"; 
     });
    </script>
</body>
</html>
