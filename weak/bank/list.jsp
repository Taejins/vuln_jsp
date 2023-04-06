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

<section class="three">
	<h3>거래 내역 페이지</h3>
	<br>
	<% 
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		//날짜 검색
		String s_day = request.getParameter("s_day");
		String e_day = request.getParameter("e_day");
		
		if(s_day==null || s_day =="") s_day = "1998-04-19";
		if(e_day==null || e_day =="") e_day = "2300-04-19";

		String my_account = (String)page_session.getAttribute("my_account");
		String make_table = null;
		String sql = "null";
		
		
		try{
			conn = DBConnection.getConnection();
			stmt = conn.createStatement();
			sql = "(select to_account, from_account, concat('-',money) as money, to_balance as balance, trade_date from jsp_trade where to_account = '"+my_account+"' and trade_date between '"+s_day+"' and '"+e_day+"') union (select to_account, from_account, concat('',money) as money, from_balance as balance, trade_date from jsp_trade where from_account = '"+my_account+"' and trade_date between '"+s_day+"' and '"+e_day+"') order by trade_date desc";
			rs = stmt.executeQuery(sql);
			System.out.println(sql);
	%>
	<form method="GET" action="./list.jsp">
		<div style="display: flex; justify-content: center">
			<input class="form-control" type="date" name="s_day">
			<p><b>~</b></p>
			<input class="form-control" type="date" name="e_day">
			<input type="submit" value="날짜 조회">
		</div>
	</form>
	
	<br>
	<table class="table">
		<colgroup>
			<col width="20%"/>
			<col width="20%"/>
			<col width="20%"/>
			<col width="20%"/>
			<col width="20%"/>
		</colgroup>
		<thead class="thead=dark">
			<tr>
				<th scope="col">보낸계좌</th>
				<th scope="col">받은계좌</th>
				<th scope="col">금액</th>
				<th scope="col">잔액</th>
				<th scope="col">일시</th>
			</tr>
		</thead>
		<tbody>
			
			<%
				while(rs.next()){
					make_table = "<tr>";
					make_table += "<td>"+rs.getString("to_account")+"</td>";
					make_table += "<td>"+rs.getString("from_account")+"</td>";
					make_table += "<td>"+rs.getString("money")+"</td>";
					make_table += "<td>"+rs.getString("balance")+"</td>";
					make_table += "<td>"+rs.getString("trade_date")+"</td>";
					make_table += "</tr>";
					out.println(make_table);
				}
			%>
			
		</tbody>
	</table>
	
	<%
		}catch(Exception e){
			// System.out.println("<h3>실패</h3>");
			// e.printStackTrace();
		}finally{
			if(rs!=null)rs.close();
			stmt.close();
			conn.close();
		}
	%>

</section>

<%}%>



<%@ include file="/WEB-INF/jsp/footer.jsp"%>