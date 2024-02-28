# proyecto_BD
Proyecto Python con Base de Datos

Para el proyecto se seleccionarán tres tablas relacionadas:
- Tabla USUARIO
- Tabla FACTURA
- Tabla LINEA_DE_FACTURA

Operaciones a realizar:
- Listar información: Se listarán los nombres de los usuarios junto con la cantidad de facturas asociadas a cada uno.
- Buscar o filtrar información: Se pedirá al usuario que introduzca el DNI de un usuario y se mostrarán todas las facturas asociadas a ese usuario.
- Buscar información relacionada: Se solicitará al usuario que introduzca el ID de una factura y se mostrarán todos los documentos (a través de la tabla LINEA_DE_FACTURA) asociados a esa factura.
- Insertar información: Se pedirá al usuario que introduzca los datos de una nueva factura y se agregarán a la base de datos.
- Borrar información: Se pedirá al usuario que introduzca el DNI de un usuario y se eliminarán todas las facturas asociadas a ese usuario.
- Actualizar información: Se pedirá al usuario que introduzca el ID de una factura y el nuevo DNI del usuario asociado, y se actualizará la información en la base de datos.

Estas operaciones se implementarán en tres programas Python, uno para cada uno de los SGBD trabajados en clase: Oracle, MySQL/MariaDB y PostgreSQL. 
Cada programa realizará las mismas operaciones pero adaptadas a las particularidades de cada gestor de base de datos.
