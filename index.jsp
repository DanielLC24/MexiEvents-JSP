<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // Parámetros de búsqueda y filtros
    String busqueda = request.getParameter("busqueda");
    String categoria = request.getParameter("categoria");
    String ciudad = request.getParameter("ciudad");
    String fecha = request.getParameter("fecha");
    String precioMax = request.getParameter("precio_max");
    
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    // Construir query
    StringBuilder query = new StringBuilder(
        "SELECT e.*, c.nombre as categoria_nombre, c.icono as categoria_icono " +
        "FROM eventos e " +
        "LEFT JOIN categorias c ON e.categoria_id = c.id " +
        "WHERE e.activo = TRUE AND e.fecha_evento >= NOW() "
    );
    
    if (busqueda != null && !busqueda.trim().isEmpty()) {
        query.append("AND (e.nombre LIKE '%").append(busqueda).append("%' ");
        query.append("OR e.artista_organizador LIKE '%").append(busqueda).append("%' ");
        query.append("OR e.lugar LIKE '%").append(busqueda).append("%') ");
    }
    
    if (categoria != null && !categoria.trim().isEmpty() && !categoria.equals("todas")) {
        query.append("AND e.categoria_id = ").append(categoria).append(" ");
    }
    
    if (ciudad != null && !ciudad.trim().isEmpty() && !ciudad.equals("todas")) {
        query.append("AND e.ciudad LIKE '%").append(ciudad).append("%' ");
    }
    
    if (fecha != null && !fecha.trim().isEmpty()) {
        query.append("AND DATE(e.fecha_evento) = '").append(fecha).append("' ");
    }
    
    if (precioMax != null && !precioMax.trim().isEmpty()) {
        try {
            double precio = Double.parseDouble(precioMax);
            query.append("AND e.precio <= ").append(precio).append(" ");
        } catch (NumberFormatException e) {}
    }
    
    query.append("ORDER BY e.destacado DESC, e.fecha_evento ASC");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eventos México - Encuentra los Mejores Eventos</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
    <link href="proyecto2/css/estilos-eventos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top" style="background: var(--gradient-primary); box-shadow: var(--shadow-md);">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="index.jsp">
                <i class="fas fa-calendar-alt me-2"></i>Eventos México
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">
                            <i class="fas fa-home me-1"></i>Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="misBoletos.jsp">
                            <i class="fas fa-ticket-alt me-1"></i>Mis Boletos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">
                            <i class="fas fa-user-shield me-1"></i>Admin
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container hero-content">
            <div class="row justify-content-center text-center">
                <div class="col-lg-8">
                    <h1 class="display-4 fw-bold mb-4 fade-in">
                        <i class="fas fa-star me-3"></i>Encuentra los Mejores Eventos en México
                    </h1>
                    <p class="lead mb-5 fade-in">
                        Conciertos, deportes, teatro y más. Vive experiencias únicas.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Búsqueda y Filtros -->
    <div class="container mt-4">
        <div class="search-section fade-in">
            <form method="GET" action="index.jsp" id="searchForm">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="busqueda" class="form-label fw-semibold">
                            <i class="fas fa-search me-2"></i>Buscar Evento
                        </label>
                        <input type="text" class="form-control search-input" id="busqueda" name="busqueda" 
                               placeholder="Nombre, artista o lugar..." value="<%= busqueda != null ? busqueda : "" %>">
                    </div>
                    <div class="col-md-3">
                        <label for="categoria" class="form-label fw-semibold">
                            <i class="fas fa-tags me-2"></i>Categoría
                        </label>
                        <select class="form-select" id="categoria" name="categoria">
                            <option value="todas">Todas las categorías</option>
                            <%
                                try {
                                    Class.forName("com.mysql.cj.jdbc.Driver");
                                    conn = DriverManager.getConnection(url, user, pass);
                                    stmt = conn.createStatement();
                                    
                                    try {
                                        ResultSet rsCat = stmt.executeQuery("SELECT * FROM categorias ORDER BY nombre");
                                        while (rsCat.next()) {
                                            int catId = rsCat.getInt("id");
                                            String catNombre = rsCat.getString("nombre");
                                            String catIcono = rsCat.getString("icono");
                            %>
                            <option value="<%= catId %>" <%= categoria != null && categoria.equals(String.valueOf(catId)) ? "selected" : "" %>>
                                <%= catIcono != null ? catIcono + " " : "" %><%= catNombre %>
                            </option>
                            <%
                                        }
                                        rsCat.close();
                                    } catch (SQLException e) {}
                                } catch (Exception e) {}
                            %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="ciudad" class="form-label fw-semibold">
                            <i class="fas fa-map-marker-alt me-2"></i>Ciudad
                        </label>
                        <select class="form-select" id="ciudad" name="ciudad">
                            <option value="todas">Todas las ciudades</option>
                            <option value="Ciudad de México" <%= ciudad != null && ciudad.equals("Ciudad de México") ? "selected" : "" %>>Ciudad de México</option>
                            <option value="Guadalajara" <%= ciudad != null && ciudad.equals("Guadalajara") ? "selected" : "" %>>Guadalajara</option>
                            <option value="Monterrey" <%= ciudad != null && ciudad.equals("Monterrey") ? "selected" : "" %>>Monterrey</option>
                            <option value="Puebla" <%= ciudad != null && ciudad.equals("Puebla") ? "selected" : "" %>>Puebla</option>
                            <option value="Cancún" <%= ciudad != null && ciudad.equals("Cancún") ? "selected" : "" %>>Cancún</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label for="fecha" class="form-label fw-semibold">
                            <i class="fas fa-calendar me-2"></i>Fecha
                        </label>
                        <input type="date" class="form-control" id="fecha" name="fecha" 
                               value="<%= fecha != null ? fecha : "" %>">
                    </div>
                    <div class="col-md-4">
                        <label for="precio_max" class="form-label fw-semibold">
                            <i class="fas fa-dollar-sign me-2"></i>Precio Máximo
                        </label>
                        <input type="number" class="form-control" id="precio_max" name="precio_max" 
                               step="0.01" min="0" placeholder="Sin límite"
                               value="<%= precioMax != null ? precioMax : "" %>">
                    </div>
                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary-custom w-100 me-2">
                            <i class="fas fa-search me-2"></i>Buscar
                        </button>
                        <a href="index.jsp" class="btn btn-secondary-custom">
                            <i class="fas fa-redo me-2"></i>Limpiar
                        </a>
                    </div>
                </div>
            </form>
        </div>

        <!-- Lista de Eventos -->
        <div class="row mb-4">
            <div class="col-12">
                <h3 class="fw-bold mb-4">
                    <i class="fas fa-calendar-check me-2"></i>Eventos Disponibles
                </h3>
            </div>
        </div>

        <div class="row g-4">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, user, pass);
                    stmt = conn.createStatement();
                    
                    try {
                        rs = stmt.executeQuery(query.toString());
                        boolean hayEventos = false;
                        int contador = 0;
                        
                        while (rs.next()) {
                            hayEventos = true;
                            contador++;
                            int id = rs.getInt("id");
                            String nombre = rs.getString("nombre");
                            String descripcion = rs.getString("descripcion");
                            String imagen = rs.getString("imagen_principal");
                            String fechaEvento = rs.getString("fecha_evento");
                            String lugar = rs.getString("lugar");
                            String ciudadEvento = rs.getString("ciudad");
                            double precio = rs.getDouble("precio");
                            int disponibles = rs.getInt("lugares_disponibles");
                            String categoriaNombre = rs.getString("categoria_nombre");
                            String categoriaIcono = rs.getString("categoria_icono");
                            boolean destacado = rs.getBoolean("destacado");
                            
                            // Formatear fecha
                            String fechaFormateada = "";
                            if (fechaEvento != null && fechaEvento.length() > 10) {
                                fechaFormateada = fechaEvento.substring(0, 16).replace(" ", " - ");
                            }
                            
                            // Limitar descripción
                            String descCorta = "";
                            if (descripcion != null && descripcion.length() > 150) {
                                descCorta = descripcion.substring(0, 150) + "...";
                            } else {
                                descCorta = descripcion != null ? descripcion : "";
                            }
            %>
            <div class="col-md-6 col-lg-4 fade-in" style="animation-delay: <%= contador * 0.1 %>s;">
                <div class="event-card">
                    <% if (destacado) { %>
                        <div class="position-absolute top-0 end-0 m-2">
                            <span class="badge bg-warning text-dark">
                                <i class="fas fa-star"></i> Destacado
                            </span>
                        </div>
                    <% } %>
                    <div style="overflow: hidden; height: 250px;">
                        <% if (imagen != null && !imagen.isEmpty()) { %>
                            <img src="<%= imagen %>" alt="<%= nombre %>" class="event-card-img">
                        <% } else { %>
                            <div class="event-card-img" style="background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                        <% } %>
                    </div>
                    <div class="event-card-body">
                        <h5 class="event-card-title"><%= nombre %></h5>
                        <div class="event-card-meta">
                            <span>
                                <i class="fas fa-tag"></i>
                                <%= categoriaIcono != null ? categoriaIcono + " " : "" %><%= categoriaNombre != null ? categoriaNombre : "Sin categoría" %>
                            </span>
                        </div>
                        <div class="event-card-meta">
                            <span><i class="fas fa-calendar"></i><%= fechaFormateada %></span>
                        </div>
                        <div class="event-card-meta">
                            <span><i class="fas fa-map-marker-alt"></i><%= lugar %>, <%= ciudadEvento %></span>
                        </div>
                        <% if (!descCorta.isEmpty()) { %>
                            <p class="event-card-description"><%= descCorta %></p>
                        <% } %>
                        <div class="event-card-footer">
                            <div>
                                <% if (precio == 0) { %>
                                    <span class="event-price event-price-free">Gratis</span>
                                <% } else { %>
                                    <span class="event-price">$<%= String.format("%.0f", precio) %></span>
                                <% } %>
                                <small class="d-block text-muted"><%= disponibles %> disponibles</small>
                            </div>
                            <a href="detalleEvento.jsp?id=<%= id %>" class="btn btn-primary-custom btn-sm">
                                Ver Detalles
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                        }
                        
                        if (!hayEventos) {
            %>
            <div class="col-12">
                <div class="card border-0 shadow-md text-center py-5">
                    <div class="card-body">
                        <i class="fas fa-calendar-times fa-4x text-muted mb-3" style="opacity: 0.3;"></i>
                        <h4 class="text-muted">No se encontraron eventos</h4>
                        <p class="text-muted">Intenta ajustar tus filtros de búsqueda</p>
                        <a href="index.jsp" class="btn btn-primary-custom">
                            <i class="fas fa-redo me-2"></i>Ver Todos los Eventos
                        </a>
                    </div>
                </div>
            </div>
            <%
                        }
                    } catch (SQLException e) {
            %>
            <div class="col-12">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    Por favor ejecuta el script SQL <code>crear_tablas_eventos.sql</code> primero.
                </div>
            </div>
            <%
                    }
                } catch (Exception e) {
            %>
            <div class="col-12">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    Error al cargar eventos: <%= e.getMessage() %>
                </div>
            </div>
            <%
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

    <!-- Footer -->
    <footer class="mt-5 py-4" style="background: var(--color-dark); color: white;">
        <div class="container text-center">
            <p class="mb-0">
                <i class="fas fa-calendar-alt me-2"></i>Eventos México © 2024
            </p>
            <p class="text-muted small mt-2">
                Encuentra los mejores eventos en México
            </p>
        </div>
    </footer>

    <script src="proyecto2/js/bootstrap.bundle.min.js"></script>
    <script src="proyecto2/js/jquery-3.7.1.min.js"></script>
</body>
</html>
