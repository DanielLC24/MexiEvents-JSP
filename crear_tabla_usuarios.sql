-- ============================================
-- Script SQL para phpMyAdmin
-- Sistema de Gestión de Usuarios
-- ============================================

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS serv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Seleccionar la base de datos
USE serv;

-- Crear la tabla de usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar algunos usuarios de ejemplo (opcional)
-- Descomenta las siguientes líneas si quieres datos de prueba:
/*
INSERT INTO usuarios (nombre, email, telefono) VALUES 
('Juan Pérez', 'juan@example.com', '123456789'),
('María García', 'maria@example.com', '987654321'),
('Carlos López', 'carlos@example.com', '555555555');
*/

