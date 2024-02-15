-- execute with user system
ALTER session SET "_ORACLE_SCRIPT"=true;
CREATE USER taller2 IDENTIFIED BY taller2;
GRANT CREATE TABLE TO taller2;
GRANT CREATE SESSION TO taller2;

-- create tablespace for tables, execute with user system
CREATE TABLESPACE ts_tab_taller2
DATAFILE 'tablas_taller2.dbf'
SIZE 20000K EXTENT MANAGEMENT
LOCAL SEGMENT SPACE MANAGEMENT AUTO;

-- create tablespace for indexes, execute with user system
CREATE TABLESPACE ts_idx_taller2
DATAFILE 'indices_taller2.dbf'
SIZE 20000K EXTENT MANAGEMENT
LOCAL SEGMENT SPACE MANAGEMENT AUTO;

-- create tables, execute with user taller2
CREATE TABLE proveedores (
    id_proveedor NUMBER(10),
    nombre_proveedor VARCHAR2(2000),
    nombre_contacto_proveedor VARCHAR2(2000),
    telefono_proveedor VARCHAR2(20),
    direccion_proveedor VARCHAR2(200),
    codigo_postal NUMBER(10),
    estado_proveedor VARCHAR2(10),
    
    CONSTRAINT proveedores_pk PRIMARY KEY (id_proveedor) USING INDEX TABLESPACE ts_idx_taller2
) TABLESPACE ts_tab_taller2;

CREATE TABLE transportadores (
    id_transportador NUMBER(10),
    nombre_transportador VARCHAR2(100),
    placa_transportador VARCHAR2(20),
    telefono_transportador VARCHAR2(20),
    estado_transportador VARCHAR2(10),
    
    CONSTRAINT transportadores_pk PRIMARY KEY (id_transportador) USING INDEX TABLESPACE ts_idx_taller2
) TABLESPACE ts_tab_taller2;

CREATE TABLE agencias (
    id_agencia NUMBER(10),
    nombre_agencia VARCHAR2(100),
    codigo_postal VARCHAR2(2000),
    tipo_formato_agencia VARCHAR2(30),
    estado_agencia VARCHAR2(10),
    
    CONSTRAINT agencias_pk PRIMARY KEY (id_agencia) USING INDEX TABLESPACE ts_idx_taller2
) TABLESPACE ts_tab_taller2;

CREATE TABLE categorias (
    id_categoria NUMBER(10),
    nombre_categoria VARCHAR2(100),
    descripcion_breve_categoria VARCHAR2(2000),
    imagen_categoria BLOB,
    estado_categoria VARCHAR2(10),
    
    CONSTRAINT categorias_pk PRIMARY KEY (id_categoria) USING INDEX TABLESPACE ts_idx_taller2
) TABLESPACE ts_tab_taller2;

CREATE TABLE clientes (
    id_cliente NUMBER(10),
    tipo_identificacion_cliente VARCHAR2(100),
    identificacion_cliente NUMBER(20),
    nombre_cliente VARCHAR2(2000),
    telefono_cliente VARCHAR2(20),
    direccion_cliente VARCHAR2(200),
    codigo_postal NUMBER(10),
    estado_cliente VARCHAR2(10),
    
    CONSTRAINT clientes_pk PRIMARY KEY (id_cliente) USING INDEX TABLESPACE ts_idx_taller2
) TABLESPACE ts_tab_taller2;

CREATE TABLE vendedores (
    id_vendedor NUMBER(10),
    nombre_vendedor VARCHAR2(100),
    fecha_nacimiento_vendedor DATE,
    direccion_vendedor VARCHAR2(10),
    codigo_postal NUMBER(10),
    telefono_vendedor VARCHAR2(20),
    foto_vendedor BLOB,
    id_agencia NUMBER(10),
    estado_vendedor VARCHAR2(10),
    
    CONSTRAINT vendedores_pk PRIMARY KEY (id_vendedor) USING INDEX TABLESPACE ts_idx_taller2,
    CONSTRAINT vendedores_agencias_fk FOREIGN KEY (id_agencia) REFERENCES agencias(id_agencia)
) TABLESPACE ts_tab_taller2;

CREATE TABLE productos (
    id_producto VARCHAR2(10),
    nombre_producto VARCHAR2(2000),
    id_proveedor NUMBER(10),
    id_categoria NUMBER(10),
    unidad_medida_producto VARCHAR2(20),
    costo_unitario NUMBER(16, 2),
    costo_promedio NUMBER(16, 2),
    previo_venta NUMBER(16, 2),
    estado_producto VARCHAR2(10),
    
    CONSTRAINT productos_pk PRIMARY KEY (id_producto) USING INDEX TABLESPACE ts_idx_taller2,
    CONSTRAINT productos_proveedores_fk FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    CONSTRAINT productos_categorias_fk FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
) TABLESPACE ts_tab_taller2;

CREATE TABLE facturas_ventas (
    prefijo_factura_venta VARCHAR2(10),
    id_factura_venta NUMBER(10),
    id_cliente NUMBER(10),
    id_vendedor NUMBER(10),
    id_transportador NUMBER(10),
    fecha_factura_venta TIMESTAMP,
    direccion_entrega VARCHAR2(200),
    codigo_postal_entrega NUMBER(10),
    subtotal NUMBER(16, 2),
    total_impuesto NUMBER(16, 2),
    total_pagar NUMBER(16, 2),
    estado_factura_venta VARCHAR2(10),
    
    CONSTRAINT facturas_ventas_pk PRIMARY KEY (prefijo_factura_venta, id_factura_venta) USING INDEX TABLESPACE ts_idx_taller2,
    CONSTRAINT facturas_ventas_clientes_fk FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT facturas_ventas_vendedores_fk FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    CONSTRAINT facturas_ventas_transportadores_fk FOREIGN KEY (id_transportador) REFERENCES transportadores(id_transportador)
) TABLESPACE ts_tab_taller2;

CREATE TABLE detalle_facturas_ventas (
    prefijo_factura_venta VARCHAR2(10),
    id_factura_venta NUMBER(10),
    id_detalle_factura_venta NUMBER(10),
    id_producto VARCHAR2(10),
    unidad_medida_producto VARCHAR2(20),
    cantidad NUMBER(16, 2),
    costo_unitario NUMBER(16, 2),
    previo_venta NUMBER(16, 2),
    descuento NUMBER(16, 2),
    subtotal NUMBER(16, 2),
    tarifa_impuesto NUMBER(7, 4),
    valor_impuesto NUMBER(16, 2),
    estado_factura_venta VARCHAR2(10),
    
    CONSTRAINT detalle_facturas_ventas_pk PRIMARY KEY (prefijo_factura_venta, id_factura_venta, id_detalle_factura_venta) USING INDEX TABLESPACE ts_idx_taller2,
    CONSTRAINT detalle_facturas_ventas_fk FOREIGN KEY (prefijo_factura_venta, id_factura_venta) REFERENCES facturas_ventas(prefijo_factura_venta, id_factura_venta),
    CONSTRAINT detalle_facturas_ventas_productos_fk FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
) TABLESPACE ts_tab_taller2;

ALTER TABLE facturas_ventas ADD observaciones VARCHAR2(2000);
ALTER TABLE detalle_facturas_ventas MODIFY (tarifa_impuesto NUMBER(6, 2));
ALTER TABLE agencias DROP COLUMN tipo_formato_agencia;
