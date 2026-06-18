USE hotel_chain;

-- 1. INSERT

/*
Inserta un nuevo canal de reservas corporativas.

Se utiliza NOT EXISTS para evitar errores si el script se ejecuta varias veces.
*/

INSERT INTO dim_booking_channels (channel_name)
SELECT 'Corporate'
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_booking_channels
    WHERE channel_name = 'Corporate'
);

-- 2. UPDATE

/*
Incremento del 5% en las reservas
del hotel con ID = 1.
*/

UPDATE fact_reservations
SET total_amount = total_amount * 1.05
WHERE hotel_id = 1;

-- 3. DELETE

/*
No elimina datos reales del proyecto.
La condición evita borrar registros.
*/

DELETE
FROM fact_reservations
WHERE reservation_id = -1;

-- 4. CAST

/*
Conversión de DECIMAL a INTEGER.
*/

SELECT
    reservation_id,
    total_amount,
    CAST(total_amount AS SIGNED) AS total_amount_integer
FROM fact_reservations
LIMIT 10;

-- 5. FUNCIONES DE FECHA

/*
Extracción de componentes de fecha.
*/

SELECT
    full_date,
    YEAR(full_date) AS reservation_year,
    MONTH(full_date) AS reservation_month,
    DAY(full_date) AS reservation_day
FROM dim_dates
LIMIT 20;

-- 6. TRANSACCIÓN CON COMMIT

/*
Actualización permanente.

Utilizamos room_id porque es PK
y evita errores con Safe Updates.
*/

START TRANSACTION;

UPDATE dim_rooms
SET price_per_night = price_per_night * 1.10
WHERE room_id = 9;

COMMIT;

-- 7. TRANSACCIÓN CON ROLLBACK

/*
Actualización temporal.

El cambio se revierte mediante ROLLBACK.
*/

START TRANSACTION;

UPDATE dim_rooms
SET price_per_night = 9999
WHERE room_id = 1;

ROLLBACK;

-- 8. DETECCIÓN DE NULOS

/*
Comprobación de emails nulos.
*/

SELECT *
FROM dim_customers
WHERE email IS NULL;

-- 9. CORRECCIÓN DE NULOS

/*
Corrección de emails nulos.
*/

UPDATE dim_customers
SET email = CONCAT('unknown_', customer_id, '@hotel.com')
WHERE email IS NULL;

-- 10. DETECCIÓN DE DUPLICADOS

/*
Búsqueda de correos repetidos.
*/

SELECT
    email,
    COUNT(*) AS repetitions
FROM dim_customers
GROUP BY email
HAVING COUNT(*) > 1;

-- 11. DUPLICADOS CON WINDOW FUNCTION

/*
Cumple requisito de Window Functions.
*/

WITH duplicate_check AS
(
    SELECT
        customer_id,
        email,

        RANK() OVER
        (
            PARTITION BY email
            ORDER BY customer_id
        ) AS duplicate_rank

    FROM dim_customers
)

SELECT *
FROM duplicate_check
WHERE duplicate_rank > 1;

-- 12. DETECCIÓN DE OUTLIERS

/*
Reservas con noches negativas
o igual a cero.
*/

SELECT *
FROM fact_reservations
WHERE nights <= 0;

-- 13. DETECCIÓN DE IMPORTES INVÁLIDOS

/*
Reservas con importe incorrecto.
*/

SELECT *
FROM fact_reservations
WHERE total_amount <= 0;

-- 14. VALIDACIÓN DE ESTADOS

/*
Comprobación de estados válidos.
*/

SELECT *
FROM fact_reservations
WHERE status NOT IN
(
    'Completed',
    'Pending',
    'Cancelled'
);

-- 15. VERIFICACIÓN DE FK

/*
Detectar reservas huérfanas.
*/

SELECT *
FROM fact_reservations f
LEFT JOIN dim_customers c
    ON f.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- 16. COMPROBACIONES FINALES

/*
Resumen de registros cargados.
*/

SELECT COUNT(*) AS total_customers
FROM dim_customers;

SELECT COUNT(*) AS total_hotels
FROM dim_hotels;

SELECT COUNT(*) AS total_rooms
FROM dim_rooms;

SELECT COUNT(*) AS total_dates
FROM dim_dates;

SELECT COUNT(*) AS total_channels
FROM dim_booking_channels;

SELECT COUNT(*) AS total_reservations
FROM fact_reservations;
