USE Ventas_Tech_DB


-- Consulta 1: Resumen ejecutivo mensual

SELECT 
    MONTH(fecha_venta) AS mes,
    COUNT(ID_VENTA) as cantidad_pedidos,
    SUM(cantidad * precio_unitario) as Total_facturado, 
    AVG(cantidad * precio_unitario) as ticket_promedio
FROM Ventas
GROUP BY  month(fecha_venta)

-- Consulta 2: Ranking Top 5 de productos por total facturado

SELECT TOP 5 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM Ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- Consulta 3: Clientes recurrentes (más de 1 pedido)

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM Ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

-- Consulta 4: Meses por encima/por debajo del promedio general

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    CASE 
        WHEN SUM(cantidad * precio_unitario) > 1000 THEN 'Por encima'
        ELSE 'Por debajo'
    END AS relacion_promedio
FROM Ventas
GROUP BY MONTH(fecha_venta);


/*
-- HALLAZGOS:
1. El mes 3 registra la mayor cantidad de ventas y facturación total.
2. Un grupo reducido de productos genera la mayor parte de los ingresos.
3. Se identificaron clientes recurrentes con más de una compra realizada.
*/