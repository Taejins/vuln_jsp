<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="DBconn.DBConnection" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>
	
	<% 
		String b_id = null;
		String b_title = null;
		String b_content = null;
		String b_file = null;
		String b_date = null;
		String b_writer = null;
	
		Connection conn = null;
		Statement stmt = null;		
		
		String sql = null;
		
		if(request.getMethod().equals("POST")){
			
			String saveFolder = application.getRealPath("/file") ;
			String encType = "UTF-8";
			int maxSize = 5 * 1024 * 1024;
			try {
				MultipartRequest multi = null;
				multi = new MultipartRequest(request, saveFolder, maxSize,
						encType, new DefaultFileRenamePolicy());
				b_id = multi.getParameter("id");
				b_title = multi.getParameter("title");
				b_content = multi.getParameter("content");
				b_writer = multi.getParameter("writer");
				// b_date = multi.getParameter("date");
			
				conn = DBConnection.getConnection();
				sql = "update jsp_board set board_title='"+b_title+"', board_content='"+b_content+"' where board_id="+b_id;
				stmt = conn.createStatement();
				stmt.executeUpdate(sql);
				
				response.sendRedirect("./board.jsp");
				
			} catch (IOException ioe) {
				System.out.println(ioe);
			} catch (Exception ex) {
				System.out.println(ex);
			}finally{
				stmt.close();
				conn.close();
			}
		}else{
			b_id = request.getParameter("id");
			
			ResultSet rs = null;
			
			try{
				conn = DBConnection.getConnection();
			
				sql = "select * from jsp_board where board_id = "+b_id;
				stmt = conn.createStatement();
				rs = stmt.executeQuery(sql);
				
				if(rs.next()){
					b_title = rs.getString("board_title");
					b_content = rs.getString("board_content");
					b_file = (rs.getString("board_file")!=null) ? rs.getString("board_file") : "";
					b_date = rs.getString("board_date");
					b_writer = rs.getString("board_writer");
				}
			}catch(Exception e){
				out.println("<h3>실패</h3>");
				e.printStackTrace();
			}finally{
				if(rs!=null)rs.close();
				stmt.close();
				conn.close();
			}
			
		}
		
		if(s_name==null||!s_name.equals(b_writer)){%>
			<script> 
				alert("접근이 불가합니다");
				location.href = "./board.jsp";
			</script>
			
		<%}else{%>
<section class="three">	
	<h3>게시글 수정 페이지</h3>
	<br>
	<form id="b_mod" action="./board_mod.jsp" method="POST" enctype="multipart/form-data">
        <table class="board_detail">
			<colgroup>
				<col width="15%"/>
				<col width="35%"/>
				<col width="15%"/>
				<col width="35%"/>
			</colgroup>
			<tbody>

				<tr>
					<th scope="row">제목</th>
					<td colspan="3">
						<input type="text" name="title" value="<%=b_title%>">
					</td>
				</tr>
				<tr>
					<td colspan="4" class="view_text">
						<textarea name="content" form="b_mod" cols="30" rows="5"><%=b_content%></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td>
						<a href="./down.jsp?fileName=<%=b_file%>"><%=b_file%></a>
					</td>
					

				</tr>
			</tbody>
		</table>
		<input type="hidden" name="id" value="<%=b_id%>">
		<input type="hidden" name="writer" value="<%=b_writer%>">
		<input type="submit" value="수정">
	</form>
	
</section>	

		<% } %>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>