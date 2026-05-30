-- ============================================
-- Script SQL para Sistema de Eventos en México
-- ============================================

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS serv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Seleccionar la base de datos
USE serv;

-- Tabla de administradores
CREATE TABLE IF NOT EXISTS administradores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar admin por defecto (usuario: admin, password: 12345)
INSERT INTO administradores (usuario, password, nombre) 
VALUES ('admin', '12345', 'Administrador Principal')
ON DUPLICATE KEY UPDATE usuario=usuario;

-- Tabla de categorías
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(50),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar categorías por defecto
INSERT INTO categorias (nombre, descripcion, icono) VALUES
('Conciertos', 'Eventos musicales y shows en vivo', '🎵'),
('Deportes', 'Eventos deportivos y competencias', '⚽'),
('Teatro', 'Obras de teatro y espectáculos', '🎭'),
('Festivales', 'Festivales culturales y musicales', '🎪'),
('Conferencias', 'Conferencias y charlas', '🎤'),
('Otros', 'Otros tipos de eventos', '🎉')
ON DUPLICATE KEY UPDATE nombre=nombre;

-- Tabla de eventos
CREATE TABLE IF NOT EXISTS eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_evento DATETIME NOT NULL,
    lugar VARCHAR(200) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    direccion TEXT,
    imagen_principal VARCHAR(255),
    categoria_id INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    capacidad INT NOT NULL,
    lugares_disponibles INT NOT NULL,
    artista_organizador VARCHAR(200),
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8),
    activo BOOLEAN DEFAULT TRUE,
    destacado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de usuarios (clientes)
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de boletos
CREATE TABLE IF NOT EXISTS boletos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_boleto VARCHAR(50) NOT NULL UNIQUE,
    evento_id INT NOT NULL,
    usuario_id INT,
    nombre_comprador VARCHAR(100) NOT NULL,
    email_comprador VARCHAR(100) NOT NULL,
    telefono_comprador VARCHAR(20),
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    precio_total DECIMAL(10, 2) NOT NULL,
    qr_code TEXT,
    estado ENUM('activo', 'usado', 'cancelado') DEFAULT 'activo',
    fecha_compra TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabla de galería de eventos (imágenes adicionales)
CREATE TABLE IF NOT EXISTS galeria_eventos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evento_id INT NOT NULL,
    imagen_url VARCHAR(255) NOT NULL,
    orden INT DEFAULT 0,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (evento_id) REFERENCES eventos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar algunos eventos de ejemplo
INSERT INTO eventos (nombre, descripcion, fecha_evento, lugar, ciudad, direccion, categoria_id, precio, capacidad, lugares_disponibles, artista_organizador, destacado) VALUES
('Festival de Música en CDMX', 'El festival más grande de música en la Ciudad de México con artistas internacionales', '2024-12-15 20:00:00', 'Foro Sol', 'Ciudad de México', 'Av. Viaducto Río de la Piedad, Granjas México', 1, 1500.00, 50000, 50000, 'Various Artists', TRUE),
('Partido América vs Chivas', 'Clásico nacional de fútbol mexicano', '2024-12-10 19:00:00', 'Estadio Azteca', 'Ciudad de México', 'Calz. de Tlalpan 3465, Coyoacán', 2, 800.00, 87000, 87000, 'Club América', TRUE),
('Obra: Romeo y Julieta', 'Adaptación moderna de la obra clásica de Shakespeare', '2024-12-20 20:30:00', 'Teatro Nacional', 'Ciudad de México', 'Av. Hidalgo 1, Centro Histórico', 3, 600.00, 500, 500, 'Compañía Nacional de Teatro', FALSE),
('Festival de Día de Muertos', 'Celebración tradicional mexicana con música, comida y cultura', '2024-11-02 18:00:00', 'Zócalo', 'Ciudad de México', 'Plaza de la Constitución', 4, 0.00, 100000, 100000, 'Gobierno de la CDMX', TRUE)
ON DUPLICATE KEY UPDATE nombre=nombre;

-- Índices para mejorar rendimiento
CREATE INDEX idx_evento_fecha ON eventos(fecha_evento);
CREATE INDEX idx_evento_ciudad ON eventos(ciudad);
CREATE INDEX idx_evento_categoria ON eventos(categoria_id);
CREATE INDEX idx_evento_activo ON eventos(activo);
CREATE INDEX idx_boleto_codigo ON boletos(codigo_boleto);
CREATE INDEX idx_boleto_evento ON boletos(evento_id);

