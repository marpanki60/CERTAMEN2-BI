# Proyecto BI - Caso Kent Foods: Data Warehouse

## Descripción del Proyecto (Fase 1)
Este proyecto consiste en crear una solución de Inteligencia de Negocios para la empresa Kent Foods. El objetivo es transformar los datos de ventas diarias en información ordenada para facilitar la toma de decisiones y el seguimiento de las metas comerciales.

Para cumplir con este objetivo, se definieron los siguientes Indicadores Clave de Desempeño (KPIs), los cuales fueron pre-calculados durante el proceso ETL para optimizar el rendimiento:
- Monto de Venta: Mide los ingresos reales generados por las ventas, permitiendo evaluar el rendimiento por cliente, empleado o transportista.
- Monto de Descuento: Controla la cantidad de dinero cedido en rebajas comerciales, ayudando a auditar el cumplimiento de metas de la fuerza de ventas.
- Volumen (Cantidad): Mide el flujo físico de inventario para evaluar la carga logística y la demanda real por producto.

## Arquitectura de la Solución
El proyecto abarca todo el proceso de los datos:
1. Origen de Datos: Base de datos original en SQL Server (KentFoods).
2. Proceso ETL: Extracción, limpieza y carga de datos usando SQL Server Integration Services (SSIS).
3. Data Warehouse: Base de datos analítica en SQL Server (KentFoods_DW).

## Modelo de Datos
El sistema está diseñado con un modelo de estrella puro (metodología Kimball) para hacer las consultas mucho más rápidas.
- Tabla central: Fact_Ventas. Diseñada con un nivel de granularidad atómico (una fila por cada línea de producto dentro de una orden). Guarda los cálculos: Cantidad, Precio Unitario, Descuento, Monto Venta, Monto Descuento.
- Tablas de contexto (Dimensiones): Dim_Cliente, Dim_Empleado, Dim_Producto, Dim_Transportista, Dim_Fecha.

Reglas de Negocio y Diseño Aplicadas:
- Consolidación de Dimensiones: Para evitar un esquema "copo de nieve" y mejorar el rendimiento, se aplanaron las jerarquías transaccionales (Categorías y Proveedores se integraron en Dim_Producto; Territorios y Regiones en Dim_Empleado).
- Inteligencia de Tiempo: Se omitió la dimensión Tiempo (horas/minutos) tras detectar que el origen registra las operaciones en 00:00:00.000.

## Requisitos Previos
- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Visual Studio con la extensión de Integration Services

## Instrucciones de Instalación Local
1. Restaurar el archivo KentFoods.bak en SSMS.
2. Ejecutar los scripts en una nueva base de datos llamada KentFoods_DW para crear las tablas vacías.
3. Ejecutar el script para llenar el calendario en Dim_Fecha.
4. Abrir el archivo .sln en Visual Studio y actualizar las conexiones para que apunten a tu servidor local.
5. Iniciar el proceso en SSIS para cargar todos los datos históricos.
