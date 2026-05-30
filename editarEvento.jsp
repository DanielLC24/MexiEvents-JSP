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
    String activo = request.getParameter("activo");
    
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
            
            // Obtener capacidad actual para calcular diferencia en lugares_disponibles
            Statement stmt = conn.createStatement();
            ResultSet rsCap = stmt.executeQuery("SELECT capacidad, lugares_disponibles FROM eventos WHERE id = " + id);
            int capacidadAnterior = 0;
            int disponiblesAnterior = 0;
            if (rsCap.next()) {
                capacidadAnterior = rsCap.getInt("capacidad");
                disponiblesAnterior = rsCap.getInt("lugares_disponibles");
            }
            rsCap.close();
            stmt.close();
            
            int capacidadNueva = Integer.parseInt(capacidad);
            int diferencia = capacidadNueva - capacidadAnterior;
            int nuevosDisponibles = disponiblesAnterior + diferencia;
            if (nuevosDisponibles < 0) nuevosDisponibles = 0;
            if (nuevosDisponibles > capacidadNueva) nuevosDisponibles = capacidadNueva;
            
            String sql = "UPDATE eventos SET nombre = ?, descripcion = ?, fecha_evento = ?, lugar = ?, " +
                        "ciudad = ?, direccion = ?, imagen_principal = ?, categoria_id = ?, precio = ?, " +
                        "capacidad = ?, lugares_disponibles = ?, artista_organizador = ?, destacado = ?, activo = ? " +
                        "WHERE id = ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre.trim());
            pstmt.setString(2, descripcion != null ? descripcion.trim() : null);
            pstmt.setString(3, fechaEvento);
            pstmt.setString(4, lugar.trim());
            pstmt.setString(5, ciudad != null ? ciudad.trim() : "Ciudad de México");
            pstmt.setString(6, direccion != null ? direccion.trim() : null);
            pstmt.setString(7, imagen != null && !imagen.trim().isEmpty() ? imagen.trim() : null);
            pstmt.setInt(8, Integer.parseInt(categoriaId));
            pstmt.setDouble(9, Double.parseDouble(precio));
            pstmt.setInt(10, capacidadNueva);
            pstmt.setInt(11, nuevosDisponibles);
            pstmt.setString(12, artista != null && !artista.trim().isEmpty() ? artista.trim() : null);
            pstmt.setBoolean(13, destacado != null && destacado.equals("on"));
            pstmt.setBoolean(14, activo != null && activo.equals("on"));
            pstmt.setInt(15, id);
            
            int resultado = pstmt.executeUpdate();
            
            if (resultado > 0) {
                response.sendRedirect("dashboard.jsp?mensaje=Evento actualizado exitosamente&tipo=success");
                return;
            } else {
                response.sendRedirect("dashboard.jsp?mensaje=Error al actualizar evento&tipo=danger");
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
    
    // Obtener datos del evento
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    String nombreEvento = "";
    String descripcionEvento = "";
    String fechaEventoStr = "";
    String lugarEvento = "";
    String ciudadEvento = "";
    String direccionEvento = "";
    String imagenEvento = "";
    int categoriaIdEvento = 0;
    double precioEvento = 0;
    int capacidadEvento = 0;
    int disponiblesEvento = 0;
    String artistaEvento = "";
    boolean destacadoEvento = false;
    boolean activoEvento = true;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        
        String sql = "SELECT * FROM eventos WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            nombreEvento = rs.getString("nombre");
            descripcionEvento = rs.getString("descripcion");
            fechaEventoStr = rs.getString("fecha_evento");
            lugarEvento = rs.getString("lugar");
            ciudadEvento = rs.getString("ciudad");
            direccionEvento = rs.getString("direccion");
            imagenEvento = rs.getString("imagen_principal");
            categoriaIdEvento = rs.getInt("categoria_id");
            precioEvento = rs.getDouble("precio");
            capacidadEvento = rs.getInt("capacidad");
            disponiblesEvento = rs.getInt("lugares_disponibles");
            artistaEvento = rs.getString("artista_organizador");
            destacadoEvento = rs.getBoolean("destacado");
            activoEvento = rs.getBoolean("activo");
            
            // Formatear fecha para input datetime-local
            if (fechaEventoStr != null && fechaEventoStr.length() > 10) {
                fechaEventoStr = fechaEventoStr.substring(0, 16);
            }
        } else {
            response.sendRedirect("dashboard.jsp?mensaje=Evento no encontrado&tipo=danger");
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
    <title>Editar Evento - Admin</title>
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
                            <i class="fas fa-edit me-2"></i>Editar Evento
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        <form method="POST" action="editarEvento.jsp?id=<%= id %>">
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="nombre" class="form-label fw-semibold">
                                        Nombre del Evento <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="nombre" name="nombre" 
                                           value="<%= nombreEvento %>" required>
                                </div>
                                
                                <div class="col-md-12 mb-3">
                                    <label for="descripcion" class="form-label fw-semibold">Descripción</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" 
                                              rows="4"><%= descripcionEvento != null ? descripcionEvento : "" %></textarea>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="categoria_id" class="form-label fw-semibold">
                                        Categoría <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="categoria_id" name="categoria_id" required>
                                        <option value="">Selecciona una categoría</option>
                                        <%
                                            Connection conn2 = null;
                                            Statement stmt2 = null;
                                            ResultSet rs2 = null;
                                            try {
                                                Class.forName("com.mysql.cj.jdbc.Driver");
                                                conn2 = DriverManager.getConnection(url, user, pass);
                                                stmt2 = conn2.createStatement();
                                                
                                                try {
                                                    rs2 = stmt2.executeQuery("SELECT * FROM categorias ORDER BY nombre");
                                                    while (rs2.next()) {
                                                        int catId = rs2.getInt("id");
                                                        String catNombre = rs2.getString("nombre");
                                                        String catIcono = rs2.getString("icono");
                                        %>
                                        <option value="<%= catId %>" <%= catId == categoriaIdEvento ? "selected" : "" %>>
                                            <%= catIcono != null ? catIcono + " " : "" %><%= catNombre %>
                                        </option>
                                        <%
                                                    }
                                                } catch (SQLException e) {}
                                            } catch (Exception e) {}
                                            finally {
                                                try {
                                                    if (rs2 != null) rs2.close();
                                                    if (stmt2 != null) stmt2.close();
                                                    if (conn2 != null) conn2.close();
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
                                           name="fecha_evento" value="<%= fechaEventoStr %>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="lugar" class="form-label fw-semibold">
                                        Lugar/Venue <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="lugar" name="lugar" 
                                           value="<%= lugarEvento %>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="ciudad" class="form-label fw-semibold">Ciudad</label>
                                    <input type="text" class="form-control" id="ciudad" name="ciudad" 
                                           value="<%= ciudadEvento != null ? ciudadEvento : "Ciudad de México" %>">
                                </div>
                                
                                <div class="col-md-12 mb-3">
                                    <label for="direccion" class="form-label fw-semibold">Dirección Completa</label>
                                    <input type="text" class="form-control" id="direccion" name="direccion" 
                                           value="<%= direccionEvento != null ? direccionEvento : "" %>">
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="precio" class="form-label fw-semibold">
                                        Precio (MXN) <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="precio" name="precio" 
                                           step="0.01" min="0" value="<%= precioEvento %>" required>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="capacidad" class="form-label fw-semibold">
                                        Capacidad Total <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="capacidad" name="capacidad" 
                                           min="1" value="<%= capacidadEvento %>" required>
                                    <small class="text-muted">Lugares disponibles actuales: <%= disponiblesEvento %></small>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="artista_organizador" class="form-label fw-semibold">
                                        Artista/Organizador
                                    </label>
                                    <input type="text" class="form-control" id="artista_organizador" 
                                           name="artista_organizador" 
                                           value="<%= artistaEvento != null ? artistaEvento : "" %>">
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="imagen_principal" class="form-label fw-semibold">
                                        URL de Imagen Principal
                                    </label>
                                    <input type="url" class="form-control" id="imagen_principal" 
                                           name="imagen_principal" 
                                           value="<%= imagenEvento != null ? imagenEvento : "" %>">
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="destacado" 
                                               name="destacado" <%= destacadoEvento ? "checked" : "" %>>
                                        <label class="form-check-label" for="destacado">
                                            <i class="fas fa-star text-warning me-1"></i>Marcar como Evento Destacado
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="activo" 
                                               name="activo" <%= activoEvento ? "checked" : "" %>>
                                        <label class="form-check-label" for="activo">
                                            <i class="fas fa-toggle-on text-success me-1"></i>Evento Activo
                                        </label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-between mt-4">
                                <a href="dashboard.jsp" class="btn btn-secondary-custom">
                                    <i class="fas fa-times me-2"></i>Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="fas fa-save me-2"></i>Guardar Cambios
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

