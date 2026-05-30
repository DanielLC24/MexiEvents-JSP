<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int id = Integer.parseInt(idParam);
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    String nombre = "";
    String descripcion = "";
    String imagen = "";
    String fechaEvento = "";
    String lugar = "";
    String ciudad = "";
    String direccion = "";
    double precio = 0;
    int disponibles = 0;
    int capacidad = 0;
    String artista = "";
    String categoriaNombre = "";
    String categoriaIcono = "";
    boolean activo = false;
    Date fechaEventoDate = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        
        String sql = "SELECT e.*, c.nombre as categoria_nombre, c.icono as categoria_icono " +
                    "FROM eventos e " +
                    "LEFT JOIN categorias c ON e.categoria_id = c.id " +
                    "WHERE e.id = ? AND e.activo = TRUE";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, id);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            nombre = rs.getString("nombre");
            descripcion = rs.getString("descripcion");
            imagen = rs.getString("imagen_principal");
            fechaEvento = rs.getString("fecha_evento");
            lugar = rs.getString("lugar");
            ciudad = rs.getString("ciudad");
            direccion = rs.getString("direccion");
            precio = rs.getDouble("precio");
            disponibles = rs.getInt("lugares_disponibles");
            capacidad = rs.getInt("capacidad");
            artista = rs.getString("artista_organizador");
            categoriaNombre = rs.getString("categoria_nombre");
            categoriaIcono = rs.getString("categoria_icono");
            activo = rs.getBoolean("activo");
            
            // Parsear fecha para contador
            if (fechaEvento != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                try {
                    fechaEventoDate = sdf.parse(fechaEvento);
                } catch (Exception e) {}
            }
        } else {
            response.sendRedirect("index.jsp");
            return;
        }
        
    } catch (Exception e) {
        response.sendRedirect("index.jsp");
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
    <title><%= nombre %> - Eventos México</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
    <link href="proyecto2/css/estilos-eventos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: var(--gradient-primary);">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.jsp">
                <i class="fas fa-calendar-alt me-2"></i>Eventos México
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="index.jsp">
                    <i class="fas fa-arrow-left me-1"></i>Volver
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Image -->
    <div class="event-detail-hero">
        <% if (imagen != null && !imagen.isEmpty()) { %>
            <img src="<%= imagen %>" alt="<%= nombre %>">
        <% } else { %>
            <div style="width: 100%; height: 100%; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: white; font-size: 5rem;">
                <i class="fas fa-calendar-alt"></i>
            </div>
        <% } %>
        <div class="event-detail-content">
            <div class="container">
                <h1 class="display-5 fw-bold mb-3"><%= nombre %></h1>
                <div class="d-flex flex-wrap gap-3 mb-3">
                    <span class="badge bg-light text-dark fs-6">
                        <%= categoriaIcono != null ? categoriaIcono + " " : "" %><%= categoriaNombre != null ? categoriaNombre : "Evento" %>
                    </span>
                    <% if (artista != null && !artista.isEmpty()) { %>
                        <span class="badge bg-light text-dark fs-6">
                            <i class="fas fa-user me-1"></i><%= artista %>
                        </span>
                    <% } %>
                </div>
                
                <!-- Contador Regresivo -->
                <% if (fechaEventoDate != null && fechaEventoDate.after(new Date())) { %>
                <div class="countdown" id="countdown">
                    <div class="countdown-item">
                        <span class="countdown-number" id="days">0</span>
                        <span class="countdown-label">Días</span>
                    </div>
                    <div class="countdown-item">
                        <span class="countdown-number" id="hours">0</span>
                        <span class="countdown-label">Horas</span>
                    </div>
                    <div class="countdown-item">
                        <span class="countdown-number" id="minutes">0</span>
                        <span class="countdown-label">Minutos</span>
                    </div>
                    <div class="countdown-item">
                        <span class="countdown-number" id="seconds">0</span>
                        <span class="countdown-label">Segundos</span>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <div class="container mt-5 mb-5">
        <div class="row">
            <!-- Información del Evento -->
            <div class="col-lg-8 mb-4">
                <div class="card border-0 shadow-lg mb-4">
                    <div class="card-body p-4">
                        <h3 class="fw-bold mb-4">
                            <i class="fas fa-info-circle me-2"></i>Información del Evento
                        </h3>
                        
                        <div class="mb-4">
                            <h5 class="fw-semibold mb-3">
                                <i class="fas fa-calendar-alt text-primary me-2"></i>Fecha y Hora
                            </h5>
                            <p class="fs-5 mb-0"><%= fechaEvento.substring(0, 16).replace(" ", " - ") %></p>
                        </div>
                        
                        <div class="mb-4">
                            <h5 class="fw-semibold mb-3">
                                <i class="fas fa-map-marker-alt text-danger me-2"></i>Ubicación
                            </h5>
                            <p class="fs-5 mb-1"><strong><%= lugar %></strong></p>
                            <p class="text-muted mb-1"><%= ciudad %></p>
                            <% if (direccion != null && !direccion.isEmpty()) { %>
                                <p class="text-muted small"><%= direccion %></p>
                            <% } %>
                        </div>
                        
                        <% if (descripcion != null && !descripcion.isEmpty()) { %>
                        <div class="mb-4">
                            <h5 class="fw-semibold mb-3">
                                <i class="fas fa-align-left text-primary me-2"></i>Descripción
                            </h5>
                            <p class="text-muted" style="white-space: pre-line;"><%= descripcion %></p>
                        </div>
                        <% } %>
                        
                        <div class="mb-4">
                            <h5 class="fw-semibold mb-3">
                                <i class="fas fa-ticket-alt text-warning me-2"></i>Disponibilidad
                            </h5>
                            <div class="d-flex align-items-center gap-3">
                                <div>
                                    <span class="fs-4 fw-bold text-success"><%= disponibles %></span>
                                    <span class="text-muted"> lugares disponibles</span>
                                </div>
                                <div class="flex-grow-1">
                                    <div class="progress" style="height: 25px;">
                                        <div class="progress-bar bg-success" role="progressbar" 
                                             style="width: <%= capacidad > 0 ? (disponibles * 100 / capacidad) : 0 %>%"
                                             aria-valuenow="<%= disponibles %>" 
                                             aria-valuemin="0" 
                                             aria-valuemax="<%= capacidad %>">
                                            <%= capacidad > 0 ? (disponibles * 100 / capacidad) : 0 %>%
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Panel de Compra -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-lg sticky-top" style="top: 20px;">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-4">Comprar Boletos</h4>
                        
                        <div class="mb-4 text-center">
                            <% if (precio == 0) { %>
                                <div class="event-price event-price-free fs-1 mb-2">Gratis</div>
                            <% } else { %>
                                <div class="event-price fs-1 mb-2">$<%= String.format("%.2f", precio) %></div>
                                <small class="text-muted">MXN por boleto</small>
                            <% } %>
                        </div>
                        
                        <% if (disponibles > 0) { %>
                            <form method="POST" action="comprarBoleto.jsp">
                                <input type="hidden" name="evento_id" value="<%= id %>">
                                <input type="hidden" name="precio" value="<%= precio %>">
                                
                                <div class="mb-3">
                                    <label for="cantidad" class="form-label fw-semibold">
                                        Cantidad de Boletos
                                    </label>
                                    <input type="number" class="form-control" id="cantidad" name="cantidad" 
                                           min="1" max="<%= disponibles %>" value="1" required>
                                    <small class="text-muted">Máximo <%= disponibles %> disponibles</small>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="nombre_comprador" class="form-label fw-semibold">
                                        Nombre Completo <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="nombre_comprador" 
                                           name="nombre_comprador" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="email_comprador" class="form-label fw-semibold">
                                        Email <span class="text-danger">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email_comprador" 
                                           name="email_comprador" required>
                                </div>
                                
                                <div class="mb-4">
                                    <label for="telefono_comprador" class="form-label fw-semibold">
                                        Teléfono
                                    </label>
                                    <input type="tel" class="form-control" id="telefono_comprador" 
                                           name="telefono_comprador">
                                </div>
                                
                                <div class="mb-3 p-3 bg-light rounded">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Subtotal:</span>
                                        <strong id="subtotal">$<%= String.format("%.2f", precio) %></strong>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between">
                                        <span class="fw-bold">Total:</span>
                                        <strong class="fs-5 text-primary" id="total">$<%= String.format("%.2f", precio) %></strong>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn btn-primary-custom w-100">
                                    <i class="fas fa-shopping-cart me-2"></i>Comprar Boletos
                                </button>
                            </form>
                        <% } else { %>
                            <div class="alert alert-warning text-center">
                                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                                <p class="mb-0">Este evento está agotado</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-5 py-4" style="background: var(--color-dark); color: white;">
        <div class="container text-center">
            <p class="mb-0">
                <i class="fas fa-calendar-alt me-2"></i>Eventos México © 2024
            </p>
        </div>
    </footer>

    <script src="proyecto2/js/bootstrap.bundle.min.js"></script>
    <script src="proyecto2/js/jquery-3.7.1.min.js"></script>
    <script>
        // Calcular total dinámicamente
        $(document).ready(function() {
            $('#cantidad').on('input', function() {
                var cantidad = parseInt($(this).val()) || 1;
                var precio = <%= precio %>;
                var subtotal = cantidad * precio;
                $('#subtotal').text('$' + subtotal.toFixed(2));
                $('#total').text('$' + subtotal.toFixed(2));
            });
        });
        
        // Contador regresivo
        <% if (fechaEventoDate != null && fechaEventoDate.after(new Date())) { %>
        var fechaEvento = new Date('<%= fechaEvento %>').getTime();
        
        var x = setInterval(function() {
            var now = new Date().getTime();
            var distance = fechaEvento - now;
            
            var days = Math.floor(distance / (1000 * 60 * 60 * 24));
            var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            document.getElementById("days").innerHTML = days;
            document.getElementById("hours").innerHTML = hours;
            document.getElementById("minutes").innerHTML = minutes;
            document.getElementById("seconds").innerHTML = seconds;
            
            if (distance < 0) {
                clearInterval(x);
                document.getElementById("countdown").innerHTML = "<span class='badge bg-danger fs-5'>El evento ya comenzó</span>";
            }
        }, 1000);
        <% } %>
    </script>
</body>
</html>

