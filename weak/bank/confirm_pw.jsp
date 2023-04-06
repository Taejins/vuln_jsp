<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>
<%@ page import="enc_module.AES256" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

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
<% }else{
	
	//로그인 확인, 내가 내계좌로 돈보내는지 확인

	if(request.getMethod().equals("POST")){
		String password = request.getParameter("pw");
		String enc_Str = request.getParameter("enc_data");
		String ori_Str = AES256.decrypt(enc_Str);
		
		String[] array = ori_Str.split(" ");
		String dec_to_account = array[0];
		String dec_from_account = array[1];
		int dec_money = Integer.parseInt(array[2]);
		int from_balance = Integer.parseInt(array[3]);
		
		String to_account = (String)page_session.getAttribute("my_account");
		int to_balance = 0;
		String to_password = null;
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try{
			conn = DBConnection.getConnection();
			String sql = "select A.balance, A.password from jsp_usr U, jsp_asset A where A.email = U.email and A.account = '"+dec_to_account+"'";
			stmt = conn.createStatement();
			//비밀번호 검증은 쿼리에서 하지 않고 나눠서 하는 것이 좋음! 하지만 지금은 그냥 쿼리에서 할 꺼지롱
			rs = stmt.executeQuery(sql);
			
			if (rs.next()) {
				to_balance = rs.getInt("balance");
				to_password = rs.getString("password");
			}
			
			//돈 검증 ( 음수이거나 내 잔액보다 많거나 ) 
			if(dec_money<=0||to_balance<dec_money){
				%>
				<script>
					alert("입력하신 금액을 다시 확인해주세요.");
					location.href = "<%=loc%>/bank/send.jsp";
				</script>	
				<%
			}else if(!password.equals(to_password)){
				%>
				<script>
					alert("비밀번호가 올바르지 않습니다.");
					location.href = "<%=loc%>/bank/send.jsp";
				</script>	
				<%
			}else{
				//오늘 날짜 구하기
				java.util.Date today = new java.util.Date();
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:MM");
				String w_date = df.format(today);
				//거래 계산
				int res_to_balance = to_balance - dec_money;
				int res_from_balance = from_balance + dec_money;
				
				//보낸 계좌 수정
				sql = "update jsp_asset set balance = '"+res_to_balance+"' where account = '"+dec_to_account+"'";
				stmt.executeUpdate(sql);
				//받는 계좌 수정
				sql = "update jsp_asset set balance = '"+res_from_balance+"' where account = '"+dec_from_account+"'";
				stmt.executeUpdate(sql);
				//거래내역 기록
				sql = "insert into jsp_trade values(trade_id.nextval, '"+dec_to_account+"', '"+dec_from_account+"', "+dec_money+", "+res_to_balance+", "+res_from_balance+", '"+w_date+"')";
				stmt.executeUpdate(sql);
				%>
					<script>
						alert("정상적으로 송금되었습니다.");
						location.href = "<%=loc%>/bank/";
					</script>	
				<%
			}
		}catch(Exception e){
			e.printStackTrace();
		} finally{
			if(rs!=null)rs.close();
			stmt.close();
			conn.close();
		}
	}

	if(request.getMethod().equals("GET")){
		//get으로 오면 세션에 to 계좌 확인, 프롬 계좌 존재 확인
		String to_account = (String)page_session.getAttribute("my_account");
		String from_account = request.getParameter("from_account");
		//본인 계좌 확인
		if(to_account.equals(from_account)) {%>
			<script>
				alert("자신의 계좌로는 송금하실 수 없습니다.");
				location.href = "<%=loc%>/bank/send.jsp";
			</script>
		<%}
		String money = request.getParameter("money");
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try{
			conn = DBConnection.getConnection();
			String sql = "select U.name, A.balance from jsp_usr U, jsp_asset A where A.email = U.email and A.account = '"+from_account+"'";
			stmt = conn.createStatement();
			
			rs = stmt.executeQuery(sql);
			
			if (rs.next()) {
				String ori_Str = to_account+" "+from_account+" "+money+" "+rs.getInt("balance");
				String enc_Str = AES256.encrypt(ori_Str);
				String to_name = rs.getString("name");
				%>
				<section id="" class="two">
					<div class="container">
						<form action="./confirm_pw.jsp" method="POST">
							<div class="login">
								<h3>비밀번호 확인</h3><br>
								
								<h4><%=to_name%>님께 <%=money%>원을 송금합니다.</h4>
								<input type="password" name="pw" placeholder="계좌 비밀번호"><br>
								<input type="hidden" name="enc_data" value="<%=enc_Str%>">
								<div class="submit">
									<input type="submit" value="인증">
								</div>
							</div>
						</form>
					</div>
				</section>
				<%	
			}else{
				%>
				<script>
					alert("해당 계좌는 없는 계좌입니다.");
					location.href="./send.jsp";
				</script>
				
				<%
			}
				
		} catch(Exception e){
			e.printStackTrace();
		} finally{
			if(rs!=null)rs.close();
			stmt.close();
			conn.close();
		}
	}
%>

<%}%>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>