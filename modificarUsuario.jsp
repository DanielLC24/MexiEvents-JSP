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
    
    // Procesar formulario si se envió
    String nombre = request.getParameter("nombre");
    String email = request.getParameter("email");
    String telefono = request.getParameter("telefono");
    
    if (nombre != null && email != null && !nombre.trim().isEmpty() && !email.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String url = "jdbc:mysql://localhost:3306/serv";
        String user = "root";
        String pass = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            
            String sql = "UPDATE usuarios SET nombre = ?, email = ?, telefono = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre.trim());
            pstmt.setString(2, email.trim());
            pstmt.setString(3, telefono != null && !telefono.trim().isEmpty() ? telefono.trim() : null);
            pstmt.setInt(4, id);
            
            int resultado = pstmt.executeUpdate();
            
            if (resultado > 0) {
                response.sendRedirect("dashboard.jsp?mensaje=Usuario actualizado exitosamente&tipo=success");
                return;
            } else {
                response.sendRedirect("dashboard.jsp?mensaje=Error al actualizar usuario&tipo=danger");
                return;
            }
            
        } catch (Exception e) {
            response.sendRedirect("dashboard.jsp?mensaje=Error: " + e.getMessage() + "&tipo=danger");
            return;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {}
        }
    }
    
    // Obtener datos del usuario para mostrar en el formulario
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    String nombreUsuario = "";
    String emailUsuario = "";
    String telefonoUsuario = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        
        String sql = "SELECT * FROM usuarios WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            nombreUsuario = rs.getString("nombre");
            emailUsuario = rs.getString("email");
            telefonoUsuario = rs.getString("telefono");
        } else {
            response.sendRedirect("dashboard.jsp?mensaje=Usuario no encontrado&tipo=danger");
            return;
        }
        
    } catch (Exception e) {
        response.sendRedirect("dashboard.jsp?mensaje=Error: " + e.getMessage() + "&tipo=danger");
        return;
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modificar Usuario</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-3">
        <div class="mb-3">
            <h3>Modificar Usuario</h3>
            <p>Usuario: <strong><%= session.getAttribute("usuario") %></strong> | 
            <a href="dashboard.jsp">Volver</a> | 
            <a href="logout.jsp">Cerrar Sesión</a></p>
        </div>
        
        <div>
                        <form method="POST" action="modificarUsuario.jsp?id=<%= id %>">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       value="<%= nombreUsuario %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="<%= emailUsuario %>" required>
                            </div>
                            <div class="mb-3">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="telefono" name="telefono" 
                                       value="<%= telefonoUsuario != null ? telefonoUsuario : "" %>">
                            </div>
                            <div class="mb-3">
                                <a href="dashboard.jsp" class="btn btn-secondary">Cancelar</a>
                                <button type="submit" class="btn btn-primary">Actualizar Usuario</button>
                            </div>
                        </form>
        </div>
    </div>
</body>
</html>



