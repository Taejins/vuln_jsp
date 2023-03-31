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
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String make_table = null;
		String sql = "null";
		
		String search = request.getParameter("search");
		
		
		try{
			conn = DBConnection.getConnection();
			if(search!=null){
				sql = "select * from jsp_board where board_title like '%'||?||'%'";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, search);
			}else{
				sql = "select * from jsp_board";
				pstmt = conn.prepareStatement(sql);
			}
			
			rs = pstmt.executeQuery();
			
	%>
	<form method="GET" action="./board.jsp">
		<div style="display: flex; justify-content: center">
			<input type="text" name="search">
			<button style="width:100px" type="submit" >검색</button>
		</div>
	</form>
	
	<br>
	<table class="table table-hover">
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
		}catch(Exception e){
			out.println("<h3>실패</h3>");
			e.printStackTrace();
		}finally{
			if(rs!=null)rs.close();
			pstmt.close();
			conn.close();
		}
	%>
		
	<button onclick="location.href='./board_write.jsp'">작성</button>
</section>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>