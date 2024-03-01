CREATE TABLE USUARIO (
    DNI VARCHAR(9),
    nombre VARCHAR(20) NOT NULL,
    apellido1 VARCHAR(20) NOT NULL,
    apellido2 VARCHAR(20),
    direccion_envio VARCHAR(20),
    direccion_facturacion VARCHAR(20),
    correo_electronico VARCHAR(50),
    login VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL,
    CONSTRAINT pk_usuario PRIMARY KEY (DNI),
    CONSTRAINT chk_password CHECK (password REGEXP BINARY '[A-Z]'),
    CONSTRAINT chk_dni_formato CHECK (DNI REGEXP '^[0-9]{8}[a-zA-Z]{1}$')
);

CREATE TABLE DOCUMENTO (
    cod_documento VARCHAR(10),
    titulo VARCHAR(20) NOT NULL,
    precio_venta DECIMAL(10,2),
    CONSTRAINT pk_documento PRIMARY KEY (cod_documento),
    CONSTRAINT chk_longitud_titulo CHECK (LENGTH(titulo) >= 5),
    CONSTRAINT chk_precio_venta CHECK (precio_venta BETWEEN 1 AND 200)
);

CREATE TABLE INFORME_TECNICO (
    cod_documento VARCHAR(10),
    institucion VARCHAR(50),
    anio DATE DEFAULT '2023-01-01',
    tipo VARCHAR(20),
    direccion VARCHAR(50),
    numero INT,
    CONSTRAINT pk_informe_tecnico PRIMARY KEY (cod_documento),
    CONSTRAINT fk_cod_documento_inf FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento),
    CONSTRAINT chk_anio CHECK (anio BETWEEN '2000-01-01' AND '2023-12-31')
);

