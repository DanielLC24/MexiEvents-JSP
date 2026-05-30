<?php
include "seguridad.php";
include "lib/sql.php";

$conn = new sql();


function tabla($conn) {
    $result = $conn->select("SELECT * FROM usuario");

    echo "
    <div class='card shadow-lg border-0 rounded-4'>
        <div class='card-header bg-primary text-white text-center rounded-top-4'>
            <h5 class='m-0 fw-bold'> Lista de Usuarios</h5>
        </div>
        <div class='card-body'>
            <div class='table-responsive'>
                <table class='table table-hover align-middle text-center'>
                    <thead class='table-primary'>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Password</th>
                            <th>Rol</th>
                            <th colspan='2'>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
    ";

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            echo "
            <tr>
                <td>{$row['id']}</td>
                <td>{$row['nom']}</td>
                <td>{$row['pass']}</td>
                <td>
                    <span class='badge ".($row['roll']=='admin'?'bg-danger':'bg-success')." px-3 py-2'>
                        {$row['roll']}
                    </span>
                </td>
                <td>
                    <button class='btn btn-sm btn-outline-primary btn-edit' onclick=\"modificar('{$row['id']}')\">
                        <span class='icon edit-icon'></span> Editar
                     </button>
                </td>
                <td>
                    <button class='btn btn-sm btn-outline-danger btn-delete' onclick=\"eliminar('{$row['id']}')\">
                        <span class='icon delete-icon'></span> Eliminar
                    </button>
                </td>
            </tr>
            ";
        }
    } else {
        echo "
        <tr>
            <td colspan='6' class='text-muted'>No hay usuarios registrados.</td>
        </tr>
        ";
    }

    echo "
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    ";
}


function modificar($conn, $id) {
    $result = $conn->select("SELECT * FROM usuario WHERE id='$id'");
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        echo '
        <div class="p-2">
            <div class="mb-3">
                <label class="form-label fw-semibold">ID:</label>
                <input type="text" class="form-control form-control-sm" id="id" value="'.$row['id'].'" disabled>
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Nombre:</label>
                <input type="text" class="form-control form-control-sm" id="nom" value="'.$row['nom'].'">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Contraseña:</label>
                <input type="password" class="form-control form-control-sm" id="pass" value="'.$row['pass'].'">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Confirmar Contraseña:</label>
                <input type="password" class="form-control form-control-sm" id="pass2" value="'.$row['pass'].'">
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Rol:</label>
                <select class="form-select form-select-sm" id="roll">
                    <option value="usuario" '.($row['roll']=='usuario'?'selected':'').'>Usuario</option>
                    <option value="admin" '.($row['roll']=='admin'?'selected':'').'>Admin</option>
                </select>
            </div>
            <div class="text-end">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button class="btn btn-primary" onclick="actualizarUsuario()"> Guardar</button>
            </div>
        </div>
        ';
    }
}


function nuevoUsuario() {
    $conn = new sql();
    $result = $conn->select("SELECT MAX(id) as max_id FROM usuario");
    $row = $result->fetch_assoc();
    $nuevoId = $row['max_id'] + 1;

    echo '
    <div class="p-2">
        <div class="mb-3">
            <label class="form-label fw-semibold">ID:</label>
            <input type="text" class="form-control form-control-sm" id="add_id" value="' . $nuevoId . '" disabled>
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Nombre:</label>
            <input type="text" class="form-control form-control-sm" id="add_nom">
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Contraseña:</label>
            <input type="password" class="form-control form-control-sm" id="add_pass">
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Confirmar Contraseña:</label>
            <input type="password" class="form-control form-control-sm" id="add_pass2">
        </div>
        <div class="mb-3">
            <label class="form-label fw-semibold">Rol:</label>
            <select class="form-select form-select-sm" id="add_roll">
                <option value="usuario">Usuario</option>
                <option value="admin">Admin</option>
            </select>
        </div>
        <div class="text-end">
            <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
            <button class="btn btn-success" onclick="guardarUsuario()"> Guardar</button>
        </div>
    </div>
    ';
}


function actualizarUsuario($conn, $id, $nom, $pass, $roll) {
    $update = $conn->execute("UPDATE usuario SET nom='$nom', pass='$pass', roll='$roll' WHERE id='$id'");
    if ($update === true) {
        tabla($conn);
    } else {
        echo "<div class='alert alert-danger text-center'> Error al actualizar: " . $conn->conn->error . "</div>";
    }
}


function guardarUsuario($conn, $nom, $pass, $roll) {
    $result = $conn->select("SELECT MAX(id) as max_id FROM usuario");
    $row = $result->fetch_assoc();
    $nuevoId = $row['max_id'] + 1;

    $insert = $conn->execute("INSERT INTO usuario (id, nom, pass, roll) VALUES ('$nuevoId','$nom','$pass','$roll')");
    if ($insert === true) {
        tabla($conn);
    } else {
        echo "<div class='alert alert-danger text-center'> Error al insertar: ".$conn->conn->error."</div>";
    }
}


$tipo = $_GET['tipo'] ?? '';

switch ($tipo) {
    case 1: // eliminar
        $id = $_GET['id'] ?? '';
        $conn->execute("DELETE FROM usuario WHERE id='$id'");
        tabla($conn);
        break;
    case 2: // mostrar tabla
        tabla($conn);
        break;
    case 3: // modificar
        $id = $_GET['id'] ?? '';
        modificar($conn, $id);
        break;
    case 4: // actualizar
        $id = $_GET['id'] ?? '';
        $nom = $_GET['nom'] ?? '';
        $pass = $_GET['pass'] ?? '';
        $roll = $_GET['roll'] ?? '';
        actualizarUsuario($conn, $id, $nom, $pass, $roll);
        break;
    case 5: // nuevo usuario
        $nom = $_GET['nom'] ?? '';
        $pass = $_GET['pass'] ?? '';
        $roll = $_GET['roll'] ?? '';
        guardarUsuario($conn, $nom, $pass, $roll);
        break;
    case 6: // cargar modal de nuevo usuario
        nuevoUsuario();
        break;
    default:
        tabla($conn);
        break;
}
?>
