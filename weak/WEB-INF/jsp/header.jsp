<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	//세션 확인
	HttpSession page_session = request.getSession();
	String s_name = (String)page_session.getAttribute("usr_name");

	//현재 위치 확인
	String loc = request.getContextPath();
	
%>

<html>
<head>
	<title>JSP_TEAJIN</title>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
	
	<link rel="stylesheet" href="<%=loc%>/assets/css/main.css" />
	<link rel="stylesheet" href="<%=loc%>/assets/css/bootstrap.css" />
</head>
<body class="is-preload">
<!-- Header -->
	<div id="header">
		<div class="top">
			<!-- Logo -->
				<div id="logo">
					<% if(s_name!=null){ %>
					<h1>[<%=s_name%>]님</h1>
					<button onclick="location.href='<%=loc%>/change_pw.jsp'">회원정보</button>
					<button onclick="location.href='<%=loc%>/logout.jsp'">로그아웃</button>
					<% }else{ %>
					<button onclick="location.href='<%=loc%>/register.jsp'">회원가입</button>
					<button onclick="location.href='<%=loc%>/login.jsp'">접속하기</button>
					<% } %>
				</div>

			<!-- Nav -->
				<nav id="nav">
					<ul>
						<li><a href="<%=loc%>/" id="top-link"><span class="icon solid fa-home">Home</span></a></li>
						<li><a href="<%=loc%>/board.jsp" id="portfolio-link"><span class="icon solid fa-th">Board</span></a></li>
						<li><a href="<%=loc%>/bank" id="portfolio-link"><span class="icon solid fa-credit-card">Bank</span></a></li>
						<li><a href="<%=loc%>/admin.jsp" id="about-link"><span class="icon solid fa-user">Auth</span></a></li>
					</ul>
				</nav>

		</div>
	</div>
	
	<div id="main" >