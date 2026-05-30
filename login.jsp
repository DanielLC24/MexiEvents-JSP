<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin - Eventos México</title>
    <link href="proyecto2/css/bootstrap.min.css" rel="stylesheet">
    <link href="proyecto2/css/estilos-eventos.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="hero-section" style="min-height: 100vh; display: flex; align-items: center;">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5 col-lg-4">
                    <div class="card border-0 shadow-lg" style="border-radius: 20px; overflow: hidden;">
                        <div class="card-body p-5">
                            <div class="text-center mb-4">
                                <i class="fas fa-calendar-alt fa-3x mb-3" style="background: var(--gradient-primary); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;"></i>
                                <h2 class="fw-bold">Panel de Administración</h2>
                                <p class="text-muted">Eventos México</p>
                            </div>
                            
                            <%
                                String error = request.getParameter("error");
                                if (error != null) {
                            %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    <%= error.equals("1") ? "Usuario o contraseña incorrectos" : "Debe iniciar sesión para continuar" %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            <%
                                }
                            %>
                            
                            <form action="validarLogin.jsp" method="POST" class="fade-in">
                                <div class="mb-3">
                                    <label for="usuario" class="form-label fw-semibold">
                                        <i class="fas fa-user me-2"></i>Usuario
                                    </label>
                                    <input type="text" class="form-control form-control-lg" id="usuario" name="usuario" 
                                           placeholder="Ingresa tu usuario" required autofocus>
                                </div>
                                <div class="mb-4">
                                    <label for="password" class="form-label fw-semibold">
                                        <i class="fas fa-lock me-2"></i>Contraseña
                                    </label>
                                    <input type="password" class="form-control form-control-lg" id="password" name="password" 
                                           placeholder="Ingresa tu contraseña" required>
                                </div>
                                <button type="submit" class="btn btn-primary-custom w-100">
                                    <i class="fas fa-sign-in-alt me-2"></i>Ingresar al Panel
                                </button>
                            </form>
                            
                            <div class="text-center mt-4">
                                <a href="index.jsp" class="text-decoration-none">
                                    <i class="fas fa-arrow-left me-2"></i>Volver a la página principal
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="proyecto2/js/bootstrap.bundle.min.js"></script>
</body>
</html>



