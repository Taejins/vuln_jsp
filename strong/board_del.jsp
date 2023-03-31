<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@ page import="DBconn.DBConnection" %>
<%@ page import = "java.sql.*" %>

<%@ include file="/WEB-INF/jsp/header.jsp"%>

<%
	request.setCharacterEncoding("utf-8");
	String fileName = null;
	String b_writer = null;
	String sql = null;
	
	if(request.getMethod().equals("GET")){
		int b_id = Integer.parseInt(request.getParameter("id"));
		
		Connection conn = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		
	
		try{
			conn = DBConnection.getConnection();
			sql = "select * from jsp_board where board_id = ?";
			pstmt1 = conn.prepareStatement(sql);
			pstmt1.setInt(1, b_id);
			rs = pstmt1.executeQuery();
			
			while(rs.next()){
				b_id = rs.getInt("board_id");
				b_writer = rs.getString("board_writer");
				fileName = rs.getString("board_file");
			}
				
		}catch(Exception e){
			out.println("<h3>실패</h3>");
			e.printStackTrace();
			conn.close();
		}finally{
			rs.close();
			if(pstmt1!=null)pstmt1.close();
		}
		if(s_name==null||!s_name.equals(b_writer)){
			conn.close();	
			%>
				<script> 
					alert("접근이 불가합니다");
					location.href = "./board.jsp";
				</script>
			<%
				
		}else{
			try{
				sql = "delete from jsp_board where board_id = ?";
				pstmt2 = conn.prepareStatement(sql);
				pstmt2.setInt(1, b_id);
				pstmt2.executeUpdate();
				if(fileName!=null){
					String filePath = "C:\\Taejin\\Tomcat\\apache-tomcat-9.0.73\\webapps\\myapp\\file\\" + fileName; 
					File file = new File(filePath);
					if(file.exists()) file.delete();
				}
			}catch(Exception e){
				out.println("<h3>실패</h3>");
				e.printStackTrace();
			}finally{
				if(pstmt2!=null)pstmt2.close();
				conn.close();
			}
			response.sendRedirect("./board.jsp");
		}
	}
	
	
	

%>