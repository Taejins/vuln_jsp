<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>

<%@ page import="DBconn.DBConnection" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>
	
<% if(s_name==null){%>
	<script>
		alert("로그인 후 이용해 주세요");
		location.href = "./login.jsp";
	</script>
<%
	}else{
		
	//세션에서 가져온 이름
	String writer = s_name; 
	
	if(request.getMethod().equals("POST")){
		Connection conn = null;
		Statement stmt = null;
		
		//multiRequest로 인코딩된 입력값을 받음
		String saveFolder = application.getRealPath("/file") ;
		String encType = "UTF-8";
		int maxSize = 5 * 1024 * 1024;
		
		try {
			MultipartRequest multi = null;
			multi = new MultipartRequest(request, saveFolder, maxSize,
					encType, new DefaultFileRenamePolicy());
			String title = multi.getParameter("title");
			String content = multi.getParameter("content");
			
			
			//오늘 날짜 구하기
			java.util.Date today = new java.util.Date();
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String w_date = df.format(today);
			
			//서버에 저장된 파일명
			String file = multi.getFilesystemName("file");
		
			conn = DBConnection.getConnection();
			String sql = "insert into jsp_board values(board_id.nextval, '"+title+"','"+content+"','"+writer+"','"+w_date+"','"+file+"')";
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
	}
		
%>
<section class="three">
	<h3>게시글 작성 페이지</h3>
	<br>
	<form id="b_write" action="./board_write.jsp" method="POST" enctype="multipart/form-data">
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
						<input type="text" name="title">
					</td>
				</tr>
				<tr>
					<td colspan="4" class="view_text">
						<textarea name="content" form="b_write" cols="30" rows="5"></textarea>
					</td>
				</tr>
				<tr>
					<th scope="row">첨부파일</th>
					<td>
						<input type="file" name="file">
					</td>
					
				</tr>
			</tbody>
		</table>
		
		<input type="submit" value="확인"/>
	</form>
</section>
<% } %>
		
<%@ include file="/WEB-INF/jsp/footer.jsp"%>