<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>


<% if(s_name==null){%>
	<script>
		alert("로그인 후 이용해 주세요");
		location.href = "<%=loc%>/sign/login.jsp";
	</script>
<% }else{
	
	
	if(request.getMethod().equals("POST")){
		String email = (String)page_session.getAttribute("usr_email");
		String password = request.getParameter("pw");
		Connection conn = null;
		Statement stmt = null;
		try{
			conn = DBConnection.getConnection();
			String sql = "select account, balance from jsp_asset where email = '"+email+"'";
			stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.next()){
				//계좌 정보, 송금 버튼, 거래내역 확인 버튼
				%>
				<script>
					alert("이미 계좌가 존재합니다.");
					location.href = "./";
				</script>
		<% }else{
				String num = "";
				do{
					//10자리 난수
					num = "";
					for(int i=0;i<10;i++){
						num = num+(int)(Math.random()*10);
					}
					sql = "select account from jsp_asset where account = '"+num+"'";
					rs = stmt.executeQuery(sql);
				}while(rs.next());
				
				sql = "insert into jsp_asset values(account_id.nextval, '"+email+"', 10000, '"+num+"', '"+password+"')";
				int rs2 = stmt.executeUpdate(sql);
			
			%>
				<script>
					alert("계좌가 성공적으로 개설되었습니다.");
					location.href = "./";
				</script>
		<%}
			
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
	<form action="./create.jsp" method="POST">
        <div class="login">
            <h3>계좌 신청 페이지</h3><br>
                계좌이체 시 사용할 비밀번호
                <input type="password" name="pw" placeholder="Password"><br>
                <input type="submit" value="계좌 신청">
        </div>
	</form>
</section>






<%}%>















<%@ include file="/WEB-INF/jsp/footer.jsp"%>