<?php
include "seguridad.php";
include "lib/sql.php";
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Usuarios</title>
    <link rel="stylesheet" href="css/bootstrap.css">

    <style>
        body {
            background: linear-gradient(135deg,rgb(53, 60, 53), #1cc88a);
            min-height: 100vh;
            font-family: "Poppins", sans-serif;
            color: #333;
        }

        .navbar {
            background-color: rgba(255, 255, 255, 0.95);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border-radius: 0 0 20px 20px;
            padding: 15px 30px;
            margin-bottom: 30px;
        }

        .navbar h3 {
            color: #4e73df;
            font-weight: 600;
            margin: 0;
        }

        .icon {
            display: inline-block;
            width: 18px;
            height: 18px;
            vertical-align: middle;
            margin-right: 6px;
            background-color: currentColor;
            mask-size: contain;
            mask-repeat: no-repeat;
            mask-position: center;
        }

        
        .edit-icon {
            mask-image: url('img/edit2.svg');
            -webkit-mask-image: url('img/edit2.svg');
        }

        .delete-icon {
            mask-image: url('img/delete2.svg');
            -webkit-mask-image: url('img/delete2.svg');
        }

       
        .btn-edit {
            color: #4e73df;
            transition: color 0.3s ease;
        }

        .btn-delete {
            color: #dc3545;
            transition: color 0.3s ease;
        }

        
        .btn-edit:hover {
            color: #fff;
            transform: scale(1.05);
        }

        .btn-delete:hover {
            color: #fff;
            transform: scale(1.05);
        }

        .table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }

        .table thead {
            background-color: #4e73df;
            color: white;
        }

        .modal-content {
            border-radius: 20px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            background-color: #4e73df;
            color: white;
            border-radius: 20px 20px 0 0;
        }

        footer {
            text-align: center;
            padding: 15px;
            margin-top: 40px;
            color: white;
            font-size: 0.9rem;
        }

        #mitabla {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>

    
    <nav class="navbar d-flex justify-content-between align-items-center">
        <h3> Panel de Usuarios</h3>
        <div>
            <button class="btn btn-success me-2" onclick="nuevoUsuario()">
                Añadir Usuario
            </button>
            <button class="btn btn-primary" onclick="salir()">
                Salir
            </button>
        </div>
    </nav>

    <div class="container">
        <div class="row">
            <div class="col" id="mitabla"></div>
        </div>
    </div>

    
    <div class="modal fade" id="ModalModificar" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Modificar Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body" id="ModalUpdate"></div>
            </div>
        </div>
    </div>

    
    <div class="modal fade" id="ModalAñadir" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"> Añadir Usuario</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body" id="ModalNuevoUsuario"></div>
            </div>
        </div>
    </div>

    <script src="js/jquery-3.7.1.min.js"></script>
    <script src="js/bootstrap.js"></script>
    <script>
        function salir() {
            location.href = "salir.php";
        }

        function cargarTabla() {
            $.get("procesos.php?tipo=2&r=" + Math.random(), function (result) {
                $("#mitabla").html(result);
            });
        }

        function eliminar(id) {
            if (!confirm("¿Seguro que deseas eliminar este registro?")) return;
            $.get("procesos.php?tipo=1&id=" + id + "&r=" + Math.random(), function (result) {
                $("#mitabla").html(result);
            });
        }

        function modificar(id) {
            $.get("procesos.php?tipo=3&id=" + id + "&r=" + Math.random(), function (result) {
                $("#ModalUpdate").html(result);
                $("#ModalModificar").modal("show");
            });
        }

        function actualizarUsuario() {
            var id = $("#id").val();
            var nom = $("#nom").val().trim();
            var pass = $("#pass").val();
            var pass2 = $("#pass2").val();
            var roll = $("#roll").val();

            if (!nom || !pass || !pass2 || !roll) {
                alert(" Todos los campos son obligatorios.");
                return;
            }
            if (pass !== pass2) {
                alert(" Las contraseñas no coinciden.");
                return;
            }

            $.get("procesos.php?tipo=4&id=" + id + "&nom=" + nom + "&pass=" + pass + "&roll=" + roll + "&r=" + Math.random(), function (result) {
                $("#ModalModificar").modal("hide");
                $("#mitabla").html(result);
            });
        }

        function nuevoUsuario() {
            $.get("procesos.php?tipo=6&r=" + Math.random(), function (result) {
                $("#ModalNuevoUsuario").html(result);
                $("#ModalAñadir").modal("show");
            });
        }

        function guardarUsuario() {
            var nom = $("#add_nom").val().trim();
            var pass = $("#add_pass").val();
            var pass2 = $("#add_pass2").val();
            var roll = $("#add_roll").val();

            if (!nom || !pass || !pass2 || !roll) {
                alert(" Todos los campos son obligatorios.");
                return;
            }
            if (pass !== pass2) {
                alert(" Las contraseñas no coinciden.");
                return;
            }

            $.get("procesos.php?tipo=5&nom=" + nom + "&pass=" + pass + "&roll=" + roll + "&r=" + Math.random(), function (result) {
                $("#ModalAñadir").modal("hide");
                $("#mitabla").html(result);
            });
        }

        
        $(function () {
            cargarTabla();
        });
    </script>
</body>

</html>