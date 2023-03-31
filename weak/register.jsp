<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="DBconn.DBConnection" %>

<%
	request.setCharacterEncoding("utf-8");
	String email = null;
	String pw = null;
	String name = null;
	String tel = null;
	
	Connection conn = null;
	Statement stmt1 = null;
	Statement stmt2 = null;
	ResultSet rs = null;
	
	if(request.getMethod().equals("POST")){
		email = request.getParameter("email");
		pw = request.getParameter("pw");
		name = request.getParameter("name");
		tel = request.getParameter("tel");
		
		try{
			conn = DBConnection.getConnection();
			String sql = "select * from jsp_usr where email = '"+email+"'";
			stmt1 = conn.createStatement();
			
			rs = stmt1.executeQuery(sql);
			
			if (rs.next()) {
				%>
				<script>alert("이미 가입된 아이디입니다.");</script>
				<%
			}else{
				sql = "insert into jsp_usr(id, email, pw, name, tel, admin) values(id.nextval,'"+email+"','"+pw+"','"+name+"','"+tel+"', '0')";
				stmt2 = conn.createStatement();
				
				stmt2.executeUpdate(sql);
				%>
				<script>
					alert("가입성공");
					location.href = "./login.jsp";
				</script>
				<%
			}
		} catch(Exception e){
			System.out.println("<h3>실패</h3>");
			e.printStackTrace();
		} finally{
			if(rs != null) rs.close();
			if(stmt1 != null) stmt1.close();
			if(stmt2 != null) stmt2.close();
			if(conn != null) conn.close();
		}
	}

	
	
%>

<%@ include file="/WEB-INF/jsp/header.jsp"%>

<body>
<section id="" class="two">
	<form action="./register.jsp" method="POST">
        <div class="login">
            <h3>회원가입 페이지</h3><br>
                <input type="email" name="email" id="1" placeholder="Email"><br>
                <input type="password" name="pw" id="2" placeholder="Password"><br>
                <input type="text" name="name" id="3" placeholder="name"><br>
                <input type="text" name="tel" id="4" placeholder="tel"><br>
                <input type="submit" value="회원가입">
        </div>
	</form>
</section>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>
