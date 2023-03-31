<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>



<% if(s_name==null){%>
	<script>
		alert("로그인 후 이용해 주세요");
		location.href = "./login.jsp";
	</script>
<%
	}else{
		if(request.getMethod().equals("POST")){
			
			String email = (String)page_session.getAttribute("usr_email");
			String cur_pw = request.getParameter("cur_pw");
			String new_pw = request.getParameter("new_pw");
			String new_pw_confirm = request.getParameter("new_pw_confirm");
			
			if(!new_pw.equals(new_pw_confirm)){
				%>
				<script>
					alert("새 비밀번호가 일치하지 않습니다.");
					location.href = "./change_pw.jsp";
				</script>
				<%
			}
			Connection conn = DBConnection.getConnection();
			Statement stmt = conn.createStatement();
			String sql = null;
			ResultSet rs = null;
			int rs2 = 0;
		
			try{

				sql = "select * from jsp_usr where email = '"+email+"' and pw = '"+cur_pw+"'";
				rs = stmt.executeQuery(sql);				
				
				if(rs.next()){
					sql = "update jsp_usr set pw = '"+new_pw+"' where email = '"+email+"' and pw = '"+cur_pw+"'";
					rs2 = stmt.executeUpdate(sql);				
				}
				
				if(rs==null || rs2==0){
					%>
					<script>
						alert("접근이 거부되었습니다.");
						location.href = "./";
					</script>
					<%
				}else{
					%>
					<script>
						alert("변경이 완료되었습니다. 다시 로그인해주세요.");
						location.href = "./logout.jsp";
					</script>
					<%
				}
				
			}catch(Exception e){
				System.out.println("DB 쿼리 실패");
				e.printStackTrace();
			}finally{
				if(stmt!=null)stmt.close();
				conn.close();
			}
		}

%>



<section id="" class="two">
	<div class="container">
		<form action="./change_pw.jsp" method="POST">
			<div class="login">
				<h3>비밀번호 변경 페이지</h3><br>
				<input type="password" name="cur_pw" placeholder="현재 비밀번호"><br>
				<input type="password" name="new_pw" placeholder="새 비밀번호"><br>
				<input type="password" name="new_pw_confirm" placeholder="새 비밀번호 확인"><br>
			</div>
			<div class="submit">
				<input type="submit" value="비밀번호 변경">
			</div>
			</div>
		</form>
	</div>
</section>

	<%}%>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>