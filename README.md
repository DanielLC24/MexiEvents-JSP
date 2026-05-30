# Sistema de Eventos México 🎉

Sistema web completo para gestión y venta de eventos en México, desarrollado con JSP, MySQL y Bootstrap.

## 🎯 Características Principales

### Vista Pública (Usuarios)
- ✅ Visualización de eventos en tarjetas modernas con efectos hover
- ✅ Búsqueda inteligente por nombre, artista o lugar
- ✅ Filtros avanzados (categoría, ciudad, fecha, precio)
- ✅ Página de detalle de evento con contador regresivo
- ✅ Sistema de compra de boletos
- ✅ Generación de boletos con código QR
- ✅ Sección "Mis Boletos" para consultar compras
- ✅ Diseño 100% responsivo

### Panel de Administración
- ✅ Login seguro de administrador
- ✅ Dashboard con estadísticas en tiempo real
- ✅ CRUD completo de eventos (Crear, Leer, Actualizar, Eliminar)
- ✅ Gestión de categorías
- ✅ Vista previa de eventos con imágenes
- ✅ Control de disponibilidad y capacidad
- ✅ Eventos destacados

## 🚀 Instalación y Configuración

### Requisitos Previos
- XAMPP (Apache, MySQL, Tomcat)
- Navegador web moderno
- MySQL Connector/J (incluido en `WEB-INF/lib/`)

### Pasos de Instalación

1. **Configurar Base de Datos**
   ```sql
   -- Ejecutar el script SQL en phpMyAdmin o MySQL
   -- Archivo: crear_tablas_eventos.sql
   ```

2. **Configurar Tomcat Context**
   - Crear archivo: `C:\xampp\tomcat\conf\Catalina\localhost\proyecto2daw.xml`
   - Contenido:
   ```xml
   <Context docBase="C:\xampp\htdocs\daw\proyecto2daw" path="/proyecto2daw" />
   ```

3. **Iniciar Servicios XAMPP**
   - Apache
   - MySQL
   - Tomcat

4. **Acceder al Sistema**
   - Página pública: `http://localhost:8080/proyecto2daw/`
   - Panel admin: `http://localhost:8080/proyecto2daw/login.jsp`
   - Credenciales admin: `admin` / `12345`

## 📁 Estructura del Proyecto

```
proyecto2daw/
├── crear_tablas_eventos.sql      # Script de creación de base de datos
├── index.jsp                      # Página principal pública
├── login.jsp                      # Login de administrador
├── validarLogin.jsp               # Validación de login
├── dashboard.jsp                   # Panel de administración
├── crearEvento.jsp                # Crear nuevo evento
├── editarEvento.jsp                # Editar evento existente
├── eliminarEvento.jsp              # Eliminar evento
├── detalleEvento.jsp               # Detalle público del evento
├── comprarBoleto.jsp               # Procesar compra de boletos
├── verBoleto.jsp                   # Ver boleto con QR
├── misBoletos.jsp                  # Lista de boletos del usuario
├── logout.jsp                      # Cerrar sesión
├── proyecto2/
│   ├── css/
│   │   ├── bootstrap.min.css       # Bootstrap CSS
│   │   └── estilos-eventos.css    # Estilos personalizados
│   └── js/
│       ├── bootstrap.bundle.min.js # Bootstrap JS
│       └── jquery-3.7.1.min.js    # jQuery
└── WEB-INF/
    └── lib/
        └── mysql-connector-j-9.5.0.jar  # Driver MySQL
```

## 🗄️ Base de Datos

### Tablas Principales

- **administradores**: Usuarios del panel admin
- **categorias**: Categorías de eventos (Conciertos, Deportes, Teatro, etc.)
- **eventos**: Información de los eventos
- **usuarios**: Clientes que compran boletos
- **boletos**: Boletos generados con códigos únicos y QR

## 🎨 Características Visuales

- ✨ Paleta de colores moderna (azul/morado neón)
- ✨ Cards con efectos hover (zoom suave, sombra)
- ✨ Animaciones fluidas (fade-in, transiciones)
- ✨ Efectos de brillo en botones
- ✨ Contador regresivo para eventos
- ✨ Diseño tipo "hero section"
- ✨ Boletos animados estilo "papel cortado"

## 🔐 Seguridad

- Validación de sesión en todas las páginas admin
- Protección contra SQL Injection (PreparedStatement)
- Transacciones para operaciones críticas
- Validación de disponibilidad antes de vender boletos

## 📱 Responsive Design

El sistema está completamente optimizado para:
- 📱 Móviles
- 📱 Tablets
- 💻 Desktop

## 🛠️ Tecnologías Utilizadas

- **Backend**: JSP (JavaServer Pages)
- **Base de Datos**: MySQL
- **Frontend**: Bootstrap 5, CSS3, JavaScript
- **Librerías**: jQuery, QRCode.js, Font Awesome
- **Servidor**: Apache Tomcat

## 📝 Notas Importantes

1. **Primera Ejecución**: Ejecuta `crear_tablas_eventos.sql` antes de usar el sistema
2. **Imágenes**: Las URLs de imágenes deben ser accesibles públicamente
3. **QR Codes**: Se generan automáticamente usando la librería QRCode.js
4. **Boletos**: Los boletos se pueden imprimir directamente desde el navegador

## 🎯 Funcionalidades Futuras (Opcionales)

- [ ] Geolocalización para eventos cercanos
- [ ] Modo oscuro/claro
- [ ] Exportar eventos a PDF/Excel
- [ ] Sistema de recomendaciones
- [ ] Historial de cambios (logs)
- [ ] Integración con mapas (Google Maps/Leaflet)

## 👨‍💻 Desarrollo

Sistema desarrollado para el proyecto 2DAW - Gestión de Eventos en México.

---

**Eventos México** © 2024 - Sistema de Gestión de Eventos
