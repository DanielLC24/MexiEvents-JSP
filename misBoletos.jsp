<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String email = request.getParameter("email");
    String codigo = request.getParameter("codigo");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
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
    <title>Mis Boletos - Eventos México</title>
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
                    <i class="fas fa-home me-1"></i>Inicio
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-5 mb-5">
        <div class="row">
            <div class="col-12">
                <h2 class="fw-bold mb-4">
                    <i class="fas fa-ticket-alt me-2"></i>Mis Boletos
                </h2>
                
                <!-- Formulario de búsqueda -->
                <div class="card border-0 shadow-md mb-4">
                    <div class="card-body">
                        <form method="GET" action="misBoletos.jsp" class="row g-3">
                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold">
                                    <i class="fas fa-envelope me-2"></i>Email
                                </label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="Ingresa tu email" value="<%= email != null ? email : "" %>" required>
                            </div>
                            <div class="col-md-4">
                                <label for="codigo" class="form-label fw-semibold">
                                    <i class="fas fa-barcode me-2"></i>Código de Boleto (Opcional)
                                </label>
                                <input type="text" class="form-control" id="codigo" name="codigo" 
                                       placeholder="EVT-XXX-XXXX" value="<%= codigo != null ? codigo : "" %>">
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary-custom w-100">
                                    <i class="fas fa-search me-2"></i>Buscar
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Lista de boletos -->
                <%
                    if (email != null && !email.trim().isEmpty()) {
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection(url, user, pass);
                            
                            String sql = "SELECT b.*, e.nombre as evento_nombre, e.fecha_evento, e.lugar, e.ciudad, e.imagen_principal " +
                                        "FROM boletos b " +
                                        "INNER JOIN eventos e ON b.evento_id = e.id " +
                                        "WHERE b.email_comprador = ? ";
                            
                            if (codigo != null && !codigo.trim().isEmpty()) {
                                sql += "AND b.codigo_boleto LIKE ? ";
                            }
                            
                            sql += "ORDER BY b.fecha_compra DESC";
                            
                            pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, email.trim());
                            if (codigo != null && !codigo.trim().isEmpty()) {
                                pstmt.setString(2, "%" + codigo.trim() + "%");
                            }
                            
                            rs = pstmt.executeQuery();
                            
                            boolean hayBoletos = false;
                %>
                <div class="row g-4">
                    <%
                        while (rs.next()) {
                            hayBoletos = true;
                            String codigoBoleto = rs.getString("codigo_boleto");
                            String nombreEvento = rs.getString("evento_nombre");
                            String fechaEvento = rs.getString("fecha_evento");
                            String lugar = rs.getString("lugar");
                            String ciudad = rs.getString("ciudad");
                            String imagen = rs.getString("imagen_principal");
                            int cantidad = rs.getInt("cantidad");
                            double precioTotal = rs.getDouble("precio_total");
                            String estado = rs.getString("estado");
                            String fechaCompra = rs.getString("fecha_compra");
                    %>
                    <div class="col-md-6 col-lg-4 fade-in">
                        <div class="card border-0 shadow-lg h-100">
                            <% if (imagen != null && !imagen.isEmpty()) { %>
                                <img src="<%= imagen %>" class="card-img-top" alt="<%= nombreEvento %>" 
                                     style="height: 200px; object-fit: cover;">
                            <% } else { %>
                                <div class="card-img-top" style="height: 200px; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: white; font-size: 3rem;">
                                    <i class="fas fa-calendar-alt"></i>
                                </div>
                            <% } %>
                            <div class="card-body">
                                <h5 class="card-title fw-bold"><%= nombreEvento %></h5>
                                <p class="text-muted small mb-2">
                                    <i class="fas fa-calendar me-1"></i><%= fechaEvento.substring(0, 16).replace(" ", " - ") %>
                                </p>
                                <p class="text-muted small mb-2">
                                    <i class="fas fa-map-marker-alt me-1"></i><%= lugar %>, <%= ciudad %>
                                </p>
                                <hr>
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="small">Cantidad:</span>
                                    <strong><%= cantidad %> boleto(s)</strong>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="small">Total:</span>
                                    <strong class="text-success">$<%= String.format("%.2f", precioTotal) %></strong>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <span class="small">Estado:</span>
                                    <span class="badge bg-<%= estado.equals("activo") ? "success" : estado.equals("usado") ? "warning" : "danger" %>">
                                        <%= estado.toUpperCase() %>
                                    </span>
                                </div>
                                <p class="small text-muted mb-0">
                                    <i class="fas fa-barcode me-1"></i>Código: <strong><%= codigoBoleto %></strong>
                                </p>
                                <p class="small text-muted">
                                    Comprado: <%= fechaCompra != null ? fechaCompra.substring(0, 16) : "" %>
                                </p>
                            </div>
                            <div class="card-footer bg-white border-top">
                                <a href="verBoleto.jsp?codigo=<%= codigoBoleto %>" class="btn btn-primary-custom w-100 btn-sm">
                                    <i class="fas fa-eye me-2"></i>Ver Boleto Completo
                                </a>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                        
                        if (!hayBoletos) {
                    %>
                    <div class="col-12">
                        <div class="card border-0 shadow-md text-center py-5">
                            <div class="card-body">
                                <i class="fas fa-ticket-alt fa-4x text-muted mb-3" style="opacity: 0.3;"></i>
                                <h4 class="text-muted">No se encontraron boletos</h4>
                                <p class="text-muted">No hay boletos registrados con este email</p>
                                <a href="index.jsp" class="btn btn-primary-custom">
                                    <i class="fas fa-calendar me-2"></i>Ver Eventos Disponibles
                                </a>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                    %>
                </div>
                <%
                        } catch (Exception e) {
                %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    Error al cargar boletos: <%= e.getMessage() %>
                </div>
                <%
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {}
                        }
                    } else {
                %>
                <div class="card border-0 shadow-md text-center py-5">
                    <div class="card-body">
                        <i class="fas fa-search fa-4x text-muted mb-3" style="opacity: 0.3;"></i>
                        <h4 class="text-muted">Busca tus boletos</h4>
                        <p class="text-muted">Ingresa tu email para ver tus boletos comprados</p>
                    </div>
                </div>
                <%
                    }
                %>
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
</body>
</html>

