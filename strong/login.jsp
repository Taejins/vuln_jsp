<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>


<%
	request.setCharacterEncoding("utf-8");
	String email = null;
	String pw = null;
	
	
	if(request.getMethod().equals("POST")){
		email = request.getParameter("email");
		pw = request.getParameter("pw");
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			conn = DBConnection.getConnection();
			String sql = "select * from jsp_usr where email = ? and pw = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			pstmt.setString(2, pw);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				HttpSession page_session = request.getSession();
				page_session.setAttribute("usr_name", rs.getString("name")); 
				response.sendRedirect("./");
			}else{
				%>
				<script>alert("정보가 올바르지 않습니다.");</script>
				<%
			}
				
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			rs.close();
			pstmt.close();
			conn.close();
		}
	}
%>


<%@ include file="/WEB-INF/jsp/header.jsp"%>
<section id="" class="two">
	<div class="container">
		<form action="./login.jsp" method="POST">
			<div class="login">
				<h3>로그인 페이지</h3><br>
				<input type="email" name="email" id="1" placeholder="Email"><br>
				<input type="password" name="pw" id="2" placeholder="Password"><br>
				<div class="submit">
					<input type="submit" value="로그인">
				</div>
			</div>
		</form>
	</div>
</section>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>