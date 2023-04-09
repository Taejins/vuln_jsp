<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>

<% if(s_name==null){%>
	<script>
		alert("로그인 후 이용해 주세요");
		location.href = "<%=loc%>/sign/login.jsp";
	</script>
<% }else{%>
	
<section id="" class="two">
	<div class="container">
		<form action="./admin.jsp" method="POST">
			<div class="login">
				<h3>계좌 정보 확인 페이지</h3><br>

<%		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		if(request.getMethod().equals("GET")){
			try{
				String email = (String)page_session.getAttribute("usr_email");
				conn = DBConnection.getConnection();
				String sql = "select account, balance from jsp_asset where email = '"+email+"'";
				stmt = conn.createStatement();
				rs = stmt.executeQuery(sql);
				if(rs.next()){
					page_session.setAttribute("my_account", rs.getString("account"));
					//계좌 정보, 송금 버튼, 거래내역 확인 버튼
					%>
						<p>내 계좌번호 : <%=rs.getString("account")%></p>
						<p>잔액 : <%=rs.getString("balance")%></p>
						<input type="button" onclick="location.href='./send.jsp'" value="송금">
						<input type="button" onclick="location.href='./list.jsp'" value="거래 내역">
				<% }else{%>
						<p>가입된 계좌가 없습니다<p>
						<input type="button" onclick="location.href='./create.jsp'" value="계좌 신청">
				<%}
				
			}catch(Exception e){
				System.out.println("DB 쿼리 실패");
				e.printStackTrace();
			}finally{
				if(stmt!=null)stmt.close();
				if(rs!=null)rs.close();
				conn.close();
			}
		}
	}
%>

			</div>
		</form>
	</div>
</section>


<%@ include file="/WEB-INF/jsp/footer.jsp"%>