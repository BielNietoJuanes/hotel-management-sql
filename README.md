# Hotel Management Analytics

## Objetivos

* Diseñar una base de datos relacional normalizada.
* Implementar claves primarias y foráneas para garantizar la integridad de los datos.
* Aplicar restricciones (constraints) para mejorar la calidad de la información almacenada.
* Realizar procesos básicos de limpieza y validación de datos.
* Crear vistas de negocio para facilitar el análisis.
* Desarrollar consultas SQL que permitan obtener métricas relevantes sobre el rendimiento de la cadena hotelera.


## Tecnologías utilizadas

* MySQL 8
* MySQL Workbench
* Git
* GitHub
* CSV y SQL para la carga inicial de datos


## Modelo de datos

El modelo sigue una estructura tipo estrella (Star Schema), compuesta por una tabla de hechos y varias tablas de dimensiones.

### Tabla de hechos

#### fact_reservations

Almacena cada reserva realizada por un cliente.

Granularidad: una fila representa una reserva individual.


### Tablas de dimensiones

#### dim_customers

Información de los clientes.

#### dim_hotels

Información de los hoteles de la cadena.

#### dim_rooms

Información de los distintos tipos de habitaciones.

#### dim_dates

Calendario utilizado para el análisis temporal.

#### dim_booking_channels

Canales mediante los cuales se realizan las reservas.


## Estructura del repositorio

```text
hotel-management-sql
│
├── data
│   ├── customers.csv
│   ├── hotels.csv
│   ├── rooms.csv
│   ├── dates.csv
│   ├── booking_channels.sql
│   └── reservations.csv
│
├── sql
│   ├── 01_schema.sql
│   ├── 02_data.sql
│   └── 03_eda.sql
│
├── docs
│   └── model.png
│
├── README.md
└── .gitignore
```


## Componentes del proyecto

### 01_schema.sql

Contiene:

* Creación de la base de datos.
* Creación de tablas.
* Definición de claves primarias.
* Definición de claves foráneas.
* Restricciones de integridad.
* Creación de índices.
* Creación de vistas.
* Creación de funciones.

### 02_data.sql

Incluye:

* Operaciones INSERT.
* Operaciones UPDATE.
* Operaciones DELETE.
* Conversión de tipos mediante CAST.
* Funciones de fecha.
* Transacciones con COMMIT y ROLLBACK.
* Validación de nulos.
* Detección de duplicados.
* Comprobación de valores fuera de rango.

### 03_eda.sql

Incluye consultas destinadas al análisis exploratorio y a la obtención de métricas de negocio.

Se utilizan:

* COUNT
* SUM
* AVG
* INNER JOIN
* LEFT JOIN
* CASE
* Subqueries
* CTEs
* Funciones ventana


## Vistas de negocio

### vw_revenue_by_hotel

Muestra los ingresos y reservas generados por cada hotel.

### vw_bookings_by_channel

Permite analizar el rendimiento de los distintos canales de reserva.


## Función SQL

### fn_avg_booking()

Calcula el importe medio de las reservas para un hotel determinado.

Ejemplo:

```sql
SELECT fn_avg_booking(1);
```


## Principales métricas analizadas

Durante el análisis se estudiaron, entre otras, las siguientes métricas:

* Número total de reservas.
* Facturación total de la cadena.
* Importe medio por reserva.
* Ingresos por hotel.
* Ranking de hoteles.
* Clientes con mayor gasto acumulado.
* Habitaciones más reservadas.
* Canal de reserva más utilizado.
* Estacionalidad de las reservas.
* Comparación de ingresos por trimestre.


## Ejemplos de insights obtenidos

### Hotel con mayor facturación

Permite identificar los establecimientos con mejor rendimiento económico.

### Canal de reserva dominante

Ayuda a conocer qué canal aporta más reservas y concentrar esfuerzos comerciales.

### Habitación más demandada

Facilita la planificación de precios y la gestión de la ocupación.

### Clientes con mayor gasto

Permite identificar perfiles de clientes de alto valor.

### Temporadas con mayor actividad

Ayuda a planificar recursos y estrategias comerciales según la demanda.


## Ejecución del proyecto

1. Ejecutar el archivo `01_schema.sql`.
2. Importar los archivos CSV y SQL en sus respectivas tablas.
3. Ejecutar `02_data.sql`.
4. Ejecutar `03_eda.sql`.
5. Revisar las vistas y consultas analíticas generadas.


## Autor

Biel Nieto Juanes

