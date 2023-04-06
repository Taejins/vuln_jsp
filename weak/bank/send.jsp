<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>

<% if(s_name==null){%>
	<script>
		alert("로그인 후 이용해 주세요");
		location.href = "<%=loc%>/login.jsp";
	</script>
<% }else if(page_session.getAttribute("my_account")==null){%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "<%=loc%>/bank/";
	</script>
<% }else{ %>
	<section id="" class="two">
		<div class="container">
			<form action="./confirm_pw.jsp" method="GET">
				<div class="login">
					<h3>송금 페이지</h3><br>
					<input type="text" name="from_account" placeholder="보낼 계좌번호"><br>
					<input type="number" name="money" placeholder="금액"><br>
					<div class="submit">
						<input type="submit" value="송금">
					</div>
				</div>
			</form>
		</div>
</section>
<%}%>


<%@ include file="/WEB-INF/jsp/footer.jsp"%>