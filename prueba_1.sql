-- Script para crear y poblar la base de datos para la Prueba 1
-- Ejecutar en Oracle SQL Developer en el esquema del estudiante (curso_topicos)

-- Habilitar salida de mensajes para PL/SQL
SET SERVEROUTPUT ON;

-- Eliminar tablas si ya existen (para evitar errores si el script se ejecuta más de una vez)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Asignaciones CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Tabla Asignaciones eliminada (si existía).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Tabla Asignaciones no existía.');
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Proyectos CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Tabla Proyectos eliminada (si existía).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Tabla Proyectos no existía.');
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Empleados CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Tabla Empleados eliminada (si existía).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Tabla Empleados no existía.');
END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Departamentos CASCADE CONSTRAINTS';
    DBMS_OUTPUT.PUT_LINE('Tabla Departamentos eliminada (si existía).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Tabla Departamentos no existía.');
END;
/

-- Crear tabla Departamentos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Departamentos...');
    EXECUTE IMMEDIATE 'CREATE TABLE Departamentos (
        DepartamentoID NUMBER PRIMARY KEY,
        Nombre VARCHAR2(50),
        Ubicacion VARCHAR2(50)
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Departamentos creada.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al crear tabla Departamentos: ' || SQLERRM);
        RAISE;
END;
/

-- Crear tabla Empleados
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Empleados...');
    EXECUTE IMMEDIATE 'CREATE TABLE Empleados (
        EmpleadoID NUMBER PRIMARY KEY,
        Nombre VARCHAR2(50),
        DepartamentoID NUMBER,
        Salario NUMBER,
        FechaContratacion DATE,
        CONSTRAINT fk_empleado_departamento FOREIGN KEY (DepartamentoID) REFERENCES Departamentos(DepartamentoID)
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Empleados creada.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al crear tabla Empleados: ' || SQLERRM);
        RAISE;
END;
/

-- Crear tabla Proyectos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Proyectos...');
    EXECUTE IMMEDIATE 'CREATE TABLE Proyectos (
        ProyectoID NUMBER PRIMARY KEY,
        Nombre VARCHAR2(50),
        Presupuesto NUMBER,
        FechaInicio DATE
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Proyectos creada.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al crear tabla Proyectos: ' || SQLERRM);
        RAISE;
END;
/

-- Crear tabla Asignaciones (muchos a muchos entre Empleados y Proyectos)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Asignaciones...');
    EXECUTE IMMEDIATE 'CREATE TABLE Asignaciones (
        AsignacionID NUMBER PRIMARY KEY,
        EmpleadoID NUMBER,
        ProyectoID NUMBER,
        Horas NUMBER,
        CONSTRAINT fk_asignacion_empleado FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
        CONSTRAINT fk_asignacion_proyecto FOREIGN KEY (ProyectoID) REFERENCES Proyectos(ProyectoID)
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Asignaciones creada.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al crear tabla Asignaciones: ' || SQLERRM);
        RAISE;
END;
/

-- Insertar datos en Departamentos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Departamentos...');
    INSERT INTO Departamentos VALUES (1, 'Ventas', 'Santiago');
    INSERT INTO Departamentos VALUES (2, 'TI', 'Valparaíso');
    INSERT INTO Departamentos VALUES (3, 'RRHH', 'Santiago');
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Departamentos.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar datos en Departamentos: ' || SQLERRM);
        RAISE;
END;
/

-- Insertar datos en Empleados
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Empleados...');
    INSERT INTO Empleados VALUES (101, 'Luis Martínez', 1, 500000, TO_DATE('2020-01-15', 'YYYY-MM-DD'));
    INSERT INTO Empleados VALUES (102, 'Carla Soto', 2, 700000, TO_DATE('2019-06-20', 'YYYY-MM-DD'));
    INSERT INTO Empleados VALUES (103, 'Pedro Gómez', 2, 650000, TO_DATE('2021-03-10', 'YYYY-MM-DD'));
    INSERT INTO Empleados VALUES (104, 'Ana Torres', 3, 450000, TO_DATE('2022-09-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Empleados.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar datos en Empleados: ' || SQLERRM);
        RAISE;
END;
/

-- Insertar datos en Proyectos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Proyectos...');
    INSERT INTO Proyectos VALUES (201, 'Sistema CRM', 2000000, TO_DATE('2025-01-01', 'YYYY-MM-DD'));
    INSERT INTO Proyectos VALUES (202, 'App Móvil', 1500000, TO_DATE('2025-02-15', 'YYYY-MM-DD'));
    INSERT INTO Proyectos VALUES (203, 'Capacitación', 500000, TO_DATE('2025-03-01', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Proyectos.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar datos en Proyectos: ' || SQLERRM);
        RAISE;
END;
/

-- Insertar datos en Asignaciones
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Asignaciones...');
    INSERT INTO Asignaciones VALUES (1, 101, 201, 40);
    INSERT INTO Asignaciones VALUES (2, 102, 201, 30);
    INSERT INTO Asignaciones VALUES (3, 102, 202, 20);
    INSERT INTO Asignaciones VALUES (4, 103, 202, 35);
    INSERT INTO Asignaciones VALUES (5, 104, 203, 25);
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Asignaciones.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al insertar datos en Asignaciones: ' || SQLERRM);
        RAISE;
END;
/

-- Confirmar creación e inserción de datos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Tablas creadas y datos insertados correctamente.');
END;
/

-- Verificar datos
SELECT * FROM Departamentos;
SELECT * FROM Empleados;
SELECT * FROM Proyectos;
SELECT * FROM Asignaciones;

-- Commit para asegurar los cambios
COMMIT;