<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Verificar si el usuario está logueado
    String logueado = (String) session.getAttribute("logueado");
    if (logueado == null || !logueado.equals("true")) {
        response.sendRedirect("login.jsp?error=2");
        return;
    }
    
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("dashboard.jsp?mensaje=ID de usuario no válido&tipo=danger");
        return;
    }
    
    int id = Integer.parseInt(idParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        
        String sql = "DELETE FROM usuarios WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        
        int resultado = pstmt.executeUpdate();
        
        if (resultado > 0) {
            response.sendRedirect("dashboard.jsp?mensaje=Usuario eliminado exitosamente&tipo=success");
        } else {
            response.sendRedirect("dashboard.jsp?mensaje=Error al eliminar usuario&tipo=danger");
        }
        
    } catch (Exception e) {
        response.sendRedirect("dashboard.jsp?mensaje=Error: " + e.getMessage() + "&tipo=danger");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>




