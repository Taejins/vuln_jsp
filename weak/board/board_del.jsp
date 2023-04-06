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
		String id = request.getParameter("id");
		
		Connection conn = null;
		Statement stmt1 = null;
		Statement stmt2 = null;
		ResultSet rs = null;
		
	
		try{
			conn = DBConnection.getConnection();
			sql = "select * from jsp_board where board_id = "+id;
			stmt1 = conn.createStatement();
			rs = stmt1.executeQuery(sql);
			
			if(rs.next()){
				b_writer = rs.getString("board_writer");
				fileName = rs.getString("board_file");
			}
				
		}catch(Exception e){
			out.println("<h3>실패</h3>");
			e.printStackTrace();
			conn.close();
		}finally{
			rs.close();
			if(stmt1!=null)stmt1.close();
		}
		if(s_name==null||!s_name.equals(b_writer)){
			conn.close();	
			%>
				<script> 
					alert("접근이 불가합니다");
					location.href = "./";
				</script>
			<%
				
		}else{
			try{
				sql = "delete from jsp_board where board_id = "+id;
				stmt2 = conn.createStatement();
				stmt2.executeUpdate(sql);
				if(fileName!=null){
					String filePath = "C:\\Taejin\\Tomcat\\apache-tomcat-9.0.73\\webapps\\weak\\file\\" + fileName; 
					File file = new File(filePath);
					if(file.exists()) file.delete();
				}
			}catch(Exception e){
				out.println("<h3>실패</h3>");
				e.printStackTrace();
			}finally{
				if(stmt2!=null)stmt2.close();
				conn.close();
			}
			response.sendRedirect("./");
		}
	}
	
	
	

%>