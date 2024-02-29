import cx_Oracle
import sys

# Conexión a la base de datos
def conectar_bd():
    try:
        conexion = cx_Oracle.connect(
            user="proyectof3",
            password="proyectof3",
            dsn="localhost/XE"
        )
        return conexion
    except cx_Oracle.Error as error:
        print("Error al conectar a la base de datos:", error)
        return None

# Función Menú
def menu():
    opciones = {
        "1": listar_usuarios_con_facturas,
        "2": buscar_facturas_por_dni,
        "3": buscar_documentos_por_factura,
        "4": insertar_nueva_factura,
        "5": borrar_facturas_por_dni,
        "6": actualizar_usuario_factura,
        "7": salir
    }
    while True:
        print("\nSelecciona una opción:")
        print("1. Listar información: Nombres de usuarios y cantidad de facturas asociadas")
        print("2. Buscar facturas por DNI de usuario")
        print("3. Buscar documentos por ID de factura")
        print("4. Insertar nueva factura")
        print("5. Borrar facturas por DNI de usuario")
        print("6. Actualizar usuario de una factura")
        print("7. Salir")
        opcion = input("\nIntroduce una opción: ")

        if opcion in opciones:
            opciones[opcion]()
        else:
            print("\nOpción no válida. Por favor, selecciona una opción válida.")

# Función para listar usuarios con facturas
def listar_usuarios_con_facturas():
    conexion = conectar_bd()
    if conexion:
        try:
            cursor = conexion.cursor()
            consulta = """
            SELECT nombre, COUNT(*) AS cantidad_facturas 
            FROM USUARIO 
            INNER JOIN FACTURA ON USUARIO.DNI = FACTURA.DNI 
            GROUP BY nombre
            """
            cursor.execute(consulta)
            resultados = cursor.fetchall()
            for nombre, cantidad_facturas in resultados:
                print(f"{nombre}: {cantidad_facturas} facturas")
            cursor.close()
            conexion.close()
        except cx_Oracle.Error as error:
            print("Error al ejecutar la consulta:", error)

# Función para buscar facturas por DNI de usuario
def buscar_facturas_por_dni():
    dni_usuario = input("Introduce el DNI del usuario: ")
    conexion = conectar_bd()
    if conexion:
        try:
            cursor = conexion.cursor()
            consulta = "SELECT * FROM FACTURA WHERE DNI = :dni"
            cursor.execute(consulta, dni=dni_usuario)
            resultados = cursor.fetchall()
            if not resultados:
                print("No se encontraron facturas para el DNI proporcionado.")
            else:
                print("Facturas encontradas para el DNI proporcionado:")
                for factura in resultados:
                    print(factura)
            cursor.close()
            conexion.close()
        except cx_Oracle.Error as error:
            print("Error al ejecutar la consulta:", error)

# Función para buscar documentos por ID de factura
def buscar_documentos_por_factura():
    id_factura = input("Introduce el ID de la factura: ")
    conexion = conectar_bd()
    if conexion:
        try:
            cursor = conexion.cursor()
            consulta = """
            SELECT d.* 
            FROM DOCUMENTO d 
            INNER JOIN LINEA_DE_FACTURA lf ON d.cod_documento = lf.cod_documento 
            WHERE lf.id_factura = :id_factura
            """
            cursor.execute(consulta, id_factura=id_factura)
            resultados = cursor.fetchall()
            if not resultados:
                print("No se encontraron documentos para el ID de factura proporcionado.")
            else:
                print("Documentos encontrados para el ID de factura proporcionado:")
                for documento in resultados:
                    print(documento)
            cursor.close()
            conexion.close()
        except cx_Oracle.Error as error:
            print("Error al ejecutar la consulta:", error)

