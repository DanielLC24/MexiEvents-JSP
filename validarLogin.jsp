<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String usuario = request.getParameter("usuario");
    String password = request.getParameter("password");
    
    // Credenciales válidas
    String usuarioValido = "admin";
    String passwordValido = "12345";
    
    if (usuario != null && password != null && 
        usuario.equals(usuarioValido) && password.equals(passwordValido)) {
        // Credenciales correctas, crear sesión
        session.setAttribute("usuario", usuario);
        session.setAttribute("logueado", "true");
        response.sendRedirect("dashboard.jsp");
    } else {
        // Credenciales incorrectas
        response.sendRedirect("login.jsp?error=1");
    }
%>




