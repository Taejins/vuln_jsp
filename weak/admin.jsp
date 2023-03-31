<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>

<%
	Cookie[] cookies = request.getCookies();
	String ad_cookie = "0";
	for(int i=0;i<cookies.length;i++){
		if(cookies[i].getName().equals("admin")){
			ad_cookie = cookies[i].getValue();
		}
	}
	
	
	if(request.getMethod().equals("POST")){
		String email = request.getParameter("email");
		String admin = request.getParameter("admin");
		if(ad_cookie.equals("1")){
			Connection conn = null;
			Statement stmt = null;
			int rs = 0;
			
			try{
				conn = DBConnection.getConnection();
				String sql = "update jsp_usr set admin = '"+admin+"' where email = '"+email+"'";
				stmt = conn.createStatement();
				rs = stmt.executeUpdate(sql);				
			}catch(Exception e){
				System.out.println("DB 쿼리 실패");
				e.printStackTrace();
			}finally{
				if(stmt!=null)stmt.close();
				conn.close();
			}
			if(rs>0){
			%>
				<script>
					alert("변경 되었습니다");
					location.href = "./admin.jsp";
				</script>
			<%
			}else{
				%>
				<script>
					alert("존재하지 않습니다.");
					location.href = "./admin.jsp";
				</script>
				<%
			}
				
		}else{
			%>
			<script>
				alert("권한이 없습니다");
				location.href = "./admin.jsp";
			</script>
			<%
		}
	}
%>


<section id="" class="two">
	<div class="container">
		<form action="./admin.jsp" method="POST">
			<div class="login">
				<h3>관리자 페이지</h3><br>
				<input type="email" name="email" id="1" placeholder="Email"><br>
				<select name="admin">
				  <option value="1">관리자</option>
				  <option value="0">일반 유저</option>
				</select>
				<br>
				</div>
				<div class="submit">
					<input type="submit" value="관리자 권한 부여">
				</div>
			</div>
		</form>
	</div>
</section>


<%@ include file="/WEB-INF/jsp/footer.jsp"%>