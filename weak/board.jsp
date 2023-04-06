<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>
<section class="three">
	<h3>게시판 페이지</h3>
	<br>
	<% 
		request.setCharacterEncoding("utf-8");
		
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		//정렬 선택
		String align = request.getParameter("align");
		
		if(align==null) align="1";
		
		
		String make_table = null;
		String sql = "null";
		
		String search = request.getParameter("search");
		
		
		// try{
			conn = DBConnection.getConnection();
			stmt = conn.createStatement();
			if(search!=null){
				sql = "select * from jsp_board where board_title like '%"+search+"%' order by "+align+" desc";
				
			}else{
				sql = "select * from jsp_board order by "+align+" desc";
			}
			
			rs = stmt.executeQuery(sql);
			
	%>
	<form method="GET" action="./board.jsp">
		<div style="display: flex; justify-content: center">
			<div style="width:150px; display: flex; justify-content: center">
				<p><b>정렬 : </p></b>
				<label><input type="radio" name="align" value="1">ID</label>
				<label><input type="radio" name="align" value="2">TITLE</label>
			</div>
			<input style="margin:0 10px" type="text" name="search">
			<button style="width:150px" type="submit" >검색</button>
		</div>

	</form>
	
	<br>
	<table class="table">
		<colgroup>
			<col width="10%"/>
			<col width="55%"/>
			<col width="20%"/>
			<col width="15%"/>
		</colgroup>
		<thead class="thead=dark">
			<tr>
				<th scope="col">id</th>
				<th scope="col">title</th>
				<th scope="col">date</th>
				<th scope="col">writer</th>
			</tr>
		</thead>
		<tbody>
			
			<%
				while(rs.next()){
					make_table = "<tr onclick='location.href=\"./board_info.jsp?id="+rs.getString("board_id")+"\"'>";
					make_table += "<td>"+rs.getString("board_id")+"</td>";
					make_table += "<td>"+rs.getString("board_title")+"</td>";
					make_table += "<td>"+rs.getString("board_date")+"</td>";
					make_table += "<td>"+rs.getString("board_writer")+"</td>";
					make_table += "</tr>";
					out.print(make_table);
				}
			%>
			
		</tbody>
	</table>
	
	<%
		// }catch(Exception e){
			// System.out.println("<h3>실패</h3>");
			// e.printStackTrace();
		// }finally{
			if(rs!=null)rs.close();
			stmt.close();
			conn.close();
		// }
	%>
		
	<button onclick="location.href='./board_write.jsp'">작성</button>
</section>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>