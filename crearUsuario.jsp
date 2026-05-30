<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Verificar si el usuario está logueado
    String logueado = (String) session.getAttribute("logueado");
    if (logueado == null || !logueado.equals("true")) {
        response.sendRedirect("login.jsp?error=2");
        return;
    }
    
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
            
            // Verificar si la tabla existe, si no, crearla
            Statement stmt = conn.createStatement();
            try {
                stmt.executeQuery("SELECT COUNT(*) FROM usuarios");
            } catch (SQLException e) {
                stmt.executeUpdate(
                    "CREATE TABLE IF NOT EXISTS usuarios (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "nombre VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL, " +
                    "telefono VARCHAR(20), " +
                    "fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")"
                );
            }
            stmt.close();
            
            // Insertar nuevo usuario
            String sql = "INSERT INTO usuarios (nombre, email, telefono) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre.trim());
            pstmt.setString(2, email.trim());
            pstmt.setString(3, telefono != null && !telefono.trim().isEmpty() ? telefono.trim() : null);
            
            int resultado = pstmt.executeUpdate();
            
            if (resultado > 0) {
                response.sendRedirect("dashboard.jsp?mensaje=Usuario creado exitosamente&tipo=success");
                return;
            } else {
                response.sendRedirect("dashboard.jsp?mensaje=Error al crear usuario&tipo=danger");
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
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Usuario</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-3">
        <div class="mb-3">
            <h3>Crear Nuevo Usuario</h3>
            <p>Usuario: <strong><%= session.getAttribute("usuario") %></strong> | 
            <a href="dashboard.jsp">Volver</a> | 
            <a href="logout.jsp">Cerrar Sesión</a></p>
        </div>
        
        <div>
                        <form method="POST" action="crearUsuario.jsp">
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="nombre" name="nombre" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="telefono" name="telefono">
                            </div>
                            <div class="mb-3">
                                <a href="dashboard.jsp" class="btn btn-secondary">Cancelar</a>
                                <button type="submit" class="btn btn-primary">Crear Usuario</button>
                            </div>
                        </form>
        </div>
    </div>
</body>
</html>



