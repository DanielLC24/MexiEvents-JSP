<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    String eventoId = request.getParameter("evento_id");
    String cantidad = request.getParameter("cantidad");
    String precio = request.getParameter("precio");
    String nombreComprador = request.getParameter("nombre_comprador");
    String emailComprador = request.getParameter("email_comprador");
    String telefonoComprador = request.getParameter("telefono_comprador");
    
    if (eventoId == null || cantidad == null || nombreComprador == null || emailComprador == null ||
        eventoId.trim().isEmpty() || cantidad.trim().isEmpty() || nombreComprador.trim().isEmpty() || 
        emailComprador.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int eventoIdInt = Integer.parseInt(eventoId);
    int cantidadInt = Integer.parseInt(cantidad);
    double precioDouble = Double.parseDouble(precio);
    double precioTotal = cantidadInt * precioDouble;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    Statement stmt = null;
    ResultSet rs = null;
    String url = "jdbc:mysql://localhost:3306/serv";
    String user = "root";
    String pass = "";
    
    String codigoBoleto = "";
    String nombreEvento = "";
    String fechaEvento = "";
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, pass);
        conn.setAutoCommit(false); // Iniciar transacción
        
        // Verificar disponibilidad
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT lugares_disponibles, nombre, fecha_evento FROM eventos WHERE id = " + eventoIdInt);
        int disponibles = 0;
        if (rs.next()) {
            disponibles = rs.getInt("lugares_disponibles");
            nombreEvento = rs.getString("nombre");
            fechaEvento = rs.getString("fecha_evento");
        }
        rs.close();
        stmt.close();
        
        if (disponibles < cantidadInt) {
            response.sendRedirect("detalleEvento.jsp?id=" + eventoIdInt + "&error=No hay suficientes lugares disponibles");
            return;
        }
        
        // Buscar o crear usuario
        int usuarioId = 0;
        pstmt = conn.prepareStatement("SELECT id FROM usuarios WHERE email = ?");
        pstmt.setString(1, emailComprador.trim());
        rs = pstmt.executeQuery();
        if (rs.next()) {
            usuarioId = rs.getInt("id");
        } else {
            // Crear nuevo usuario
            pstmt.close();
            pstmt = conn.prepareStatement("INSERT INTO usuarios (nombre, email, telefono) VALUES (?, ?, ?)", 
                                         Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, nombreComprador.trim());
            pstmt.setString(2, emailComprador.trim());
            pstmt.setString(3, telefonoComprador != null && !telefonoComprador.trim().isEmpty() ? telefonoComprador.trim() : null);
            pstmt.executeUpdate();
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                usuarioId = rs.getInt(1);
            }
        }
        rs.close();
        pstmt.close();
        
        // Generar código único para el boleto
        codigoBoleto = "EVT-" + eventoIdInt + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        // Crear boleto
        String sqlBoleto = "INSERT INTO boletos (codigo_boleto, evento_id, usuario_id, nombre_comprador, " +
                          "email_comprador, telefono_comprador, cantidad, precio_unitario, precio_total, qr_code) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        pstmt = conn.prepareStatement(sqlBoleto);
        pstmt.setString(1, codigoBoleto);
        pstmt.setInt(2, eventoIdInt);
        pstmt.setInt(3, usuarioId);
        pstmt.setString(4, nombreComprador.trim());
        pstmt.setString(5, emailComprador.trim());
        pstmt.setString(6, telefonoComprador != null && !telefonoComprador.trim().isEmpty() ? telefonoComprador.trim() : null);
        pstmt.setInt(7, cantidadInt);
        pstmt.setDouble(8, precioDouble);
        pstmt.setDouble(9, precioTotal);
        pstmt.setString(10, codigoBoleto); // QR code será el código del boleto
        
        pstmt.executeUpdate();
        pstmt.close();
        
        // Actualizar lugares disponibles
        pstmt = conn.prepareStatement("UPDATE eventos SET lugares_disponibles = lugares_disponibles - ? WHERE id = ?");
        pstmt.setInt(1, cantidadInt);
        pstmt.setInt(2, eventoIdInt);
        pstmt.executeUpdate();
        pstmt.close();
        
        conn.commit(); // Confirmar transacción
        
        // Redirigir a ver el boleto
        response.sendRedirect("verBoleto.jsp?codigo=" + codigoBoleto);
        
    } catch (Exception e) {
        if (conn != null) {
            try {
                conn.rollback(); // Revertir transacción en caso de error
            } catch (SQLException ex) {}
        }
        response.sendRedirect("detalleEvento.jsp?id=" + eventoIdInt + "&error=Error al procesar la compra: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }
%>

