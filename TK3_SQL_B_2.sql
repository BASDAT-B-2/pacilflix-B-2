CREATE SCHEMA PACILFLIX;

SET search_path to PACILFLIX;

CREATE TABLE pengguna (
    username varchar(50) PRIMARY KEY,
    password varchar(50) NOT NULL,
    id_tayangan UUID
);
