<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	session.invalidate();
	Cookie[] cookies = request.getCookies();
	for(int i=0;i<cookies.length;i++){
		cookies[i].setMaxAge(0);
		response.addCookie(cookies[i]);
	}
	response.sendRedirect("/weak");
%>