-- Eliminar tablas si existen para evitar errores
BEGIN
    FOR tbl IN (SELECT table_name FROM user_tables WHERE table_name IN ('EMPLEADOS', 'PROYECTOS', 'ASIGNACIONES', 'REGISTROSTIEMPO'))
    LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || tbl.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        NULL; -- Ignorar errores si las tablas no existen
END;
/

-- Crear tabla para empleados (base para herencia)
CREATE TABLE Empleados (
    EmpleadoID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre VARCHAR2(100),
    TipoEmpleado VARCHAR2(50), -- Para simular herencia (Desarrollador, etc.)
    Salario NUMBER(10,2)
);

-- Crear tabla para proyectos
CREATE TABLE Proyectos (
    ProyectoID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre VARCHAR2(100),
    Presupuesto NUMBER(15,2),
    FechaInicio DATE,
    FechaFin DATE
);

-- Crear tabla para asignaciones (relación entre empleados y proyectos)
CREATE TABLE Asignaciones (
    AsignacionID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    EmpleadoID NUMBER,
    ProyectoID NUMBER,
    FechaAsignacion DATE,
    Rol VARCHAR2(50),
    CONSTRAINT fk_empleado FOREIGN KEY (EmpleadoID) REFERENCES Empleados(EmpleadoID),
    CONSTRAINT fk_proyecto FOREIGN KEY (ProyectoID) REFERENCES Proyectos(ProyectoID)
);

-- Crear tabla RegistrosTiempo para registrar horas trabajadas
CREATE TABLE RegistrosTiempo (
    RegistroID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    AsignacionID NUMBER,
    Fecha DATE,
    HorasTrabajadas NUMBER(5,2),
    CONSTRAINT fk_asignacion FOREIGN KEY (AsignacionID) REFERENCES Asignaciones(AsignacionID),
    CONSTRAINT chk_horas CHECK (HorasTrabajadas >= 0 AND HorasTrabajadas <= 24)
);

-- Insertar datos iniciales para pruebas (más datos)
INSERT INTO Empleados (Nombre, TipoEmpleado, Salario) VALUES ('Juan Pérez', 'Desarrollador', 3000.00);
INSERT INTO Empleados (Nombre, TipoEmpleado, Salario) VALUES ('Ana Gómez', 'Gerente', 4000.00);
INSERT INTO Empleados (Nombre, TipoEmpleado, Salario) VALUES ('Luis Martínez', 'Desarrollador', 3200.00);
INSERT INTO Empleados (Nombre, TipoEmpleado, Salario) VALUES ('María López', 'Analista', 3500.00);

INSERT INTO Proyectos (Nombre, Presupuesto, FechaInicio, FechaFin) VALUES ('Proyecto A', 50000.00, TO_DATE('2025-01-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));
INSERT INTO Proyectos (Nombre, Presupuesto, FechaInicio, FechaFin) VALUES ('Proyecto B', 75000.00, TO_DATE('2025-02-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));
INSERT INTO Proyectos (Nombre, Presupuesto, FechaInicio, FechaFin) VALUES ('Proyecto C', 60000.00, TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-12-31', 'YYYY-MM-DD'));

INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion, Rol) VALUES (1, 1, TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Desarrollador');
INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion, Rol) VALUES (1, 2, TO_DATE('2025-02-01', 'YYYY-MM-DD'), 'Desarrollador');
INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion, Rol) VALUES (2, 1, TO_DATE('2025-01-01', 'YYYY-MM-DD'), 'Gerente');
INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion, Rol) VALUES (3, 2, TO_DATE('2025-02-01', 'YYYY-MM-DD'), 'Desarrollador');
INSERT INTO Asignaciones (EmpleadoID, ProyectoID, FechaAsignacion, Rol) VALUES (4, 3, TO_DATE('2025-03-01', 'YYYY-MM-DD'), 'Analista');

INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (1, TO_DATE('2025-03-01', 'YYYY-MM-DD'), 6.5);
INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (1, TO_DATE('2025-03-02', 'YYYY-MM-DD'), 7.0);
INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (2, TO_DATE('2025-03-01', 'YYYY-MM-DD'), 5.0);
INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (3, TO_DATE('2025-03-02', 'YYYY-MM-DD'), 4.5);
INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (4, TO_DATE('2025-03-03', 'YYYY-MM-DD'), 8.0);
INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (4, TO_DATE('2025-04-01', 'YYYY-MM-DD'), 6.0);
INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas) VALUES (5, TO_DATE('2025-03-01', 'YYYY-MM-DD'), 7.5);

-- Confirmar transacciones
COMMIT;