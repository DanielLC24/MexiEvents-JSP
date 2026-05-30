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
    String descripcion = request.getParameter("descripcion");
    String fechaEvento = request.getParameter("fecha_evento");
    String lugar = request.getParameter("lugar");
    String ciudad = request.getParameter("ciudad");
    String direccion = request.getParameter("direccion");
    String imagen = request.getParameter("imagen_principal");
    String categoriaId = request.getParameter("categoria_id");
    String precio = request.getParameter("precio");
    String capacidad = request.getParameter("capacidad");
    String artista = request.getParameter("artista_organizador");
    String destacado = request.getParameter("destacado");
    
    if (nombre != null && fechaEvento != null && lugar != null && categoriaId != null && 
        precio != null && capacidad != null && !nombre.trim().isEmpty()) {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        String url = "jdbc:mysql://localhost:3306/serv";
        String user = "root";
        String pass = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, pass);
            
            // Verificar si las tablas existen
            Statement stmt = conn.createStatement();
            try {
                stmt.executeQuery("SELECT COUNT(*) FROM eventos");
            } catch (SQLException e) {
                // Redirigir a ejecutar script SQL
                response.sendRedirect("dashboard.jsp?mensaje=Por favor ejecuta primero el script SQL crear_tablas_eventos.sql&tipo=danger");
                return;
            }
            stmt.close();
            
            String sql = "INSERT INTO eventos (nombre, descripcion, fecha_evento, lugar, ciudad, direccion, " +
                        "imagen_principal, categoria_id, precio, capacidad, lugares_disponibles, " +
                        "artista_organizador, destacado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre.trim());
            pstmt.setString(2, descripcion != null ? descripcion.trim() : null);
            pstmt.setString(3, fechaEvento);
            pstmt.setString(4, lugar.trim());
            pstmt.setString(5, ciudad != null ? ciudad.trim() : "Ciudad de México");
            pstmt.setString(6, direccion != null ? direccion.trim() : null);
            pstmt.setString(7, imagen != null && !imagen.trim().isEmpty() ? imagen.trim() : null);
            pstmt.setInt(8, Integer.parseInt(categoriaId));
            
            double precioDouble = Double.parseDouble(precio);
            pstmt.setDouble(9, precioDouble);
            
            int capacidadInt = Integer.parseInt(capacidad);
            pstmt.setInt(10, capacidadInt);
            pstmt.setInt(11, capacidadInt); // lugares_disponibles inicial = capacidad
            
            pstmt.setString(12, artista != null && !artista.trim().isEmpty() ? artista.trim() : null);
            pstmt.setBoolean(13, destacado != null && destacado.equals("on"));
            
            int resultado = pstmt.executeUpdate();
            
            if (resultado > 0) {
                response.sendRedirect("dashboard.jsp?mensaje=Evento creado exitosamente&tipo=success");
                return;
            } else {
                response.sendRedirect("dashboard.jsp?mensaje=Error al crear evento&tipo=danger");
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
    
    // Obtener categorías para el select
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Evento - Admin</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
    <link href="proyecto2/css/estilos-eventos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: var(--gradient-primary);">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="dashboard.jsp">
                <i class="fas fa-calendar-alt me-2"></i>Eventos México - Admin
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="dashboard.jsp">
                    <i class="fas fa-arrow-left me-1"></i>Volver al Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card border-0 shadow-lg">
                    <div class="card-header" style="background: var(--gradient-primary); color: white;">
                        <h4 class="mb-0">
                            <i class="fas fa-plus-circle me-2"></i>Crear Nuevo Evento
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form method="POST" action="crearEvento.jsp">
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="nombre" class="form-label fw-semibold">
                                        Nombre del Evento <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           placeholder="Ej: Festival de Música en CDMX" required>
                                </div>
                                
                                <div class="col-md-12 mb-3">
                                    <label for="descripcion" class="form-label fw-semibold">Descripción</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" 
                                              rows="4" placeholder="Describe el evento..."></textarea>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="categoria_id" class="form-label fw-semibold">
                                        Categoría <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="categoria_id" name="categoria_id" required>
                                        <option value="">Selecciona una categoría</option>
                                        <%
                                            try {
                                                Class.forName("com.mysql.cj.jdbc.Driver");
                                                conn = DriverManager.getConnection(url, user, pass);
                                                stmt = conn.createStatement();
                                                
                                                try {
                                                    rs = stmt.executeQuery("SELECT * FROM categorias ORDER BY nombre");
                                                    while (rs.next()) {
                                                        int catId = rs.getInt("id");
                                                        String catNombre = rs.getString("nombre");
                                                        String catIcono = rs.getString("icono");
                                        %>
                                        <option value="<%= catId %>">
                                            <%= catIcono != null ? catIcono + " " : "" %><%= catNombre %>
                                        </option>
                                        <%
                                                    }
                                                } catch (SQLException e) {
                                                    // Tabla no existe aún
                                                }
                                            } catch (Exception e) {
                                                // Error de conexión
                                            } finally {
                                                try {
                                                    if (rs != null) rs.close();
                                                    if (stmt != null) stmt.close();
                                                    if (conn != null) conn.close();
                                                } catch (SQLException e) {}
                                            }
                                        %>
                                    </select>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="fecha_evento" class="form-label fw-semibold">
                                        Fecha y Hora <span class="text-danger">*</span>
                                    </label>
                                    <input type="datetime-local" class="form-control" id="fecha_evento" 
                                           name="fecha_evento" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="lugar" class="form-label fw-semibold">
                                        Lugar/Venue <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="lugar" name="lugar" 
                                           placeholder="Ej: Foro Sol" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="ciudad" class="form-label fw-semibold">Ciudad</label>
                                    <input type="text" class="form-control" id="ciudad" name="ciudad" 
                                           placeholder="Ciudad de México" value="Ciudad de México">
                                </div>
                                
                                <div class="col-md-12 mb-3">
                                    <label for="direccion" class="form-label fw-semibold">Dirección Completa</label>
                                    <input type="text" class="form-control" id="direccion" name="direccion" 
                                           placeholder="Av. Ejemplo 123, Colonia">
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="precio" class="form-label fw-semibold">
                                        Precio (MXN) <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="precio" name="precio" 
                                           step="0.01" min="0" value="0" required>
                                    <small class="text-muted">Usa 0 para eventos gratuitos</small>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="capacidad" class="form-label fw-semibold">
                                        Capacidad Total <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="capacidad" name="capacidad" 
                                           min="1" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="artista_organizador" class="form-label fw-semibold">
                                        Artista/Organizador
                                    </label>
                                    <input type="text" class="form-control" id="artista_organizador" 
                                           name="artista_organizador" placeholder="Nombre del artista o organizador">
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="imagen_principal" class="form-label fw-semibold">
                                        URL de Imagen Principal
                                    </label>
                                    <input type="url" class="form-control" id="imagen_principal" 
                                           name="imagen_principal" placeholder="https://ejemplo.com/imagen.jpg">
                                    <small class="text-muted">Pega la URL de la imagen del evento</small>
                                </div>
                                
                                <div class="col-md-12 mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="destacado" 
                                               name="destacado">
                                        <label class="form-check-label" for="destacado">
                                            <i class="fas fa-star text-warning me-1"></i>Marcar como Evento Destacado
                                        </label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-4">
                                <a href="dashboard.jsp" class="btn btn-secondary-custom">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="fas fa-save me-2"></i>Crear Evento
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="proyecto2/js/bootstrap.bundle.min.js"></script>
</body>
</html>

