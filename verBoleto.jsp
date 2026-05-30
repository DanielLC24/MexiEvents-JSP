<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    String codigo = request.getParameter("codigo");
    if (codigo == null || codigo.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    String codigoBoleto = "";
    String nombreEvento = "";
    String fechaEvento = "";
    String lugar = "";
    String ciudad = "";
    String nombreComprador = "";
    String emailComprador = "";
    int cantidad = 0;
    double precioTotal = 0;
    String estado = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        
        String sql = "SELECT b.*, e.nombre as evento_nombre, e.fecha_evento, e.lugar, e.ciudad " +
                    "FROM boletos b " +
                    "INNER JOIN eventos e ON b.evento_id = e.id " +
                    "WHERE b.codigo_boleto = ?";
        
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, codigo);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            codigoBoleto = rs.getString("codigo_boleto");
            nombreEvento = rs.getString("evento_nombre");
            fechaEvento = rs.getString("fecha_evento");
            lugar = rs.getString("lugar");
            ciudad = rs.getString("ciudad");
            nombreComprador = rs.getString("nombre_comprador");
            emailComprador = rs.getString("email_comprador");
            cantidad = rs.getInt("cantidad");
            precioTotal = rs.getDouble("precio_total");
            estado = rs.getString("estado");
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
    <title>Mi Boleto - Eventos México</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
    <link href="proyecto2/css/estilos-eventos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
</head>
<body style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 2rem 0;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Mensaje de éxito animado -->
                <div class="text-center mb-4 fade-in">
                    <div class="mb-3">
                        <i class="fas fa-check-circle fa-5x text-white pulse-animation"></i>
                    </div>
                    <h2 class="text-white fw-bold mb-2">
                        ¡Tu boleto ha sido creado!
                    </h2>
                    <p class="text-white-50">Guarda este boleto, lo necesitarás para ingresar al evento</p>
                </div>
                
                <!-- Boleto -->
                <div class="ticket fade-in">
                    <div class="text-center mb-4">
                        <h3 class="fw-bold mb-2"><%= nombreEvento %></h3>
                        <span class="badge bg-<%= estado.equals("activo") ? "success" : estado.equals("usado") ? "warning" : "danger" %> fs-6">
                            <%= estado.toUpperCase() %>
                        </span>
                    </div>
                    
                    <div class="ticket-content">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <strong><i class="fas fa-calendar-alt text-primary me-2"></i>Fecha:</strong>
                                    <p class="mb-0"><%= fechaEvento.substring(0, 16).replace(" ", " - ") %></p>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-map-marker-alt text-danger me-2"></i>Lugar:</strong>
                                    <p class="mb-0"><%= lugar %>, <%= ciudad %></p>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-user text-primary me-2"></i>Comprador:</strong>
                                    <p class="mb-0"><%= nombreComprador %></p>
                                    <small class="text-muted"><%= emailComprador %></small>
                                </div>
                                <div class="mb-3">
                                    <strong><i class="fas fa-ticket-alt text-warning me-2"></i>Cantidad:</strong>
                                    <p class="mb-0"><%= cantidad %> boleto(s)</p>
                                </div>
                                <div>
                                    <strong><i class="fas fa-dollar-sign text-success me-2"></i>Total Pagado:</strong>
                                    <p class="mb-0 fs-4 text-success fw-bold">$<%= String.format("%.2f", precioTotal) %> MXN</p>
                                </div>
                            </div>
                            <div class="col-md-4 text-center">
                                <div class="qr-code" id="qrCode"></div>
                                <p class="small text-muted mt-2">Código: <strong><%= codigoBoleto %></strong></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center mt-4">
                        <button onclick="window.print()" class="btn btn-primary-custom me-2">
                            <i class="fas fa-print me-2"></i>Imprimir Boleto
                        </button>
                        <a href="misBoletos.jsp?email=<%= emailComprador %>" class="btn btn-secondary-custom">
                            <i class="fas fa-list me-2"></i>Ver Mis Boletos
                        </a>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <a href="index.jsp" class="text-white text-decoration-none">
                        <i class="fas fa-arrow-left me-2"></i>Volver a Eventos
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="proyecto2/js/bootstrap.bundle.min.js"></script>
    <script>
        // Generar QR Code
        QRCode.toCanvas(document.getElementById('qrCode'), '<%= codigoBoleto %>', {
            width: 150,
            margin: 2,
            color: {
                dark: '#000000',
                light: '#FFFFFF'
            }
        }, function (error) {
            if (error) {
                console.error(error);
                document.getElementById('qrCode').innerHTML = '<div class="text-center p-3"><i class="fas fa-qrcode fa-3x text-muted"></i><br><small>QR Code</small></div>';
            }
        });
    </script>
    
    <style>
        @media print {
            body {
                background: white !important;
                padding: 0 !important;
            }
            .ticket {
                box-shadow: none !important;
                border: 2px solid #000 !important;
            }
            .btn, nav, footer {
                display: none !important;
            }
        }
    </style>
</body>
</html>

