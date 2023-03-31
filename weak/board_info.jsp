<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>

<section class="three">
	<h3>게시글 상세 페이지</h3>
	<br>
	
	<% 
		String id = request.getParameter("id");
	
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		//html에서 변수를 불러오기 위한 초기화
		int b_id = 0;
		String b_title = null;
		String b_content = null;
		String b_file = null;
		String b_date = null;
		String b_writer = null;
	
		try{
			conn = DBConnection.getConnection();
			String sql = "select * from jsp_board where board_id = "+id;
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			if(rs.next()){
				b_id = rs.getInt(1);
				b_title = rs.getString(2);
				b_content = rs.getString(3);
				b_writer = rs.getString(4);
				b_date = rs.getString(5);
				b_file = (rs.getString(6)!=null) ? rs.getString(6) : "";
			}
		}catch(Exception e){
			System.out.println("DB 쿼리 실패");
			e.printStackTrace();
		}finally{
			rs.close();
			stmt.close();
			conn.close();
		}
	
	
	%>
	
	<table class="board_detail">
				<colgroup>
					<col width="15%"/>
					<col width="35%"/>
					<col width="15%"/>
					<col width="35%"/>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">글 번호</th>
						<td><%=b_id%></td>
						<th scope="row">작성자</th>
						<td><%=b_writer%></td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td><a href="./down.jsp?fileName=<%=b_file%>"><%=b_file%></a></td>
						<th scope="row">작성일</th>
						<td><%=b_date%></td>
						</tr>
					<tr>
						<th scope="row">제목</th>
						<td colspan="3">
							<%=b_title%>
						</td>
					</tr>
					<tr>
						<td colspan="4" class="view_text">
							<%=b_content%>
						</td>
					</tr>
				</tbody>
			</table>
	<button onclick="location.href='./board_mod.jsp?id=<%=b_id%>'">수정</button>
	<button onclick="location.href='./board_del.jsp?id=<%=b_id%>'">삭제</button>
</section>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>





	
	    	
