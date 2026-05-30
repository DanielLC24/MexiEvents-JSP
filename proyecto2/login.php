<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="css/bootstrap.css">

    <style>
        body {
            background: linear-gradient(135deg, #4e73df, #1cc88a);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: "Poppins", sans-serif;
        }

        .login-card {
            background: white;
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 380px;
            transition: transform 0.3s ease;
        }

        .login-card:hover {
            transform: translateY(-5px);
        }

        .login-card h3 {
            text-align: center;
            margin-bottom: 25px;
            color: #4e73df;
            font-weight: 600;
        }

        .form-label {
            font-weight: 500;
        }

        .btn-primary {
            background-color: #4e73df;
            border: none;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #3753b5;
            transform: scale(1.05);
        }

        .form-control {
            border-radius: 10px;
            box-shadow: none;
            border: 1px solid #ccc;
        }

        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 5px rgba(78,115,223,0.5);
        }

        footer {
            text-align: center;
            margin-top: 20px;
            color: #fff;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <div class="login-card">
        <h3>Iniciar Sesión</h3>
        <form action="valida.php" method="post">
            <div class="mb-3">
                <label for="usuario" class="form-label">Usuario:</label>
                <input type="text" class="form-control" id="usuario" name="usuario" required>
            </div>
            <div class="mb-3">
                <label for="pass" class="form-label">Contraseña:</label>
                <input type="password" class="form-control" id="pass" name="pass" required>
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-primary">Entrar</button>
            </div>
        </form>
    </div>

</body>
</html>
