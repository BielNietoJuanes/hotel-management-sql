-- Análisis exploratorio de datos (EDA) y generación de insights de negocio.

USE hotel_chain;

-- CONSULTA 1
-- TOTAL DE RESERVAS
-- Conocer el volumen total de reservas registradas en la cadena hotelera.

SELECT
    COUNT(*) AS total_reservations
FROM fact_reservations;

-- CONSULTA 2
-- INGRESOS TOTALES
-- Facturación total generada por la cadena.

SELECT
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM fact_reservations;

-- CONSULTA 3
-- TICKET MEDIO
-- Importe promedio por reserva.

SELECT
    ROUND(AVG(total_amount), 2) AS average_booking_value
FROM fact_reservations;

-- CONSULTA 4
-- INGRESOS POR HOTEL
-- Identificar los hoteles más rentables.

SELECT
    h.hotel_name,
    h.city,

    ROUND(SUM(f.total_amount), 2) AS revenue

FROM fact_reservations f

INNER JOIN dim_hotels h
    ON f.hotel_id = h.hotel_id

GROUP BY
    h.hotel_name,
    h.city

ORDER BY revenue DESC;

-- CONSULTA 5
-- RANKING DE HOTELES
-- WINDOW FUNCTION
-- Ranking de hoteles según ingresos.

SELECT

    h.hotel_name,

    ROUND(SUM(f.total_amount), 2) AS revenue,

    RANK() OVER
    (
        ORDER BY SUM(f.total_amount) DESC
    ) AS hotel_rank

FROM fact_reservations f

INNER JOIN dim_hotels h
    ON f.hotel_id = h.hotel_id

GROUP BY h.hotel_name;

-- CONSULTA 6
-- TOP 10 CLIENTES
-- Clientes con mayor gasto acumulado.

SELECT

    c.customer_id,
    c.first_name,
    c.last_name,

    ROUND(SUM(f.total_amount), 2) AS total_spent

FROM fact_reservations f

INNER JOIN dim_customers c
    ON f.customer_id = c.customer_id

GROUP BY

    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY total_spent DESC

LIMIT 10;

-- CONSULTA 7
-- CLIENTES SIN RESERVAS
-- LEFT JOIN
-- Detectar clientes registrados que nunca han reservado.

SELECT

    c.customer_id,
    c.first_name,
    c.last_name,
    c.email

FROM dim_customers c

LEFT JOIN fact_reservations f
    ON c.customer_id = f.customer_id

WHERE f.customer_id IS NULL;

-- CONSULTA 8
-- HABITACIONES MÁS RESERVADAS
-- Conocer la demanda por tipo de habitación.

SELECT

    r.room_type,

    COUNT(*) AS total_bookings

FROM fact_reservations f

INNER JOIN dim_rooms r
    ON f.room_id = r.room_id

GROUP BY r.room_type

ORDER BY total_bookings DESC;

-- CONSULTA 9
-- INGRESO MEDIO POR HABITACIÓN
-- Identificar habitaciones con mayor valor.

SELECT

    r.room_type,

    ROUND(AVG(f.total_amount), 2) AS avg_revenue

FROM fact_reservations f

INNER JOIN dim_rooms r
    ON f.room_id = r.room_id

GROUP BY r.room_type

ORDER BY avg_revenue DESC;

-- CONSULTA 10
-- RESERVAS POR MES
-- Detectar estacionalidad.

SELECT

    d.month_name,

    COUNT(*) AS total_reservations

FROM fact_reservations f

INNER JOIN dim_dates d
    ON f.date_id = d.date_id

GROUP BY d.month_name

ORDER BY total_reservations DESC;

-- CONSULTA 11
-- INGRESOS POR TRIMESTRE
-- Comparar rendimiento trimestral.

SELECT

    d.quarter,

    ROUND(SUM(f.total_amount), 2) AS revenue

FROM fact_reservations f

INNER JOIN dim_dates d
    ON f.date_id = d.date_id

GROUP BY d.quarter

ORDER BY d.quarter;

-- CONSULTA 12
-- CANAL MÁS UTILIZADO
-- Conocer qué canal genera más reservas.

SELECT

    bc.channel_name,

    COUNT(*) AS total_bookings

FROM fact_reservations f

INNER JOIN dim_booking_channels bc
    ON f.channel_id = bc.channel_id

GROUP BY bc.channel_name

ORDER BY total_bookings DESC;

-- CONSULTA 13
-- SUBQUERY
-- Reservas superiores al importe medio.
SELECT *

FROM fact_reservations

WHERE total_amount >

(
    SELECT AVG(total_amount)
    FROM fact_reservations
);

-- CONSULTA 14
-- CASE
-- Segmentar reservas según valor.

SELECT

    reservation_id,

    total_amount,

    CASE

        WHEN total_amount < 300
            THEN 'Low Value'

        WHEN total_amount BETWEEN 300 AND 700
            THEN 'Medium Value'

        ELSE 'High Value'

    END AS booking_segment

FROM fact_reservations;

-- CONSULTA 15
-- CTE ENCADENADAS
-- Hoteles con ingresos superiores a la media global.

WITH hotel_revenue AS
(
    SELECT

        hotel_id,

        SUM(total_amount) AS revenue

    FROM fact_reservations

    GROUP BY hotel_id
),

average_revenue AS
(
    SELECT

        AVG(revenue) AS avg_revenue

    FROM hotel_revenue
)

SELECT *

FROM hotel_revenue

WHERE revenue >

(
    SELECT avg_revenue
    FROM average_revenue
);

-- CONSULTA 16
-- UTILIZACIÓN DE LA VIEW
-- Consulta de la vista creada en el esquema.

SELECT *
FROM vw_revenue_by_hotel
ORDER BY total_revenue DESC;

-- CONSULTA 17
-- UTILIZACIÓN DE LA FUNCTION
-- Promedio de reserva para un hotel específico.

SELECT
    fn_avg_booking(1) AS average_booking_hotel_1;
