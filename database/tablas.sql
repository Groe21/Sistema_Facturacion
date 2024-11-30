-- Conectar a la base de datos
\c sistema_facturacion;

-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(100) NOT NULL,
    rol VARCHAR(50) NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de clientes
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    ruc_cedula VARCHAR(20) UNIQUE NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Agregar el campo imagen a la tabla productos permitiendo valores NULL
ALTER TABLE productos ADD COLUMN imagen VARCHAR(255);
-- Tabla de productos
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de ventas
CREATE TABLE ventas (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id),
    cliente_id INT REFERENCES clientes(id),
    total DECIMAL(10, 2) NOT NULL,
    descuento DECIMAL(10, 2) DEFAULT 0,
    iva DECIMAL(10, 2) DEFAULT 0,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de detalles de ventas
CREATE TABLE detalles_ventas (
    id SERIAL PRIMARY KEY,
    venta_id INT REFERENCES ventas(id),
    producto_id INT REFERENCES productos(id),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL
);

-- Tabla de facturas
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    venta_id INT REFERENCES ventas(id),
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de cierres de caja
CREATE TABLE cierres_caja (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id),
    apertura DECIMAL(10, 2) NOT NULL,
    cierre DECIMAL(10, 2) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de configuración del IVA
CREATE TABLE configuracion_iva (
    id SERIAL PRIMARY KEY,
    porcentaje DECIMAL(5, 2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar configuración inicial del IVA
INSERT INTO configuracion_iva (porcentaje) VALUES (12.00);

-- Función para calcular el total de la venta
CREATE OR REPLACE FUNCTION calcular_total_venta() RETURNS TRIGGER AS $$
BEGIN
    NEW.iva := (NEW.total - NEW.descuento) * (SELECT porcentaje FROM configuracion_iva WHERE activo = TRUE LIMIT 1) / 100;
    NEW.total := NEW.total - NEW.descuento + NEW.iva;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para calcular el total de la venta
CREATE TRIGGER trigger_calcular_total_venta
BEFORE INSERT OR UPDATE ON ventas
FOR EACH ROW
EXECUTE FUNCTION calcular_total_venta();