<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Verificar si el usuario está logueado
    String logueado = (String) session.getAttribute("logueado");
    if (logueado == null || !logueado.equals("true")) {
        response.sendRedirect("login.jsp?error=2");
        return;
    }
    
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    int totalEventos = 0;
    int eventosActivos = 0;
    int totalBoletos = 0;
    int boletosVendidos = 0;
    String eventoPopular = "N/A";
    int capacidadTotal = 0;
    int lugaresOcupados = 0;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        stmt = conn.createStatement();
        
        // Total de eventos
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM eventos");
        if (rs.next()) totalEventos = rs.getInt("total");
        rs.close();
        
        // Eventos activos
        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM eventos WHERE activo = TRUE AND fecha_evento >= NOW()");
        if (rs.next()) eventosActivos = rs.getInt("total");
        rs.close();
        
        // Total de boletos vendidos
        rs = stmt.executeQuery("SELECT COUNT(*) as total, SUM(cantidad) as cantidad FROM boletos WHERE estado = 'activo'");
        if (rs.next()) {
            totalBoletos = rs.getInt("total");
            boletosVendidos = rs.getInt("cantidad");
            if (boletosVendidos == 0) boletosVendidos = rs.getInt("total");
        }
        rs.close();
        
        // Evento más popular
        rs = stmt.executeQuery(
            "SELECT e.nombre, COUNT(b.id) as ventas " +
            "FROM eventos e " +
            "LEFT JOIN boletos b ON e.id = b.evento_id AND b.estado = 'activo' " +
            "GROUP BY e.id " +
            "ORDER BY ventas DESC, e.fecha_evento DESC " +
            "LIMIT 1"
        );
        if (rs.next()) {
            eventoPopular = rs.getString("nombre");
        }
        rs.close();
        
        // Capacidad total y lugares ocupados
        rs = stmt.executeQuery(
            "SELECT SUM(capacidad) as total_cap, SUM(capacidad - lugares_disponibles) as ocupados " +
            "FROM eventos WHERE activo = TRUE"
        );
        if (rs.next()) {
            capacidadTotal = rs.getInt("total_cap");
            lugaresOcupados = rs.getInt("ocupados");
        }
        rs.close();
        
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Eventos México</title>
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp" target="_blank">
                            <i class="fas fa-external-link-alt me-1"></i>Ver Sitio Web
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">
                            <i class="fas fa-sign-out-alt me-1"></i>Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container-fluid mt-4">
        <%
            String mensaje = request.getParameter("mensaje");
            String tipo = request.getParameter("tipo");
            if (mensaje != null) {
        %>
            <div class="alert alert-<%= tipo != null ? tipo : "success" %> alert-dismissible fade show" role="alert">
                <i class="fas fa-<%= tipo != null && tipo.equals("danger") ? "exclamation-circle" : "check-circle" %> me-2"></i>
                <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>

        <!-- Estadísticas -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="stats-card fade-in">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stats-label">Total Eventos</div>
                            <div class="stats-number"><%= totalEventos %></div>
                        </div>
                        <i class="fas fa-calendar fa-3x" style="color: var(--color-primary); opacity: 0.3;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stats-card fade-in" style="border-left-color: var(--color-success);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stats-label">Eventos Activos</div>
                            <div class="stats-number" style="color: var(--color-success);"><%= eventosActivos %></div>
                        </div>
                        <i class="fas fa-check-circle fa-3x" style="color: var(--color-success); opacity: 0.3;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stats-card fade-in" style="border-left-color: var(--color-warning);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stats-label">Boletos Vendidos</div>
                            <div class="stats-number" style="color: var(--color-warning);"><%= boletosVendidos %></div>
                        </div>
                        <i class="fas fa-ticket-alt fa-3x" style="color: var(--color-warning); opacity: 0.3;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="stats-card fade-in" style="border-left-color: var(--color-accent);">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="stats-label">Ocupación</div>
                            <div class="stats-number" style="color: var(--color-accent);">
                                <%= capacidadTotal > 0 ? (lugaresOcupados * 100 / capacidadTotal) : 0 %>%
                            </div>
                        </div>
                        <i class="fas fa-chart-line fa-3x" style="color: var(--color-accent); opacity: 0.3;"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Evento Popular -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card border-0 shadow-md">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-star text-warning me-2"></i>Evento Más Popular
                        </h5>
                        <p class="card-text fs-4 mb-0"><%= eventoPopular %></p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gestión de Eventos -->
        <div class="row">
            <div class="col-12">
                <div class="card border-0 shadow-lg">
                    <div class="card-header" style="background: var(--gradient-primary); color: white;">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>Gestión de Eventos
                            </h5>
                            <a href="crearEvento.jsp" class="btn btn-light btn-sm">
                                <i class="fas fa-plus me-2"></i>Nuevo Evento
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <%
                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection(url, user, pass);
                                stmt = conn.createStatement();
                                
                                // Verificar si la tabla existe
                                try {
                                    rs = stmt.executeQuery("SELECT COUNT(*) FROM eventos");
                                } catch (SQLException e) {
                                    // Si no existe, redirigir a crear primer evento
                                    out.println("<div class='alert alert-info'>");
                                    out.println("<i class='fas fa-info-circle me-2'></i>");
                                    out.println("No hay eventos registrados. <a href='crearEvento.jsp' class='alert-link'>Crear primer evento</a>");
                                    out.println("</div>");
                                    return;
                                }
                                
                                // Obtener eventos con categoría
                                rs = stmt.executeQuery(
                                    "SELECT e.*, c.nombre as categoria_nombre, c.icono as categoria_icono, " +
                                    "COUNT(b.id) as boletos_vendidos " +
                                    "FROM eventos e " +
                                    "LEFT JOIN categorias c ON e.categoria_id = c.id " +
                                    "LEFT JOIN boletos b ON e.id = b.evento_id AND b.estado = 'activo' " +
                                    "GROUP BY e.id " +
                                    "ORDER BY e.fecha_evento DESC"
                                );
                        %>
                        
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Imagen</th>
                                        <th>Evento</th>
                                        <th>Categoría</th>
                                        <th>Fecha</th>
                                        <th>Lugar</th>
                                        <th>Precio</th>
                                        <th>Disponibles</th>
                                        <th>Boletos</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        boolean hayEventos = false;
                                        while (rs.next()) {
                                            hayEventos = true;
                                            int id = rs.getInt("id");
                                            String nombre = rs.getString("nombre");
                                            String imagen = rs.getString("imagen_principal");
                                            String categoria = rs.getString("categoria_nombre");
                                            String icono = rs.getString("categoria_icono");
                                            String fecha = rs.getString("fecha_evento");
                                            String lugar = rs.getString("lugar");
                                            String ciudad = rs.getString("ciudad");
                                            double precio = rs.getDouble("precio");
                                            int disponibles = rs.getInt("lugares_disponibles");
                                            int capacidad = rs.getInt("capacidad");
                                            int boletosVend = rs.getInt("boletos_vendidos");
                                            boolean activo = rs.getBoolean("activo");
                                            boolean destacado = rs.getBoolean("destacado");
                                            
                                            // Formatear fecha
                                            if (fecha != null && fecha.length() > 10) {
                                                fecha = fecha.substring(0, 16).replace(" ", " - ");
                                            }
                                    %>
                                    <tr class="fade-in">
                                        <td>
                                            <% if (imagen != null && !imagen.isEmpty()) { %>
                                                <img src="<%= imagen %>" alt="<%= nombre %>" 
                                                     style="width: 80px; height: 60px; object-fit: cover; border-radius: 8px;">
                                            <% } else { %>
                                                <div style="width: 80px; height: 60px; background: var(--gradient-primary); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white;">
                                                    <i class="fas fa-image"></i>
                                                </div>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong><%= nombre %></strong>
                                            <% if (destacado) { %>
                                                <span class="badge bg-warning text-dark ms-2">
                                                    <i class="fas fa-star"></i> Destacado
                                                </span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary">
                                                <%= icono != null ? icono : "🎉" %> <%= categoria != null ? categoria : "Sin categoría" %>
                                            </span>
                                        </td>
                                        <td><small><%= fecha %></small></td>
                                        <td>
                                            <small>
                                                <i class="fas fa-map-marker-alt text-danger me-1"></i>
                                                <%= lugar %><br>
                                                <span class="text-muted"><%= ciudad %></span>
                                            </small>
                                        </td>
                                        <td>
                                            <% if (precio == 0) { %>
                                                <span class="badge bg-success">Gratis</span>
                                            <% } else { %>
                                                <strong>$<%= String.format("%.2f", precio) %></strong>
                                            <% } %>
                                        </td>
                                        <td>
                                            <small>
                                                <%= disponibles %> / <%= capacidad %>
                                                <div class="progress mt-1" style="height: 5px;">
                                                    <div class="progress-bar" role="progressbar" 
                                                         style="width: <%= capacidad > 0 ? (100 - (disponibles * 100 / capacidad)) : 0 %>%"
                                                         aria-valuenow="<%= capacidad - disponibles %>" 
                                                         aria-valuemin="0" 
                                                         aria-valuemax="<%= capacidad %>">
                                                    </div>
                                                </div>
                                            </small>
                                        </td>
                                        <td>
                                            <span class="badge bg-info"><%= boletosVend %></span>
                                        </td>
                                        <td>
                                            <% if (activo) { %>
                                                <span class="badge bg-success">Activo</span>
                                            <% } else { %>
                                                <span class="badge bg-secondary">Inactivo</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <a href="editarEvento.jsp?id=<%= id %>" 
                                                   class="btn btn-sm btn-warning" 
                                                   title="Editar">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="eliminarEvento.jsp?id=<%= id %>" 
                                                   class="btn btn-sm btn-danger"
                                                   onclick="return confirm('¿Está seguro de eliminar este evento? Esta acción no se puede deshacer.');"
                                                   title="Eliminar">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        
                                        if (!hayEventos) {
                                    %>
                                    <tr>
                                        <td colspan="10" class="text-center text-muted py-5">
                                            <i class="fas fa-calendar-times fa-3x mb-3 d-block" style="opacity: 0.3;"></i>
                                            <p>No hay eventos registrados.</p>
                                            <a href="crearEvento.jsp" class="btn btn-primary-custom">
                                                <i class="fas fa-plus me-2"></i>Crear Primer Evento
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>
                        
                        <%
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                            } finally {
                                try {
                                    if (rs != null) rs.close();
                                    if (stmt != null) stmt.close();
                                    if (conn != null) conn.close();
                                } catch (SQLException e) {}
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="proyecto2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