CREATE TABLE LIBRO (
    cod_documento VARCHAR(10),
    ISBN VARCHAR(20) UNIQUE,
    fecha_publicacion DATE,
    editorial VARCHAR(20),
    edicion INT DEFAULT 1,
    sinapsis VARCHAR(50),
    CONSTRAINT pk_libro PRIMARY KEY (cod_documento),
    CONSTRAINT fk_cod_documento_lib FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE EDITADO (
    cod_documento VARCHAR(10),
    CONSTRAINT fk_cod_documento_edi FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE NO_EDITADO (
    cod_documento VARCHAR(10),
    fecha_lanzamiento DATE,
    CONSTRAINT pk_no_editado PRIMARY KEY (cod_documento),
    CONSTRAINT fk_cod_documento_no_edi FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE AUTOR (
    cod_autor VARCHAR(9),
    nombre VARCHAR(20) NOT NULL,
    apellido1 VARCHAR(20) NOT NULL,
    apellido2 VARCHAR(50),
    fecha_nacimiento DATE,
    edad INT,
    localidad VARCHAR(20) CHECK (localidad IN ('Madrid', 'Barcelona', 'Sevilla', 'Valencia')),
    CONSTRAINT pk_autor PRIMARY KEY (cod_autor)
);

CREATE TABLE CATEGORIA (
    cod_categoria VARCHAR(10),
    nombre_categoria VARCHAR(20) UNIQUE,
    CONSTRAINT pk_categoria PRIMARY KEY (cod_categoria),
    CONSTRAINT chk_categoria_formato CHECK (nombre_categoria REGEXP BINARY '^[A-Za-z ]+$')
);

CREATE TABLE FACTURA (
    id_factura VARCHAR(10),
    DNI VARCHAR(9),
    fecha DATE,
    CONSTRAINT pk_factura PRIMARY KEY (id_factura),
    CONSTRAINT fk_DNI_factura FOREIGN KEY (DNI) REFERENCES USUARIO(DNI)
);

CREATE TABLE LINEA_DE_FACTURA (
    cod_linea VARCHAR(10),
    id_factura VARCHAR(10),
    cod_documento VARCHAR(10),
    CONSTRAINT pk_linea_de_factura PRIMARY KEY (cod_linea),
    CONSTRAINT fk_id_factura_linea_de_factura FOREIGN KEY (id_factura) REFERENCES FACTURA(id_factura),
    CONSTRAINT fk_doc_linea FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE USUARIO_EDITADO (
    DNI VARCHAR(9),
    cod_documento VARCHAR(10),
    fecha DATE,
    cantidad INT,
    CONSTRAINT pk_usuario_editado PRIMARY KEY (DNI, cod_documento),
    CONSTRAINT fk_DNI_usuario_editado FOREIGN KEY (DNI) REFERENCES USUARIO(DNI),
    CONSTRAINT fk_cod_documento_usuario_edi FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE USUARIO_INFORME_TECNICO (
    DNI VARCHAR(9),
    cod_documento VARCHAR(10),
    fecha DATE,
    CONSTRAINT pk_usuario_informe_tecnico PRIMARY KEY (DNI, cod_documento),
    CONSTRAINT fk_DNI_usuario_inf_tecni FOREIGN KEY (DNI) REFERENCES USUARIO(DNI),
    CONSTRAINT fk_cod_doc_usuario_inf_tecni FOREIGN KEY (cod_documento) REFERENCES INFORME_TECNICO(cod_documento)
);

CREATE TABLE USUARIO_NO_EDITADO_NOTIFICA (
    DNI VARCHAR(9),
    cod_documento VARCHAR(10),
    fecha_peticion DATE,
    CONSTRAINT pk_usuario_no_edi_noti PRIMARY KEY (DNI, cod_documento, fecha_peticion),
    CONSTRAINT fk_DNI_us_no_edi_noti FOREIGN KEY (DNI) REFERENCES USUARIO(DNI),
    CONSTRAINT fk_cod_doc_us_no_edi_noti FOREIGN KEY (cod_documento) REFERENCES NO_EDITADO(cod_documento)
);

CREATE TABLE USUARIO_NO_EDITADO_RESERVA (
    DNI VARCHAR(9),
    cod_documento VARCHAR(10),
    fecha_reserva DATE,
    CONSTRAINT pk_us_no_edi_res PRIMARY KEY (DNI, cod_documento, fecha_reserva),
    CONSTRAINT fk_DNI_us_no_edi_res FOREIGN KEY (DNI) REFERENCES USUARIO(DNI),
    CONSTRAINT fk_cod_doc_us_no_edi_res FOREIGN KEY (cod_documento) REFERENCES NO_EDITADO(cod_documento)
);

CREATE TABLE DOCUMENTO_AUTOR (
    cod_autor VARCHAR(10),
    cod_documento VARCHAR(10),
    CONSTRAINT pk_documento_autor PRIMARY KEY (cod_autor, cod_documento),
    CONSTRAINT fk_cod_autor_doc_autor FOREIGN KEY (cod_autor) REFERENCES AUTOR(cod_autor),
    CONSTRAINT fk_cod_documento_doc_autor FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE LIBRO_CATEGORIA (
    cod_categoria VARCHAR(10),
    cod_documento VARCHAR(10),
    CONSTRAINT pk_libro_categoria PRIMARY KEY (cod_categoria, cod_documento),
    CONSTRAINT fk_cod_categoria_libro_cat FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA(cod_categoria),
    CONSTRAINT fk_cod_documento_libro_cat FOREIGN KEY (cod_documento) REFERENCES LIBRO(cod_documento)
);

CREATE TABLE LIBRO_EDITADO (
    cod_linea VARCHAR(10),
    id_factura VARCHAR(10),
    cod_documento VARCHAR(10),
    CONSTRAINT pk_libro_editado PRIMARY KEY (cod_linea, id_factura, cod_documento),
    CONSTRAINT fk_cod_linea_libro_editado FOREIGN KEY (cod_linea) REFERENCES LINEA_DE_FACTURA(cod_linea),
    CONSTRAINT fk_id_factura_libro_editado FOREIGN KEY (id_factura) REFERENCES FACTURA(id_factura),
    CONSTRAINT fk_cod_documento_libro_editado FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

CREATE TABLE INFORME_TECNICO2 (
    cod_linea VARCHAR(10),
    id_factura VARCHAR(10),
    cod_documento VARCHAR(10),
    CONSTRAINT pk_informe_tecnico2 PRIMARY KEY (cod_linea, id_factura, cod_documento),
    CONSTRAINT fk_cod_linea_informe_tecnico2 FOREIGN KEY (cod_linea) REFERENCES LINEA_DE_FACTURA(cod_linea),
    CONSTRAINT fk_id_factura_informe_tecnico2 FOREIGN KEY (id_factura) REFERENCES FACTURA(id_factura),
    CONSTRAINT fk_cod_doc_inf_tec2 FOREIGN KEY (cod_documento) REFERENCES DOCUMENTO(cod_documento)
);

--INSERCIONES REALISTAS

-- Inserciones en la tabla USUARIO
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('11111111A', 'Laura', 'González', 'López', 'Calle Sol 123', 'Calle Luna 456', 'laura@gmail.com', 'lauragonzalez', 'Pass1234');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('22222222B', 'Pedro', 'Martínez', 'Sánchez', 'Avenida Central 789', 'Plaza Mayor 10', 'pedro@gmail.com', 'pedromartinez', 'Secure123');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('33333333C', 'Ana', 'Rodríguez', 'Martín', 'Calle Estrella 321', 'Avenida del Mar 789', 'ana@gmail.com', 'anarodriguez', 'AnaPass');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('44444444D', 'David', 'López', 'García', 'Calle Mayor 987', 'Paseo de la Montaña 12', 'david@gmail.com', 'davidlopez', 'Dav1dP@ss');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('55555555E', 'Elena', 'Sánchez', 'Martínez', 'Avenida del Parque 654', 'Plaza del Sol 32', 'elena@gmail.com', 'elenasanchez', 'Elen@123');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('66666666F', 'Mario', 'Fernández', 'López', 'Calle Mar 123', 'Calle Sol 456', 'mario@gmail.com', 'mariofernandez', 'M@rioPass');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('77777777G', 'Sara', 'García', 'Sánchez', 'Avenida del Río 789', 'Paseo de la Playa 10', 'sara@gmail.com', 'saragarcia', 'S@raSecure');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('88888888H', 'Carlos', 'Hernández', 'Martínez', 'Calle Mayor 456', 'Avenida Principal 78', 'carlos@gmail.com', 'carloshernandez', 'CarloPass123');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('99999999I', 'Lucía', 'Martínez', 'Gómez', 'Avenida del Río 987', 'Calle de la Paz 321', 'lucia@gmail.com', 'luciamartinez', 'Luci@Pass321');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('10101010J', 'Eduardo', 'Gómez', 'Fernández', 'Calle del Sol 456', 'Plaza del Pueblo 789', 'eduardo@gmail.com', 'eduardogomez', 'Edu@rdo123');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('12121212K', 'Sofía', 'Pérez', 'González', 'Avenida Central 654', 'Calle Mayor 32', 'sofia@gmail.com', 'sofiaperez', 'SofiaPass456');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('13131313L', 'Diego', 'Fernández', 'García', 'Calle de la Luna 123', 'Avenida del Mar 456', 'diego@gmail.com', 'diegofernandez', 'DiegoPass789');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('14141414M', 'Marina', 'López', 'Sánchez', 'Avenida del Monte 9', 'Calle Estrella 321', 'marina@gmail.com', 'marinalopez', 'M@rinaPass987');
INSERT INTO USUARIO (DNI, nombre, apellido1, apellido2, direccion_envio, direccion_facturacion, correo_electronico, login, password) VALUES ('15151515N', 'Pablo', 'Ruiz', 'Hernández', 'Calle del Mar 456', 'Plaza del Sol 789', 'pablo@gmail.com', 'pabloruiz', 'PabloSecure123');

-- Inserciones en la tabla DOCUMENTO
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC001', 'La Octava Maravilla', 79.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC002', 'Las dos Españas', 19.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC003', 'El Imperio Romano', 39.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC004', 'Mates Aplicadas', 19.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC005', 'La Revolución', 29.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC006', 'Historia', 49.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC007', 'Programación', 59.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC008', 'Arquitectura Moderna', 69.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC009', 'Historia del Arte', 39.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC010', 'Inteligencia Humana', 79.99);
INSERT INTO DOCUMENTO (cod_documento, titulo, precio_venta) VALUES ('DOC011', 'Biología Molecular', 89.99);

-- Inserciones en la tabla LIBRO
INSERT INTO LIBRO (cod_documento, ISBN, fecha_publicacion, editorial, sinapsis) VALUES ('DOC001', '978-3-16-148411-1', '2023-05-20', 'Editorial ABC', 'Una apasionante historia sobre...');
INSERT INTO LIBRO (cod_documento, ISBN, fecha_publicacion, editorial, sinapsis) VALUES ('DOC002', '978-3-16-148412-2', '2022-12-15', 'Editorial XYZ', 'Un libro que explora el mundo de...');
INSERT INTO LIBRO (cod_documento, ISBN, fecha_publicacion, editorial, sinapsis) VALUES ('DOC003', '978-3-16-148413-3', '2023-02-10', 'Editorial 123', 'Una obra fundamental sobre el tema de...');
INSERT INTO LIBRO (cod_documento, ISBN, fecha_publicacion, editorial, sinapsis) VALUES ('DOC004', '978-3-16-148414-4', '2022-08-25', 'Editorial XYZ', 'Una obra fundamental que aborda...');

-- Inserciones en la tabla INFORME_TECNICO
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC005', 'Investigación ABC', 'Técnico', 'Calle Ciencia 123', 123);
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC006', 'Instituto Tecnológico', 'Científico', 'Avenida Innovación 789', 456);
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC007', 'Laboratorio 123', 'Técnico', 'Plaza Tecnología 456', 789);
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC008', 'Instituto Investigación', 'Técnico', 'Calle Ciencia 321', 321);
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC009', 'Centro de Innovación', 'Científico', 'Avenida Tecnología 654', 64);
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC010', 'Laboratorio 456', 'Técnico', 'Plaza Innovación 987', 98);
INSERT INTO INFORME_TECNICO (cod_documento, institucion, tipo, direccion, numero) VALUES ('DOC011', 'Instituto Investigación', 'Científico', 'Calle Investigación 123', 3);

-- Inserciones en la tabla AUTOR
INSERT INTO AUTOR (cod_autor, nombre, apellido1, fecha_nacimiento, localidad) VALUES ('AUT003', 'Luis', 'Hernández', '1985-08-25', 'Sevilla');
INSERT INTO AUTOR (cod_autor, nombre, apellido1, fecha_nacimiento, localidad) VALUES ('AUT004', 'Carmen', 'Díaz', '1990-03-15', 'Valencia');
INSERT INTO AUTOR (cod_autor, nombre, apellido1, fecha_nacimiento, localidad) VALUES ('AUT005', 'Javier', 'Ruiz', '1970-12-01', 'Madrid');
INSERT INTO AUTOR (cod_autor, nombre, apellido1, fecha_nacimiento, localidad) VALUES ('AUT006', 'Sergio', 'García', '1978-05-20', 'Barcelona');
INSERT INTO AUTOR (cod_autor, nombre, apellido1, fecha_nacimiento, localidad) VALUES ('AUT007', 'Eva', 'Pérez', '1983-11-15', 'Valencia');
INSERT INTO AUTOR (cod_autor, nombre, apellido1, fecha_nacimiento, localidad) VALUES ('AUT008', 'Jorge', 'López', '1965-07-01', 'Madrid');

-- Inserciones en la tabla CATEGORIA
INSERT INTO CATEGORIA (cod_categoria, nombre_categoria) VALUES ('CAT001', 'Filosofia');
INSERT INTO CATEGORIA (cod_categoria, nombre_categoria) VALUES ('CAT002', 'Derecho');
INSERT INTO CATEGORIA (cod_categoria, nombre_categoria) VALUES ('CAT003', 'Psicologia');

-- Inserciones en la tabla FACTURA
INSERT INTO FACTURA (id_factura, DNI, fecha) VALUES ('FAC001', '77777777G', '2024-02-15');
INSERT INTO FACTURA (id_factura, DNI, fecha) VALUES ('FAC002', '88888888H', '2024-02-14');
INSERT INTO FACTURA (id_factura, DNI, fecha) VALUES ('FAC003', '99999999I', '2024-02-13');

-- Inserciones en la tabla EDITADO
INSERT INTO EDITADO (cod_documento) VALUES ('DOC004');
INSERT INTO EDITADO (cod_documento) VALUES ('DOC005');
INSERT INTO EDITADO (cod_documento) VALUES ('DOC007');

-- Inserciones en la tabla NO_EDITADO
INSERT INTO NO_EDITADO (cod_documento, fecha_lanzamiento) VALUES ('DOC002', '2023-02-15');
INSERT INTO NO_EDITADO (cod_documento, fecha_lanzamiento) VALUES ('DOC003', '2023-01-20');
INSERT INTO NO_EDITADO (cod_documento, fecha_lanzamiento) VALUES ('DOC006', '2023-03-10');

-- Inserciones en la tabla LINEA_DE_FACTURA
INSERT INTO LINEA_DE_FACTURA (cod_linea, id_factura, cod_documento) VALUES ('LIN001', 'FAC001', 'DOC001');
INSERT INTO LINEA_DE_FACTURA (cod_linea, id_factura, cod_documento) VALUES ('LIN002', 'FAC002', 'DOC003');
INSERT INTO LINEA_DE_FACTURA (cod_linea, id_factura, cod_documento) VALUES ('LIN003', 'FAC003', 'DOC005');

-- Inserciones en la tabla USUARIO_EDITADO
INSERT INTO USUARIO_EDITADO (DNI, cod_documento, fecha, cantidad) VALUES ('77777777G', 'DOC004', '2024-02-15', 2);
INSERT INTO USUARIO_EDITADO (DNI, cod_documento, fecha, cantidad) VALUES ('88888888H', 'DOC005', '2024-02-14', 1);
INSERT INTO USUARIO_EDITADO (DNI, cod_documento, fecha, cantidad) VALUES ('99999999I', 'DOC007', '2024-02-13', 3);

-- Inserciones en la tabla USUARIO_INFORME_TECNICO
INSERT INTO USUARIO_INFORME_TECNICO (DNI, cod_documento, fecha) VALUES ('77777777G', 'DOC008', '2024-02-15');
INSERT INTO USUARIO_INFORME_TECNICO (DNI, cod_documento, fecha) VALUES ('88888888H', 'DOC009', '2024-02-14');
INSERT INTO USUARIO_INFORME_TECNICO (DNI, cod_documento, fecha) VALUES ('99999999I', 'DOC010', '2024-02-13');

-- Inserciones en la tabla USUARIO_NO_EDITADO_NOTIFICA
INSERT INTO USUARIO_NO_EDITADO_NOTIFICA (DNI, cod_documento, fecha_peticion) VALUES ('77777777G', 'DOC002', '2024-02-15');
INSERT INTO USUARIO_NO_EDITADO_NOTIFICA (DNI, cod_documento, fecha_peticion) VALUES ('88888888H', 'DOC003', '2024-02-14');
INSERT INTO USUARIO_NO_EDITADO_NOTIFICA (DNI, cod_documento, fecha_peticion) VALUES ('99999999I', 'DOC006', '2024-02-13');

-- Inserciones en la tabla USUARIO_NO_EDITADO_RESERVA
INSERT INTO USUARIO_NO_EDITADO_RESERVA (DNI, cod_documento, fecha_reserva) VALUES ('77777777G', 'DOC002', '2024-02-15');
INSERT INTO USUARIO_NO_EDITADO_RESERVA (DNI, cod_documento, fecha_reserva) VALUES ('88888888H', 'DOC003', '2024-02-14');
INSERT INTO USUARIO_NO_EDITADO_RESERVA (DNI, cod_documento, fecha_reserva) VALUES ('99999999I', 'DOC006', '2024-02-13');

-- Inserciones en la tabla DOCUMENTO_AUTOR
INSERT INTO DOCUMENTO_AUTOR (cod_autor, cod_documento) VALUES ('AUT003', 'DOC001');
INSERT INTO DOCUMENTO_AUTOR (cod_autor, cod_documento) VALUES ('AUT004', 'DOC002');
INSERT INTO DOCUMENTO_AUTOR (cod_autor, cod_documento) VALUES ('AUT005', 'DOC003');
INSERT INTO DOCUMENTO_AUTOR (cod_autor, cod_documento) VALUES ('AUT006', 'DOC004');
INSERT INTO DOCUMENTO_AUTOR (cod_autor, cod_documento) VALUES ('AUT007', 'DOC005');
INSERT INTO DOCUMENTO_AUTOR (cod_autor, cod_documento) VALUES ('AUT008', 'DOC006');

-- Inserciones en la tabla LIBRO_CATEGORIA
INSERT INTO LIBRO_CATEGORIA (cod_categoria, cod_documento) VALUES ('CAT001', 'DOC001');
INSERT INTO LIBRO_CATEGORIA (cod_categoria, cod_documento) VALUES ('CAT002', 'DOC002');
INSERT INTO LIBRO_CATEGORIA (cod_categoria, cod_documento) VALUES ('CAT003', 'DOC003');

-- Inserciones en la tabla LIBRO_EDITADO
INSERT INTO LIBRO_EDITADO (cod_linea, id_factura, cod_documento) VALUES ('LIN001', 'FAC001', 'DOC004');
INSERT INTO LIBRO_EDITADO (cod_linea, id_factura, cod_documento) VALUES ('LIN002', 'FAC002', 'DOC005');
INSERT INTO LIBRO_EDITADO (cod_linea, id_factura, cod_documento) VALUES ('LIN003', 'FAC003', 'DOC007');

-- Inserciones en la tabla INFORME_TECNICO2
INSERT INTO INFORME_TECNICO2 (cod_linea, id_factura, cod_documento) VALUES ('LIN001', 'FAC001', 'DOC008');
INSERT INTO INFORME_TECNICO2 (cod_linea, id_factura, cod_documento) VALUES ('LIN002', 'FAC002', 'DOC009');
INSERT INTO INFORME_TECNICO2 (cod_linea, id_factura, cod_documento) VALUES ('LIN003', 'FAC003', 'DOC010');