# Función para insertar una nueva factura
def insertar_nueva_factura():
    id_factura = input("Introduce el ID de la nueva factura: ")
    dni_usuario = input("Introduce el DNI del usuario asociado a la factura: ")
    fecha = input("Introduce la fecha de la nueva factura (formato YYYY-MM-DD): ")

    conexion = conectar_bd()
    if conexion:
        try:
            cursor = conexion.cursor()
            # Verificar si el usuario existe
            consulta_usuario = "SELECT * FROM USUARIO WHERE DNI = :dni"
            cursor.execute(consulta_usuario, dni=dni_usuario)
            usuario_existente = cursor.fetchone()
            if not usuario_existente:
                print("El usuario con el DNI proporcionado no existe.")
                return

            # Insertar la nueva factura
            consulta_insertar_factura = """
            INSERT INTO FACTURA (id_factura, DNI, fecha) 
            VALUES (:id_factura, :dni_usuario, TO_DATE(:fecha, 'YYYY-MM-DD'))
            """
            cursor.execute(consulta_insertar_factura, (id_factura, dni_usuario, fecha))
            conexion.commit()
            print("Nueva factura insertada correctamente.")

            cursor.close()
            conexion.close()
        except cx_Oracle.Error as error:
            print("Error al insertar la nueva factura:", error)

# Función para borrar facturas por DNI de usuario
def borrar_facturas_por_dni():
    dni_usuario = input("Introduce el DNI del usuario cuyas facturas deseas borrar: ")

    conexion = conectar_bd()
    if conexion:
        try:
            cursor = conexion.cursor()
            # Verificar si el usuario existe
            consulta_usuario = "SELECT * FROM USUARIO WHERE DNI = :dni"
            cursor.execute(consulta_usuario, dni=dni_usuario)
            usuario_existente = cursor.fetchone()
            if not usuario_existente:
                print("El usuario con el DNI proporcionado no existe.")
                return

            # Borrar las facturas del usuario
            consulta_borrar_facturas = "DELETE FROM FACTURA WHERE DNI = :dni_usuario"
            cursor.execute(consulta_borrar_facturas, dni_usuario=dni_usuario)
            num_filas_afectadas = cursor.rowcount
            conexion.commit()

            print(f"Se borraron {num_filas_afectadas} facturas del usuario con DNI {dni_usuario} correctamente.")

            cursor.close()
            conexion.close()
        except cx_Oracle.Error as error:
            print("Error al borrar las facturas del usuario:", error)

# Función para actualizar usuario de una factura
def actualizar_usuario_factura():
    id_factura = input("Introduce el ID de la factura que deseas actualizar: ")
    nuevo_dni_usuario = input("Introduce el nuevo DNI del usuario asociado a la factura: ")

    conexion = conectar_bd()
    if conexion:
        try:
            cursor = conexion.cursor()
            # Verificar si la factura existe
            consulta_factura = "SELECT * FROM FACTURA WHERE id_factura = :id_factura"
            cursor.execute(consulta_factura, id_factura=id_factura)
            factura_existente = cursor.fetchone()
            if not factura_existente:
                print("La factura con el ID proporcionado no existe.")
                return

            # Verificar si el nuevo usuario existe
            consulta_usuario = "SELECT * FROM USUARIO WHERE DNI = :dni"
            cursor.execute(consulta_usuario, dni=nuevo_dni_usuario)
            usuario_existente = cursor.fetchone()
            if not usuario_existente:
                print("El usuario con el nuevo DNI proporcionado no existe.")
                return

            # Actualizar el usuario asociado a la factura
            consulta_actualizar_usuario = """
            UPDATE FACTURA SET DNI = :nuevo_dni_usuario WHERE id_factura = :id_factura
            """
            cursor.execute(consulta_actualizar_usuario, (nuevo_dni_usuario, id_factura))
            conexion.commit()

            print(f"Se actualizó el usuario de la factura con ID {id_factura} correctamente.")

            cursor.close()
            conexion.close()
        except cx_Oracle.Error as error:
            print("Error al actualizar el usuario de la factura:", error)

# Función para salir del programa
def salir():
    print("¡Hasta luego!")
    sys.exit()

menu()
