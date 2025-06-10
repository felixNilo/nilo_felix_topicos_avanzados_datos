/*
***PARTE 1***

*/

/*

Pregunta 1: Diferencia entre Procedimiento y Función (10 puntos)
Enunciado: Explica la diferencia entre un procedimiento almacenado y una función almacenada en PL/SQL. Da un ejemplo de cuándo usarías cada uno en el contexto de la base de datos de la prueba.

Respuesta Correcta:

    Un procedimiento almacenado en PL/SQL es un bloque de código que ejecuta una serie de acciones (como INSERT, UPDATE o DELETE) y puede aceptar parámetros (IN, OUT, IN OUT), pero no devuelve un valor directamente con RETURN. Una función almacenada es un bloque de código que realiza un cálculo y devuelve un único valor usando RETURN, siendo utilizable en consultas SQL.

    Ejemplo de uso: Usaría un procedimiento para registrar un movimiento en la tabla Movimientos (Ejercicio 1), ya que implica actualizar datos sin necesidad de devolver un valor. Usaría una función para calcular el valor total del inventario de un proveedor (Ejercicio 2), ya que necesito un valor calculado para usarlo en un procedimiento o consulta.

Criterios de Evaluación (10 puntos):

    Diferencia (5 puntos): Explicar que procedimientos ejecutan acciones y funciones devuelven valores.
    Ejemplo en Contexto (5 puntos): Proporcionar un caso de uso relevante para cada uno basado en la base de datos (Movimientos, Inventario, etc.).

Pregunta 2: Uso de Parámetro IN OUT (10 puntos)
Enunciado: Describe cómo usarías un parámetro IN OUT en un procedimiento almacenado. Escribe un ejemplo de un procedimiento que use un parámetro IN OUT para actualizar y devolver la cantidad en inventario después de un movimiento.

Respuesta Correcta:

    Usaría un parámetro IN OUT en un procedimiento para pasar un valor inicial (como una cantidad) que se modifica dentro del procedimiento y luego se devuelve al llamador para reflejar el cambio.

    Ejemplo:

    CREATE OR REPLACE PROCEDURE actualizar_cantidad_inventario(p_producto_id IN NUMBER, p_cantidad IN OUT NUMBER) AS
    BEGIN
    UPDATE Inventario
    SET Cantidad = Cantidad + p_cantidad
    WHERE ProductoID = p_producto_id;
    SELECT Cantidad INTO p_cantidad FROM Inventario WHERE ProductoID = p_producto_id;
    END;
    /

Criterios de Evaluación (10 puntos):

    Descripción (5 puntos): Explicar que IN OUT permite pasar y retornar un valor modificado.
    Ejemplo (5 puntos): Proporcionar un procedimiento con sintaxis correcta y lógica que actualice y devuelva la cantidad.

Pregunta 3: Uso de Función en Consulta SQL (10 puntos)
Enunciado: ¿Cómo se puede usar una función almacenada dentro de una consulta SQL? Escribe un ejemplo de una función que calcule el valor total del inventario de un producto (Precio * Cantidad) y úsala en una consulta para listar los productos con su valor total.

Respuesta Correcta:

    Una función almacenada se puede usar dentro de una consulta SQL al invocarla en el cláusula SELECT, WHERE u otras, como si fuera una columna calculada.

    Ejemplo:

    CREATE OR REPLACE FUNCTION valor_inventario_producto(p_producto_id IN NUMBER) RETURN NUMBER AS
    v_valor NUMBER;
    BEGIN
    SELECT SUM(Precio * Cantidad) INTO v_valor
    FROM Productos P
    JOIN Inventario I ON P.ProductoID = I.ProductoID
    WHERE P.ProductoID = p_producto_id;
    RETURN NVL(v_valor, 0);
    END;
    /
    SELECT ProductoID, Nombre, valor_inventario_producto(ProductoID) AS ValorTotal
    FROM Productos;

Criterios de Evaluación (10 puntos):

    Explicación (5 points): Describir cómo se usa en una consulta SQL (p.ej., en SELECT).
    Ejemplo (5 points): Proporcionar una función que calcule el valor y una consulta que la use.

Pregunta 4: Explicación de Trigger y Ejemplo (10 puntos)
Enunciado: Explica qué es un trigger y menciona dos tipos de eventos que pueden dispararlo. Da un ejemplo de un trigger que se dispare después de insertar un movimiento en la tabla Movimientos y actualice la cantidad en Inventario.

Respuesta Correcta:

    Un trigger es un bloque PL/SQL que se ejecuta automáticamente al ocurrir un evento específico en una tabla, como una operación DML. Dos tipos de eventos que pueden dispararlo son INSERT y DELETE.

    Ejemplo:

    CREATE OR REPLACE TRIGGER actualizar_inventario
    AFTER INSERT ON Movimientos
    FOR EACH ROW
    BEGIN
    UPDATE Inventario
    SET Cantidad = Cantidad + :NEW.Cantidad,
        FechaActualizacion = SYSDATE
    WHERE ProductoID = :NEW.ProductoID;
    END;
    /

Criterios de Evaluación (10 puntos):

    Explicación (5 points): Definir un trigger y mencionar dos eventos (p.ej., INSERT, DELETE).
    Ejemplo (5 points): Proporcionar un trigger que actualice Inventario tras un INSERT en Movimientos.

/*
***PARTE 2***
*/

