-- Eliminar la base de datos si ya existe
DROP DATABASE IF EXISTS hotel_chain;

-- Crear la base de datos
CREATE DATABASE hotel_chain;

-- Seleccionar la base de datos
USE hotel_chain;


# TABLAS DE DIMENSIONES

/*
Tabla: dim_customers

Una fila representa un cliente único.

Decisiones:
- customer_id: clave primaria autoincremental.
- email: UNIQUE porque no debería haber dos clientes
  con el mismo correo.
*/

CREATE TABLE dim_customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    registration_date DATE NOT NULL
);



/*
Tabla: dim_hotels

Una fila representa un hotel.

Decisiones:
- stars: solo puede tomar valores entre 1 y 5.
*/

CREATE TABLE dim_hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    stars INT NOT NULL,
    CHECK (stars BETWEEN 1 AND 5)
);



/*
Tabla: dim_rooms

Una fila representa un tipo de habitación.

Decisiones:
- max_guests: no puede ser menor de 1.
- price_per_night: debe ser positivo.
*/

CREATE TABLE dim_rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_type VARCHAR(50) NOT NULL,
    max_guests INT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,

    CHECK (max_guests > 0),
    CHECK (price_per_night > 0)
);



/*
Tabla: dim_dates

Una fila representa un día del calendario.

Se utiliza para facilitar análisis temporales.
*/

CREATE TABLE dim_dates (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter INT NOT NULL,

    CHECK (month BETWEEN 1 AND 12),
    CHECK (quarter BETWEEN 1 AND 4)
);



/*
Tabla: dim_booking_channels

Una fila representa un canal de reserva.
*/

CREATE TABLE dim_booking_channels (
    channel_id INT AUTO_INCREMENT PRIMARY KEY,
    channel_name VARCHAR(50) NOT NULL UNIQUE
);



# TABLA DE HECHOS

/*
Tabla: fact_reservations

Una fila representa una reserva realizada por un cliente.

Relaciones:
- Un cliente puede tener muchas reservas.
- Un hotel puede tener muchas reservas.
- Un tipo de habitación puede aparecer en muchas reservas.
- Un canal puede generar muchas reservas.
- Una fecha puede tener muchas reservas.
*/

CREATE TABLE fact_reservations (

    reservation_id INT AUTO_INCREMENT PRIMARY KEY,

    customer_id INT NOT NULL,
    hotel_id INT NOT NULL,
    room_id INT NOT NULL,
    date_id INT NOT NULL,
    channel_id INT NOT NULL,

    nights INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'Completed',

    CHECK (nights > 0),
    CHECK (total_amount > 0),

    CHECK (
        status IN (
            'Completed',
            'Cancelled',
            'Pending'
        )
    ),

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES dim_customers(customer_id),

    CONSTRAINT fk_hotel
        FOREIGN KEY (hotel_id)
        REFERENCES dim_hotels(hotel_id),

    CONSTRAINT fk_room
        FOREIGN KEY (room_id)
        REFERENCES dim_rooms(room_id),

    CONSTRAINT fk_date
        FOREIGN KEY (date_id)
        REFERENCES dim_dates(date_id),

    CONSTRAINT fk_channel
        FOREIGN KEY (channel_id)
        REFERENCES dim_booking_channels(channel_id)
);

# ÍNDICES

/*
Este índice acelera las consultas por fecha,
que serán las más frecuentes en el análisis.
*/

CREATE INDEX idx_reservation_date
ON fact_reservations(date_id);


/*
Índice para acelerar consultas de ingresos por hotel.
*/

CREATE INDEX idx_reservation_hotel
ON fact_reservations(hotel_id);


/*
Índice para acelerar consultas por cliente.
*/

CREATE INDEX idx_reservation_customer
ON fact_reservations(customer_id);
