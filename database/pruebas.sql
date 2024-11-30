-- Insertar un usuario de prueba
INSERT INTO usuarios (nombre, email, contraseña, rol) VALUES
('Admin', 'admin@example.com', 'admin123', 'administrador');

-- Insertar un cliente de prueba
INSERT INTO clientes (nombre, direccion, telefono, ruc_cedula) VALUES
('Cliente 1', 'Dirección del cliente 1', '0999999999', '1234567890');

-- Insertar un producto de prueba
INSERT INTO productos (nombre, descripcion, precio, stock) VALUES
('Producto 1', 'Descripción del producto 1', 10.00, 100);

-- Insertar una venta de prueba con cliente, descuento e IVA
INSERT INTO ventas (usuario_id, cliente_id, total, descuento) VALUES
(1, 1, 20.00, 2.00);

-- Obtener el ID de la venta recién insertada
-- Esto puede variar según el cliente SQL que estés usando. Aquí se asume que estás usando psql.
-- Si estás usando otro cliente, asegúrate de obtener el ID de la venta de la manera adecuada.
-- Por ejemplo, en psql puedes usar RETURNING id para obtener el ID de la venta.
INSERT INTO ventas (usuario_id, cliente_id, total, descuento) VALUES
(1, 1, 20.00, 2.00) RETURNING id;

-- Supongamos que el ID de la venta es 1
-- Insertar detalles de la venta de prueba
INSERT INTO detalles_ventas (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(2, 1, 2, 10.00, 20.00);

-- Insertar una factura de prueba
INSERT INTO facturas (venta_id, numero_factura) VALUES
(2, 'F001-0001');