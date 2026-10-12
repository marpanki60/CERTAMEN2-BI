USE [master];
GO

-- 1. Crear base de datos si no existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'KentFoods_DW')
BEGIN
    CREATE DATABASE [KentFoods_DW];
END
GO

USE [KentFoods_DW];
GO

-- 2. Crear Dimensiones
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID('dbo.Dim_Cliente', 'U') IS NULL
CREATE TABLE [dbo].[Dim_Cliente](
    [SK_Cliente] [int] IDENTITY(1,1) NOT NULL,
    [ClienteID] [nchar](5) NULL,
    [Empresa] [nvarchar](100) NULL,
    [Contacto] [nvarchar](100) NULL,
    [Cargo] [nvarchar](50) NULL,
    [Ciudad] [nvarchar](50) NULL,
    [Pais] [nvarchar](50) NULL,
    PRIMARY KEY CLUSTERED ([SK_Cliente] ASC)
);
GO

IF OBJECT_ID('dbo.Dim_Empleado', 'U') IS NULL
CREATE TABLE [dbo].[Dim_Empleado](
    [SK_Empleado] [int] IDENTITY(1,1) NOT NULL,
    [EmpleadoID] [int] NULL,
    [NombreCompleto] [nvarchar](100) NULL,
    [Cargo] [nvarchar](50) NULL,
    [Pais] [nvarchar](50) NULL,
    [Ciudad] [nvarchar](50) NULL,
    PRIMARY KEY CLUSTERED ([SK_Empleado] ASC)
);
GO

IF OBJECT_ID('dbo.Dim_Fecha', 'U') IS NULL
CREATE TABLE [dbo].[Dim_Fecha](
    [SK_Fecha] [int] NOT NULL,
    [Fecha] [date] NULL,
    [Anio] [int] NULL,
    [Semestre] [int] NULL,
    [Trimestre] [int] NULL,
    [Mes] [int] NULL,
    [NombreMes] [nvarchar](20) NULL,
    [Dia] [int] NULL,
    PRIMARY KEY CLUSTERED ([SK_Fecha] ASC)
);
GO

IF OBJECT_ID('dbo.Dim_Producto', 'U') IS NULL
CREATE TABLE [dbo].[Dim_Producto](
    [SK_Producto] [int] IDENTITY(1,1) NOT NULL,
    [ProductoID] [int] NULL,
    [NombreProducto] [nvarchar](100) NULL,
    [NombreCategoria] [nvarchar](50) NULL,
    [DescripcionCategoria] [nvarchar](200) NULL,
    [NombreProveedor] [nvarchar](100) NULL,
    [CiudadProveedor] [nvarchar](50) NULL,
    [PaisProveedor] [nvarchar](50) NULL,
    PRIMARY KEY CLUSTERED ([SK_Producto] ASC)
);
GO

IF OBJECT_ID('dbo.Dim_Transportista', 'U') IS NULL
CREATE TABLE [dbo].[Dim_Transportista](
    [SK_Transportista] [int] IDENTITY(1,1) NOT NULL,
    [TransportistaID] [int] NULL,
    [NombreTransportista] [nvarchar](100) NULL,
    PRIMARY KEY CLUSTERED ([SK_Transportista] ASC)
);
GO

-- 3. Crear Tabla de Hechos
IF OBJECT_ID('dbo.Fact_Ventas', 'U') IS NULL
CREATE TABLE [dbo].[Fact_Ventas](
    [SK_Producto] [int] NULL,
    [SK_Cliente] [int] NULL,
    [SK_Empleado] [int] NULL,
    [SK_Transportista] [int] NULL,
    [SK_FechaOrden] [int] NULL,
    [SK_FechaEnvio] [int] NULL,
    [Cantidad] [int] NULL,
    [PrecioUnitario] [decimal](18, 2) NULL,
    [Descuento] [decimal](18, 2) NULL,
    [MontoVenta] [decimal](18, 2) NULL,
    [MontoDescuento] [decimal](18, 2) NULL
);
GO

-- 4. Claves Foráneas (Foreign Keys)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_Fact_Cliente'))
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD CONSTRAINT [FK_Fact_Cliente] FOREIGN KEY([SK_Cliente])
REFERENCES [dbo].[Dim_Cliente] ([SK_Cliente]);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_Fact_Empleado'))
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD CONSTRAINT [FK_Fact_Empleado] FOREIGN KEY([SK_Empleado])
REFERENCES [dbo].[Dim_Empleado] ([SK_Empleado]);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_Fact_FechaEnvio'))
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD CONSTRAINT [FK_Fact_FechaEnvio] FOREIGN KEY([SK_FechaEnvio])
REFERENCES [dbo].[Dim_Fecha] ([SK_Fecha]);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_Fact_FechaOrden'))
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD CONSTRAINT [FK_Fact_FechaOrden] FOREIGN KEY([SK_FechaOrden])
REFERENCES [dbo].[Dim_Fecha] ([SK_Fecha]);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_Fact_Producto'))
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD CONSTRAINT [FK_Fact_Producto] FOREIGN KEY([SK_Producto])
REFERENCES [dbo].[Dim_Producto] ([SK_Producto]);
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_Fact_Transportista'))
ALTER TABLE [dbo].[Fact_Ventas] WITH CHECK ADD CONSTRAINT [FK_Fact_Transportista] FOREIGN KEY([SK_Transportista])
REFERENCES [dbo].[Dim_Transportista] ([SK_Transportista]);
GO