Ejercicio 1: Procedimiento registrar_movimiento (20 puntos)
Enunciado: Escribe un procedimiento registrar_movimiento que reciba un ProductoID, TipoMovimiento ('Entrada' o 'Salida'), y Cantidad (parámetros IN). El procedimiento debe:

    Insertar un nuevo movimiento en la tabla Movimientos (usa el próximo MovimientoID disponible).
    Actualizar la cantidad en Inventario según el tipo de movimiento.
    Actualizar la FechaActualizacion en Inventario a la fecha actual.
    Manejar excepciones si el producto no existe o si la cantidad en inventario se vuelve negativa.

Respuesta Correcta:

    CREATE OR REPLACE PROCEDURE registrar_movimiento(p_producto_id IN NUMBER, p_tipo_movimiento IN VARCHAR2, p_cantidad IN NUMBER) AS
    v_nuevo_id NUMBER;
    v_cantidad_actual NUMBER;
    BEGIN
    SELECT NVL(MAX(MovimientoID), 0) + 1 INTO v_nuevo_id FROM Movimientos;
    SELECT Cantidad INTO v_cantidad_actual FROM Inventario WHERE ProductoID = p_producto_id;
    
    IF p_tipo_movimiento = 'Entrada' THEN
        UPDATE Inventario
        SET Cantidad = Cantidad + p_cantidad,
            FechaActualizacion = SYSDATE
        WHERE ProductoID = p_producto_id;
    ELSIF p_tipo_movimiento = 'Salida' THEN
        IF Cantidad - p_cantidad < 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cantidad insuficiente en inventario.');
        END IF;
        UPDATE Inventario
        SET Cantidad = Cantidad - p_cantidad,
            FechaActualizacion = SYSDATE
        WHERE ProductoID = p_producto_id;
    END IF;
    
    INSERT INTO Movimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, FechaMovimiento)
    VALUES (v_nuevo_id, p_producto_id, p_tipo_movimiento, p_cantidad, SYSDATE);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Producto no encontrado.');
    END;
    /

Criterios de Evaluación (20 puntos):

    Inserción (5 points): Insertar un movimiento con un MovimientoID calculado.
    Actualización de Cantidad (5 points): Actualizar según 'Entrada' o 'Salida'.
    Actualización de Fecha (5 points): Usar SYSDATE para FechaActualizacion.
    Manejo de Excepciones (5 points): Manejar NO_DATA_FOUND y cantidad negativa.

Ejercicio 2: Función y Procedimiento (20 puntos)
Enunciado: Escribe una función calcular_valor_inventario_proveedor que reciba un ProveedorID (parámetro IN) y devuelva el valor total del inventario de los productos de ese proveedor (suma de Precio * Cantidad). Luego, usa la función en un procedimiento mostrar_valor_proveedor que muestre el valor total del inventario por proveedor para todos los proveedores.

Respuesta Correcta:

    CREATE OR REPLACE FUNCTION calcular_valor_inventario_proveedor(p_proveedor_id IN NUMBER) RETURN NUMBER AS
    v_total NUMBER;
    BEGIN
    SELECT SUM(P.Precio * I.Cantidad) INTO v_total
    FROM Productos P
    JOIN Inventario I ON P.ProductoID = I.ProductoID
    WHERE P.ProveedorID = p_proveedor_id;
    RETURN NVL(v_total, 0);
    END;
    /

    CREATE OR REPLACE PROCEDURE mostrar_valor_proveedor AS
    CURSOR c_proveedores IS SELECT ProveedorID, Nombre FROM Proveedores;
    BEGIN
    FOR rec IN c_proveedores LOOP
        DBMS_OUTPUT.PUT_LINE('Proveedor: ' || rec.Nombre || ' - Valor Total: ' || calcular_valor_inventario_proveedor(rec.ProveedorID));
    END LOOP;
    END;
    /

Criterios de Evaluación (20 points):

    Función (10 puntos): Calcular y devolver el valor total con SUM y JOIN.
    Procedimiento (10 puntos): Usar un cursor para mostrar el valor por proveedor.

Ejercicio 3: Trigger auditar_movimientos (20 points)
Enunciado: Crea un trigger auditar_movimientos que se dispare después de insertar o eliminar un movimiento en la tabla Movimientos y registre el MovimientoID, ProductoID, TipoMovimiento, Cantidad, la acción ('INSERT' o 'DELETE') y la fecha en una tabla de auditoría AuditoriaMovimientos.

Respuesta Correcta:

    CREATE TABLE AuditoriaMovimientos (
    AuditoriaID NUMBER PRIMARY KEY,
    MovimientoID NUMBER,
    ProductoID NUMBER,
    TipoMovimiento VARCHAR2(10),
    Cantidad NUMBER,
    Accion VARCHAR2(10),
    FechaRegistro DATE
    );

    CREATE OR REPLACE TRIGGER auditar_movimientos
    AFTER INSERT OR DELETE ON Movimientos
    FOR EACH ROW
    BEGIN
    IF INSERTING THEN
        INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, Accion, FechaRegistro)
        VALUES (:NEW.MovimientoID, :NEW.ProductoID, :NEW.TipoMovimiento, :NEW.Cantidad, 'INSERT', SYSDATE);
    ELSIF DELETING THEN
        INSERT INTO AuditoriaMovimientos (MovimientoID, ProductoID, TipoMovimiento, Cantidad, Accion, FechaRegistro)
        VALUES (:OLD.MovimientoID, :OLD.ProductoID, :OLD.TipoMovimiento, :OLD.Cantidad, 'DELETE', SYSDATE);
    END IF;
    END;
    /
    
Criterios de Evaluación (20 points):

Creación de Tabla (10 points): Crear AuditoriaMovimientos con las columnas solicitadas.
Trigger (10 points): Implementar un trigger que registre INSERT y DELETE.