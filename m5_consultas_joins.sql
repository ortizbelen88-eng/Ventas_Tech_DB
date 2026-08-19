
-- ── CONSULTA 1: Vista base del proyecto (INNER JOIN) ─────────────
-- Combina ventas, clientes, productos y territorios.
-- Esta consulta alimenta el dashboard principal de Power BI.

SELECT 
    v.fecha_venta,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM DBO.Ventas v
INNER JOIN Dbo.Clientes C     
    ON c.id_cliente = v.id_cliente
INNER JOIN dbo.Productos p    
    ON p.id_producto = v.id_producto
INNER JOIN DBO.Categorias cat 
    ON p.id_categoria = cat.id_categoria;

--Consulta 2 — Clientes sin ventas (LEFT JOIN) Identificá clientes registrados que aún no han realizado ninguna compra. 
--Mostrá su nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.

SELECT
c.nombre,
c.email,
c.fecha_regisrtro
FROM dbo.Clientes C
LEFT JOIN dbo.Ventas V
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--Consulta 3 — Productos sin ventas (LEFT JOIN) Identificá productos del catálogo que no tienen ninguna venta registrada. 
--Mostrá nombre del producto, categoría y precio. Usá WHERE ... IS NULL.--

SELECT 
p.nombre_producto,
cat.nombre_categoria AS categoria,
p.precio
FROM dbo.Productos p
JOIN dbo.Categorias cat 
    ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.Ventas v        
    ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

--Consulta 4 — Consolidado por canal (UNION ALL) 
--Usá UNION ALL para combinar en un solo resultado las ventas Online y Presencial, 
--agregando una columna canal que identifique el origen de cada fila. Al final calculá el total por canal con un GROUP BY.

SELECT 
    canal,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM 
(
    SELECT 'Online' AS canal, cantidad, precio_unitario
    FROM dbo.Ventas
    WHERE id_venta <= 3

    UNION ALL

    SELECT 'Presencial' AS canal, cantidad, precio_unitario
    FROM dbo.Ventas
    WHERE id_venta > 3
) AS tabla_consolidada
GROUP BY canal;