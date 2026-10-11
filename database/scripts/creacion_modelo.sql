-- 1. Crear la base de datos dimensional
CREATE DATABASE KentFoods_DW;
GO
USE KentFoods_DW;
GO

-- 2. Crear Dimensión Fecha
CREATE TABLE Dim_Fecha (
    SK_Fecha INT PRIMARY KEY, 
    Fecha DATE,
    Anio INT,
    Semestre INT,
    Trimestre INT,
    Mes INT,
    NombreMes NVARCHAR(20),
    Dia INT
);

-- 3. Crear Dimensión Producto
CREATE TABLE Dim_Producto (
    SK_Producto INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID INT, 
    NombreProducto NVARCHAR(100),
    NombreCategoria NVARCHAR(50),
    DescripcionCategoria NVARCHAR(200),
    NombreProveedor NVARCHAR(100),
    CiudadProveedor NVARCHAR(50),
    PaisProveedor NVARCHAR(50)
);

-- 4. Crear Dimensión Cliente
CREATE TABLE Dim_Cliente (
    SK_Cliente INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID NCHAR(5), 
    Empresa NVARCHAR(100),
    Contacto NVARCHAR(100),
    Cargo NVARCHAR(50),
    Ciudad NVARCHAR(50),
    Pais NVARCHAR(50)
);

-- 5. Crear Dimensión Empleado
CREATE TABLE Dim_Empleado (
    SK_Empleado INT IDENTITY(1,1) PRIMARY KEY,
    EmpleadoID INT,
    NombreCompleto NVARCHAR(100),
    Cargo NVARCHAR(50),
    Territorio NVARCHAR(50),
    Region NVARCHAR(50)
);

-- 6. Crear Dimensión Transportista
CREATE TABLE Dim_Transportista (
    SK_Transportista INT IDENTITY(1,1) PRIMARY KEY,
    TransportistaID INT,
    NombreTransportista NVARCHAR(100)
);

-- 7. Crear Tabla de Hechos (Fact_Ventas)
CREATE TABLE Fact_Ventas (
    SK_Producto INT,
    SK_Cliente INT,
    SK_Empleado INT,
    SK_Transportista INT,
    SK_FechaOrden INT,
    SK_FechaEnvio INT,
    Cantidad INT,
    PrecioUnitario DECIMAL(18,2),
    Descuento DECIMAL(18,2),
    MontoVenta DECIMAL(18,2),      
    MontoDescuento DECIMAL(18,2),  
    CONSTRAINT FK_Fact_Producto FOREIGN KEY (SK_Producto) REFERENCES Dim_Producto(SK_Producto),
    CONSTRAINT FK_Fact_Cliente FOREIGN KEY (SK_Cliente) REFERENCES Dim_Cliente(SK_Cliente),
    CONSTRAINT FK_Fact_Empleado FOREIGN KEY (SK_Empleado) REFERENCES Dim_Empleado(SK_Empleado),
    CONSTRAINT FK_Fact_Transportista FOREIGN KEY (SK_Transportista) REFERENCES Dim_Transportista(SK_Transportista),
    CONSTRAINT FK_Fact_FechaOrden FOREIGN KEY (SK_FechaOrden) REFERENCES Dim_Fecha(SK_Fecha),
    CONSTRAINT FK_Fact_FechaEnvio FOREIGN KEY (SK_FechaEnvio) REFERENCES Dim_Fecha(SK_Fecha)
);
GO

-- 8. Poblar la Dimensión Fecha (Ajustado para abarcar los datos de 2016 en adelante)
DECLARE @FechaInicio DATE = '2015-01-01';
DECLARE @FechaFin DATE = '2025-12-31';

WHILE @FechaInicio <= @FechaFin
BEGIN
    INSERT INTO Dim_Fecha (SK_Fecha, Fecha, Anio, Semestre, Trimestre, Mes, NombreMes, Dia)
    VALUES (
        CAST(FORMAT(@FechaInicio, 'yyyyMMdd') AS INT),
        @FechaInicio,
        YEAR(@FechaInicio),
        CASE WHEN MONTH(@FechaInicio) <= 6 THEN 1 ELSE 2 END,
        DATEPART(QUARTER, @FechaInicio),
        MONTH(@FechaInicio),
        DATENAME(MONTH, @FechaInicio),
        DAY(@FechaInicio)
    );
    SET @FechaInicio = DATEADD(DAY, 1, @FechaInicio);
END;
GO