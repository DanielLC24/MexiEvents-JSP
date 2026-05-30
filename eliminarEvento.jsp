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
        response.sendRedirect("dashboard.jsp?mensaje=ID de evento no válido&tipo=danger");
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
        
        // Verificar si hay boletos asociados
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as total FROM boletos WHERE evento_id = " + id);
        int totalBoletos = 0;
        if (rs.next()) {
            totalBoletos = rs.getInt("total");
        }
        rs.close();
        stmt.close();
        
        if (totalBoletos > 0) {
            // Si hay boletos, solo desactivar el evento en lugar de eliminarlo
            String sql = "UPDATE eventos SET activo = FALSE WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            response.sendRedirect("dashboard.jsp?mensaje=Evento desactivado (tiene boletos asociados)&tipo=warning");
        } else {
            // Si no hay boletos, eliminar completamente
            String sql = "DELETE FROM eventos WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int resultado = pstmt.executeUpdate();
            
            if (resultado > 0) {
                response.sendRedirect("dashboard.jsp?mensaje=Evento eliminado exitosamente&tipo=success");
            } else {
                response.sendRedirect("dashboard.jsp?mensaje=Error al eliminar evento&tipo=danger");
            }
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

