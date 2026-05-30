<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // Invalidar la sesión
    session.invalidate();
    response.sendRedirect("login.jsp");
%>




