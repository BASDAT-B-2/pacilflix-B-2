CREATE SCHEMA PACILFLIX;

SET DATESTYLE TO ISO;
SET search_path to PACILFLIX;

CREATE TABLE pengguna (
    username varchar(50),
    password varchar(50) NOT NULL,
    id_tayangan UUID
);

CREATE TABLE paket (
    nama varchar(50),
    harga int NOT NULL CHECK (harga >= 0),
    resolusi_layar varchar(50) NOT NULL
);

CREATE TABLE dukungan_perangkat (
    nama_paket varchar(50),
    dukungan_perangkat varchar(50)
);

CREATE TABLE transaction (
    username varchar(50),
    start_date_time date,
    end_date_time date,
    nama_paket varchar(50),
    metode_pembayaran varchar(50) NOT NULL,
    timestamp_pembayaran timestamp NOT NULL
);

CREATE TABLE contributors (
    id UUID,
    nama varchar(50) NOT NULL,
    jenis_kelamin int NOT NULL,
    kewarganegaraan varchar(50) NOT NULL
);

CREATE TABLE penulis_skenario (
    id UUID
);

CREATE TABLE pemain (
    id UUID
);

CREATE TABLE sutradara (
    id UUID
);

CREATE TABLE tayangan (
    id UUID,
    judul varchar(100) NOT NULL,
    sinopsis varchar(255) NOT NULL,
    asal_negara varchar(50) NOT NULL,
    sinopsis_trailer varchar(255) NOT NULL,
    url_video_trailer varchar(255) NOT NULL,
    release_date_trailer date NOT NULL,
    id_sutradara UUID
);

CREATE TABLE memainkan_tayangan (
    id_tayangan UUID,
    id_pemain UUID
);

CREATE TABLE menulis_skenario_tayangan (
    id_tayangan UUID,
    id_penulis_skenario UUID
);

CREATE TABLE genre_tayangan (
    id_tayangan UUID,
    genre varchar(50)
);

CREATE TABLE perusahaan_produksi (
    nama varchar(100)
);

CREATE TABLE persetujuan (
    nama varchar(100),
    id_tayangan UUID,
    tanggal_persetujuan date,
    durasi int NOT NULL CHECK (durasi >= 0),
    biaya int NOT NULL CHECK (biaya >= 0),
    tanggal_mulai_penayangan date NOT NULL

);

CREATE TABLE series (
    id_tayangan UUID
);

CREATE TABLE film (
    id_tayangan UUID,
    url_video_film varchar(255) NOT NULL,
    release_date_film date NOT NULL,
    durasi_film int NOT NULL DEFAULT 0
);

CREATE TABLE episode (
    id_series UUID,
    sub_judul varchar(100),
    sinopsis varchar(255) NOT NULL,
    durasi int NOT NULL,
    url_video varchar(255) NOT NULL,
    release_date date NOT NULL
);

CREATE TABLE ulasan (
    id_tayangan UUID,
    username varchar(50),
    timestamp timestamp,
    rating int NOT NULL DEFAULT 0,
    deskripsi varchar(255)
);

CREATE TABLE tayangan_memiliki_daftar_favorit (
    id_tayangan UUID,
    timestamp timestamp,
    username varchar(50)
);

CREATE TABLE daftar_favorit (
    timestamp timestamp,
    username varchar(50),
    judul varchar(50) NOT NULL
);

CREATE TABLE riwayat_nonton (
    id_tayangan UUID,
    username varchar(50),
    start_date_time timestamp,
    end_date_time timestamp NOT NULL
);

CREATE TABLE tayangan_terunduh (
    id_tayangan UUID,
    username varchar(50),
    timestamp timestamp
);

ALTER TABLE pengguna
ADD PRIMARY KEY (username);
ADD CONSTRAINT pengguna_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE paket
ADD PRIMARY KEY (nama) ;

ALTER TABLE dukungan_perangkat
ADD PRIMARY KEY (nama_paket, dukungan_perangkat);
ADD CONSTRAINT dukungan_perangkat_ibfk_1 FOREIGN KEY (nama_paket) REFERENCES paket (nama) ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE transaction
ADD PRIMARY KEY (username, start_date_time),
ADD CONSTRAINT transaction_ibfk_1 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT transaction_ibfk_2 FOREIGN KEY (nama_paket) REFERENCES paket (nama) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE penulis_skenario
ADD PRIMARY KEY (id),
ADD CONSTRAINT penulis_skenario_ibfk_1 FOREIGN KEY (id) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pemain
ADD PRIMARY KEY (id),
ADD CONSTRAINT pemain_ibfk_1 FOREIGN KEY (id) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE sutradara
ADD PRIMARY KEY (id),
ADD CONSTRAINT sutradara_ibfk_1 FOREIGN KEY (id) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tayangan
ADD PRIMARY KEY (id),
ADD CONSTRAINT tayangan_ibfk_1 FOREIGN KEY (id_sutradara) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE memainkan_tayangan
ADD PRIMARY KEY (id_tayangan, id_pemain),
ADD CONSTRAINT memainkan_tayangan_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE menulis_skenario_tayangan
ADD PRIMARY KEY (id_tayangan, id_penulis_skenario),
ADD CONSTRAINT penulis_skenario_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT penulis_skenario_ibfk_2 FOREIGN KEY (id_penulis_skenario) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE genre_tayangan
ADD PRIMARY KEY (id_tayangan, genre),
ADD CONSTRAINT genre_tayangan_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE perusahaan_produksi
ADD PRIMARY KEY (nama);

ALTER TABLE persetujuan
ADD PRIMARY KEY (nama, id_tayangan, tanggal_persetujuan),
ADD CONSTRAINT persetujuan_ibfk_1 FOREIGN KEY (nama) REFERENCES perusahaan_produksi (nama) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT persetujuan_ibfk_2 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE series
ADD PRIMARY KEY (id_tayangan),
ADD CONSTRAINT series_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE film
ADD PRIMARY KEY (id_tayangan),
ADD CONSTRAINT film_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE episode
ADD PRIMARY KEY (id_series, sub_judul),
ADD CONSTRAINT episode_ibfk_1 FOREIGN KEY (id_series) REFERENCES series (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ulasan
ADD PRIMARY KEY (username, timestamp),
ADD CONSTRAINT ulasan_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT ulasan_ibfk_2 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tayangan_memiliki_daftar_favorit
ADD PRIMARY KEY (id_tayangan, timestamp, username),
ADD CONSTRAINT tayangan_memiliki_daftar_favorit_ibfk_1 FOREIGN KEY (timestamp) REFERENCES daftar_favorit (timestamp) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT tayangan_memiliki_daftar_favorit_ibfk_2 FOREIGN KEY (username) REFERENCES daftar_favorit (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE daftar_favorit
ADD PRIMARY KEY (timestamp, username),
ADD CONSTRAINT daftar_favorit_ibfk_1 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE riwayat_nonton
ADD PRIMARY KEY (username, start_date_time),
ADD CONSTRAINT riwayat_nonton_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT riwayat_nonton_ibfk_2 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tayangan_terunduh
ADD PRIMARY KEY (id_tayangan, username, timestamp),
ADD CONSTRAINT tayangan_terunduh_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT tayangan_terunduh_ibfk_2 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO pengguna VALUES ('coolcat123','pass123','72d21279-3823-4f33-a64d-d63a5b0bfb11'),
	('skywalker87','skywalker87pass','52ab837e-ff35-4932-80b0-d00198ba2543'),
	('rainbowunicorn','unicorn567','7f011a9f-1d3f-4ef9-8a8e-72d1e443d194'),
	('gamer_guru','gamingrocks','72d21279-3823-4f33-a64d-d63a5b0bfb11'),
	('adventureseeker','exploredora','72d21279-3823-4f33-a64d-d63a5b0bfb11'),
	('musiclover3','melody8','52ab837e-ff35-4932-80b0-d00198ba2543'),
	('techwizard101','code09','7f011a9f-1d3f-4ef9-8a8e-72d1e443d194'),
	('bookworm99','readingisfun','72d21279-3823-4f33-a64d-d63a5b0bfb11');

INSERT INTO paket VALUES ('gold',35,'4k'),
	('silver',15,'1080'),
	('bronze',7,'720');

INSERT INTO dukungan_perangkat VALUES ('gold','tv'),
	('silver','smartphone'),
	('bronze','ipad'),
	('gold','smartphone'),
	('gold','ipad'),
	('gold','laptop'),
	('silver','ipad'),
	('bronze','smartphone');

INSERT INTO transaction VALUES ('coolcat123','2024-04-01 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-02 08:15:23'),
	('skywalker87','2024-04-05 00:00:00','2024-04-25 00:00:00','silver','PayPal','2024-04-06 12:30:45'),
	('rainbowunicorn','2024-04-10 00:00:00','2024-04-30 00:00:00','bronze','bank transfer','2024-04-11 14:20:37'),
	('gamer_guru','2024-04-03 00:00:00','2024-04-28 00:00:00','gold','credit card','2024-04-04 09:45:12'),
	('adventureseeker','2024-04-15 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-16 16:55:29'),
	('musiclover3','2024-04-07 00:00:00','2024-04-30 00:00:00','bronze','bank transfer','2024-04-08 10:10:18'),
	('techwizard101','2024-04-02 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-03 11:25:34'),
	('bookworm99','2024-04-20 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-21 13:40:56'),
	('coolcat123','2024-04-10 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-11 08:15:23'),
	('skywalker87','2024-04-02 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-03 12:30:45'),
	('rainbowunicorn','2024-04-12 00:00:00','2024-04-30 00:00:00','bronze','bank transfer','2024-04-13 14:20:37'),
	('gamer_guru','2024-04-08 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-09 09:45:12'),
	('adventureseeker','2024-04-18 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-19 16:55:29'),
	('musiclover3','2024-04-05 00:00:00','2024-04-30 00:00:00','bronze','bank transfer','2024-04-06 10:10:18'),
	('techwizard101','2024-04-13 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-14 11:25:34'),
	('bookworm99','2024-04-25 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-26 13:40:56'),
	('coolcat123','2024-04-15 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-16 08:15:23'),
	('skywalker87','2024-04-04 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-05 12:30:45'),
	('rainbowunicorn','2024-04-14 00:00:00','2024-04-30 00:00:00','bronze','bank transfer','2024-04-15 14:20:37'),
	('gamer_guru','2024-04-06 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-07 09:45:12'),
	('adventureseeker','2024-04-21 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-22 16:55:29'),
	('musiclover3','2024-04-09 00:00:00','2024-04-30 00:00:00','bronze','bank transfer','2024-04-10 10:10:18'),
	('techwizard101','2024-04-17 00:00:00','2024-04-30 00:00:00','gold','credit card','2024-04-18 11:25:34'),
	('bookworm99','2024-04-22 00:00:00','2024-04-30 00:00:00','silver','PayPal','2024-04-23 13:40:56');

INSERT INTO contributors VALUES ('1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45','John Doe',0,'United States'),
	('7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e','Jane Smith',1,'Canada'),
	('6d78a51e-3f6f-4cf2-b1af-19d12a60d0d6','Michael Johnson',0,'Australia'),
	('92d34712-2a21-4ab2-aeef-faad164c51f0','Emily Brown',1,'United Kingdom'),
	('c76eddd2-559b-4b3c-b129-3e394198a4cc','David Lee',0,'Japan'),
	('f85bb23a-b4c8-4ccf-a3dc-4a8207518b46','Sarah Kim',1,'South Korea'),
	('1a76ff8e-6866-4745-8727-d60f6fc1f8d0','Christopher Wang',0,'China'),
	('a92c9a89-6c8b-4155-a2d5-bf6d8b87654c','Amanda Nguyen',1,'Vietnam'),
	('f5a054df-5a7e-4d38-a7db-94882f022b4a','Matthew Garcia',0,'Mexico'),
	('e7f4f12c-249b-4cd4-bb7c-5ae8245a99a0','Jessica Martinez',1,'Spain'),
	('3fd5ef2c-b6ab-474d-9868-52518b7a008e','Daniel Rodriguez',0,'Argentina'),
	('8b3e7ae2-ba69-4f36-9ad0-4f4b25574921','Ashley Perez',1,'Brazil'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','William Hernandez',0,'Colombia'),
	('9fc0c3d3-72d6-4e82-b454-36ee83f9e0f0','Samantha Lopez',1,'Chile'),
	('b84c5000-1c6b-4c61-9518-3428f3ec3c43','Joseph Flores',0,'Peru'),
	('e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445','Olivia Gonzalez',1,'France'),
	('4a92d2cb-5a0d-4291-9a68-f32a6d36c1cc','Ethan Ramirez',0,'Italy'),
	('2e1a31c1-b5c7-42e7-b3e8-d4d4a5d97c15','Isabella Torres',1,'Germany'),
	('5d9bbd4b-9380-4b0d-8758-48b0a47d9a38','Andrew Russell',0,'Russia'),
	('36c4b9e7-bb13-4752-a684-9e49d9f190dc','Mia Collins',1,'Netherlands'),
	('8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1','James Cooper',0,'Switzerland'),
	('7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef','Sophia Hughes',1,'Sweden'),
	('a89b79cb-2ef7-4720-903f-2d40902df5a2','Benjamin Stewart',0,'Norway'),
	('3d650f12-f305-4bfb-af16-498c8968d962','Lily Murphy',1,'Denmark'),
	('6e3db063-202e-43b2-8a8f-ced5d2498e29','Mason Morgan',0,'Finland'),
	('4e31539a-5a1d-4484-a2d6-f5fb1ec4a59a','Grace Scott',1,'Portugal'),
	('0a2f7918-5027-4c56-903e-9a02a6a39bfa','Lucas Peterson',0,'India'),
	('1a3a22f7-178e-4f6e-9185-6e1c14710510','Chloe Foster',1,'New Zealand'),
	('b2bdf9c5-8a6d-47f0-9d68-b31d2d31eabf','Alexander Kelly',0,'Ireland'),
	('f7d3e7e8-1ac3-40e1-93e2-61e7ec6c369c','Emma Bryant',1,'Greece'),
	('896b631b-fac9-4a82-a2f8-22cf95126a60','Noah Woods',0,'South Africa'),
	('e4ab6ad3-5074-432d-a16d-0467ee1f512f','Mia Ward',1,'Turkey'),
	('92b0e861-bd9d-4993-b3e1-74e1f5ee73e9','Jacob Cox',0,'Egypt'),
	('e68838cf-8c3c-4b6e-b06a-8d0b0c9ff1da','Ava Griffin',1,'United Arab Emirates'),
	('5f91b631-0c0a-49f8-8cf1-447174ed0cb4','William Powell',0,'Singapore'),
	('d05ec2fb-3983-48a0-bb0e-5b301e19c16c','Harper Hayes',1,'Malaysia'),
	('19e8bbdc-8c18-4967-93da-dbea1d8313e1','Ethan King',0,'Thailand'),
	('1df2a180-3bbf-4ba9-b75b-c4ef7640e36d','Zoe Bailey',1,'Philippines'),
	('6dc3f0f3-8ee6-4735-a0ed-46b4ac781e7b','Mason Wright',0,'Indonesia'),
	('4ff497f3-9cf4-4f36-96b0-b8b6b183011e','Lily Brooks',1,'Pakistan'),
	('5e297b4d-e76a-49aa-bd38-11b4212587f9','Logan Reed',0,'Bangladesh'),
	('2a3128f1-1275-4e69-8c3b-21c21cfed84c','Zoey Cox',1,'Saudi Arabia'),
	('a52fdaf7-5c85-4ec5-a4ee-9a0308d36d3a','Liam Nelson',0,'Nigeria'),
	('6d16d487-6d6b-4b5c-89df-cab9bbfc7093','Leah Price',1,'Iran'),
	('0e5b5aa7-9320-44f3-a016-1ad614a8c5e8','Jackson Murphy',0,'Vietnam'),
	('2d0c0b8b-fb38-4c9b-a0c6-7a59f74f05fd','Abigail Rivera',1,'Thailand'),
	('78673a8b-e91b-49b6-89d1-d2f3d0a2b3ab','Ethan Ramirez',0,'Philippines'),
	('93564b36-5d70-4933-8107-d637c7c7321e','Mia Ward',1,'Pakistan'),
	('a2dbb8d4-1f62-4577-ba92-3c4242f4bea4','Jacob Cox',0,'Saudi Arabia'),
	('2f9eb9d0-1e10-453e-bf09-7ec5cbb10092','Ava Griffin',1,'Nigeria'),
	('3cfec7d0-024e-4a2f-b990-1abfe3c22e56','William Powell',0,'Iran'),
	('45f48c92-fde8-4e62-9e6f-37060db1f24b','Harper Hayes',1,'Vietnam'),
	('8652b3de-7ef0-4967-a9c7-d525e61e1943','Ethan King',0,'Thailand'),
	('a9a441e6-14bc-4fc9-ba0e-fb6d3b6cbefb','Zoe Bailey',1,'Philippines'),
	('b2a4eddb-45f0-48b5-a731-13e58c949e10','Mason Wright',0,'Pakistan'),
	('7f6d22f2-7a44-4b79-b17d-1b54e89a31d5','Lily Brooks',1,'Saudi Arabia'),
	('89f646de-1866-414d-82f3-2b0d98a06f02','Logan Reed',0,'Nigeria'),
	('2bd504f7-1f1b-4f13-bf71-2450e2883cf5','Zoey Cox',1,'Iran'),
	('7d65f1b9-4990-4c21-96ff-986301d19f96','Liam Nelson',0,'Vietnam'),
	('2d2093ef-3d85-4433-a3ac-f141a3b10280','Leah Price',1,'Thailand'),
	('0c3ed079-e5e1-4a21-8b24-57f2febb5c86','Jackson Murphy',0,'Philippines'),
	('9c4df0f0-897e-49c1-b80d-e675cda89e3e','Abigail Rivera',1,'Saudi Arabia'),
	('49a95d3b-346f-4e88-a9d4-9ae7d60fc15a','Ethan Ramirez',0,'Nigeria'),
	('0ee49509-6e95-49b3-b715-972868937c3f','Mia Ward',1,'Iran'),
	('7e4a4682-5e82-4d52-a75f-9ec00bf83f1c','Jacob Cox',0,'Vietnam'),
	('8fde8371-c9e7-4d25-8194-4da791b7d51d','Ava Griffin',1,'Thailand'),
	('3f078684-b76c-45f6-9f49-23f2ff82b8bb','William Powell',0,'Philippines');

INSERT INTO penulis_skenario VALUES ('1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('60b9e2aa-1467-44db-b5de-451d654355e0'),
	('e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445'),
	('3fd5ef2c-b6ab-474d-9868-52518b7a008e'),
	('5d9bbd4b-9380-4b0d-8758-48b0a47d9a38'),
	('7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('5e297b4d-e76a-49aa-bd38-11b4212587f9'),
	('0ee49509-6e95-49b3-b715-972868937c3f'),
	('a89b79cb-2ef7-4720-903f-2d40902df5a2'),
	('3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('2e1a31c1-b5c7-42e7-b3e8-d4d4a5d97c15'),
	('1a3a22f7-178e-4f6e-9185-6e1c14710510'),
	('7e4a4682-5e82-4d52-a75f-9ec00bf83f1c'),
	('1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('a9a441e6-14bc-4fc9-ba0e-fb6d3b6cbefb'),
	('4e31539a-5a1d-4484-a2d6-f5fb1ec4a59a'),
	('8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('f7d3e7e8-1ac3-40e1-93e2-61e7ec6c369c'),
	('e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('3cfec7d0-024e-4a2f-b990-1abfe3c22e56'),
	('2f9eb9d0-1e10-453e-bf09-7ec5cbb10092'),
	('8fde8371-c9e7-4d25-8194-4da791b7d51d'),
	('93564b36-5d70-4933-8107-d637c7c7321e'),
	('49a95d3b-346f-4e88-a9d4-9ae7d60fc15a'),
	('2a3128f1-1275-4e69-8c3b-21c21cfed84c'),
	('78673a8b-e91b-49b6-89d1-d2f3d0a2b3ab'),
	('92b0e861-bd9d-4993-b3e1-74e1f5ee73e9'),
	('1a76ff8e-6866-4745-8727-d60f6fc1f8d0'),
	('5f91b631-0c0a-49f8-8cf1-447174ed0cb4');

INSERT INTO pemain VALUES ('8fde8371-c9e7-4d25-8194-4da791b7d51d'),
	('e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445'),
	('4e31539a-5a1d-4484-a2d6-f5fb1ec4a59a'),
	('5f91b631-0c0a-49f8-8cf1-447174ed0cb4'),
	('1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('0ee49509-6e95-49b3-b715-972868937c3f'),
	('3fd5ef2c-b6ab-474d-9868-52518b7a008e'),
	('5d9bbd4b-9380-4b0d-8758-48b0a47d9a38'),
	('78673a8b-e91b-49b6-89d1-d2f3d0a2b3ab'),
	('60b9e2aa-1467-44db-b5de-451d654355e0'),
	('a9a441e6-14bc-4fc9-ba0e-fb6d3b6cbefb'),
	('49a95d3b-346f-4e88-a9d4-9ae7d60fc15a'),
	('3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('2a3128f1-1275-4e69-8c3b-21c21cfed84c'),
	('1a3a22f7-178e-4f6e-9185-6e1c14710510'),
	('7e4a4682-5e82-4d52-a75f-9ec00bf83f1c'),
	('e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('93564b36-5d70-4933-8107-d637c7c7321e'),
	('5e297b4d-e76a-49aa-bd38-11b4212587f9'),
	('4ff497f3-9cf4-4f36-96b0-b8b6b183011e'),
	('2bd504f7-1f1b-4f13-bf71-2450e2883cf5'),
	('a89b79cb-2ef7-4720-903f-2d40902df5a2'),
	('2e1a31c1-b5c7-42e7-b3e8-d4d4a5d97c15'),
	('2f9eb9d0-1e10-453e-bf09-7ec5cbb10092'),
	('1a76ff8e-6866-4745-8727-d60f6fc1f8d0'),
	('0a2f7918-5027-4c56-903e-9a02a6a39bfa'),
	('2d2093ef-3d85-4433-a3ac-f141a3b10280'),
	('7d65f1b9-4990-4c21-96ff-986301d19f96'),
	('a2dbb8d4-1f62-4577-ba92-3c4242f4bea4'),
	('1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('b84c5000-1c6b-4c61-9518-3428f3ec3c43'),
	('6d78a51e-3f6f-4cf2-b1af-19d12a60d0d6'),
	('7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('3cfec7d0-024e-4a2f-b990-1abfe3c22e56'),
	('6e3db063-202e-43b2-8a8f-ced5d2498e29'),
	('2d0c0b8b-fb38-4c9b-a0c6-7a59f74f05fd'),
	('92b0e861-bd9d-4993-b3e1-74e1f5ee73e9'),
	('2a76ff8e-6866-4745-8727-d60f6fc1f8d0');

INSERT INTO sutradara VALUES ('92b0e861-bd9d-4993-b3e1-74e1f5ee73e9'),
	('2a3128f1-1275-4e69-8c3b-21c21cfed84c'),
	('1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('60b9e2aa-1467-44db-b5de-451d654355e0'),
	('7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('5d9bbd4b-9380-4b0d-8758-48b0a47d9a38');

INSERT INTO tayangan VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','The Hidden Village','A village hides a mystical secret from outsiders.','Japan','Discover the ancient village in the mountains.','https://example.com/trailer1.mp4','2024-05-01 00:00:00','92b0e861-bd9d-4993-b3e1-74e1f5ee73e9'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','Midnight Mysteries','Strange occurrences plague a small town at midnight.','United States','Unravel the mysteries under the cover of darkness.','https://example.com/trailer2.mp4','2024-06-15 00:00:00','2a3128f1-1275-4e69-8c3b-21c21cfed84c'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','Echoes of Eternity','A tale of love and loss that spans across centuries.','Italy','Feel the echoes of love through time.','https://example.com/trailer3.mp4','2024-07-20 00:00:00','1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','Shadows of the Past','Ghosts from the past haunt the present.','England','Confront the shadows that linger in the past.','https://example.com/trailer4.mp4','2024-08-10 00:00:00','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','Beyond the Horizon','Explorers venture into the unknown, seeking treasure.','Australia','Embark on an adventure beyond the horizon.','https://example.com/trailer5.mp4','2024-09-05 00:00:00','3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','Whispers in the Dark','Secrets whispered in the darkness hold deadly truths.','Canada','Listen closely to the whispers in the night.','https://example.com/trailer6.mp4','2024-10-12 00:00:00','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('67b9a84e-75e1-462e-93c3-3ff11095b897','Forgotten Realms','Lost worlds resurface, revealing ancient secrets.','Greece','Uncover the forgotten realms of ancient civilizations.','https://example.com/trailer7.mp4','2024-11-18 00:00:00','60b9e2aa-1467-44db-b5de-451d654355e0'),
	('5e567f84-6bcf-41d2-89c8-8d24b3b7f95e','Lost in Translation','Language barriers lead to comedic misunderstandings.','France','Get lost in translation with this hilarious comedy.','https://example.com/trailer8.mp4','2025-01-07 00:00:00','7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','Into the Abyss','Brave souls venture into the depths of the unknown.','Iceland','Dive into the abyss and face your fears.','https://example.com/trailer9.mp4','2025-02-15 00:00:00','e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('60b9e2aa-1467-44db-b5de-451d654355e1','The Enigma','Mysteries unravel as ancient codes are deciphered.','Egypt','Crack the enigma and unlock ancient secrets.','https://example.com/trailer10.mp4','2025-03-20 00:00:00','5d9bbd4b-9380-4b0d-8758-48b0a47d9a38'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','Haunting Memories','Memories from the past return to haunt the present.','Scotland','Face your haunting memories in this psychological thriller.','https://example.com/trailer11.mp4','2025-04-25 00:00:00','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c92','Bound by Fate','Two souls bound by fate struggle against destiny.','Ireland','Can love conquer the forces of fate?','https://example.com/trailer12.mp4','2025-05-30 00:00:00','60b9e2aa-1467-44db-b5de-451d654355e0'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8','Edge of Tomorrow','Time loops and alternate realities collide in this sci-fi.','United States','Break the cycle and change the course of history.','https://example.com/trailer13.mp4','2025-06-10 00:00:00','e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','Phantom Shadows','Shadows lurk in the darkness, hiding secrets untold.','Japan','Face your deepest fears in this chilling horror.','https://example.com/trailer14.mp4','2025-07-15 00:00:00','5d9bbd4b-9380-4b0d-8758-48b0a47d9a38'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','Echoes of the Past','Echoes of the past reverberate through time and space.','Italy','Relive the echoes of history in this epic adventure.','https://example.com/trailer15.mp4','2025-08-20 00:00:00','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1');

INSERT INTO memainkan_tayangan VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','8fde8371-c9e7-4d25-8194-4da791b7d51d'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','4e31539a-5a1d-4484-a2d6-f5fb1ec4a59a'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','5f91b631-0c0a-49f8-8cf1-447174ed0cb4'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('67b9a84e-75e1-462e-93c3-3ff11095b897','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('5e567f84-6bcf-41d2-89c8-8d24b3b7f95e','0ee49509-6e95-49b3-b715-972868937c3f'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','3fd5ef2c-b6ab-474d-9868-52518b7a008e'),
	('60b9e2aa-1467-44db-b5de-451d654355e1','5d9bbd4b-9380-4b0d-8758-48b0a47d9a38'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','78673a8b-e91b-49b6-89d1-d2f3d0a2b3ab'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c92','60b9e2aa-1467-44db-b5de-451d654355e0'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8','a9a441e6-14bc-4fc9-ba0e-fb6d3b6cbefb'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','49a95d3b-346f-4e88-a9d4-9ae7d60fc15a'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','2a3128f1-1275-4e69-8c3b-21c21cfed84c'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','1a3a22f7-178e-4f6e-9185-6e1c14710510'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','7e4a4682-5e82-4d52-a75f-9ec00bf83f1c'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','93564b36-5d70-4933-8107-d637c7c7321e'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','5e297b4d-e76a-49aa-bd38-11b4212587f9'),
	('67b9a84e-75e1-462e-93c3-3ff11095b897','4ff497f3-9cf4-4f36-96b0-b8b6b183011e'),
	('5e567f84-6bcf-41d2-89c8-8d24b3b7f95e','2bd504f7-1f1b-4f13-bf71-2450e2883cf5'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','a89b79cb-2ef7-4720-903f-2d40902df5a2'),
	('60b9e2aa-1467-44db-b5de-451d654355e1','2e1a31c1-b5c7-42e7-b3e8-d4d4a5d97c15'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','2f9eb9d0-1e10-453e-bf09-7ec5cbb10092'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c92','1a76ff8e-6866-4745-8727-d60f6fc1f8d0'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8','0a2f7918-5027-4c56-903e-9a02a6a39bfa'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','2d2093ef-3d85-4433-a3ac-f141a3b10280'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','7d65f1b9-4990-4c21-96ff-986301d19f96'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','a2dbb8d4-1f62-4577-ba92-3c4242f4bea4'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','b84c5000-1c6b-4c61-9518-3428f3ec3c43'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','6d78a51e-3f6f-4cf2-b1af-19d12a60d0d6'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','3cfec7d0-024e-4a2f-b990-1abfe3c22e56'),
	('67b9a84e-75e1-462e-93c3-3ff11095b897','6e3db063-202e-43b2-8a8f-ced5d2498e29'),
	('5e567f84-6bcf-41d2-89c8-8d24b3b7f95e','2d0c0b8b-fb38-4c9b-a0c6-7a59f74f05fd'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','92b0e861-bd9d-4993-b3e1-74e1f5ee73e9'),
	('60b9e2aa-1467-44db-b5de-451d654355e1','2a76ff8e-6866-4745-8727-d60f6fc1f8d0'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','0a2f7918-5027-4c56-903e-9a02a6a39bfa'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c92','2d2093ef-3d85-4433-a3ac-f141a3b10280'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8','7d65f1b9-4990-4c21-96ff-986301d19f96'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','1a76ff8e-6866-4745-8727-d60f6fc1f8d0'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','0ee49509-6e95-49b3-b715-972868937c3f'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','2bd504f7-1f1b-4f13-bf71-2450e2883cf5'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','a89b79cb-2ef7-4720-903f-2d40902df5a2'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','2e1a31c1-b5c7-42e7-b3e8-d4d4a5d97c15'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2f9eb9d0-1e10-453e-bf09-7ec5cbb10092'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','1a76ff8e-6866-4745-8727-d60f6fc1f8d0');

INSERT INTO menulis_skenario_tayangan VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','60b9e2aa-1467-44db-b5de-451d654355e0'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','60b9e2aa-1467-44db-b5de-451d654355e0'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','60b9e2aa-1467-44db-b5de-451d654355e0'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','8fb9e670-ef6d-47b1-92ac-6d344f0f8fd1'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','3f078684-b76c-45f6-9f49-23f2ff82b8bb'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','1f5e30f8-5b8d-4d2f-b6b9-0a2b3a1b3d45'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','1df2a180-3bbf-4ba9-b75b-c4ef7640e36d'),
	('60b9e2aa-1467-44db-b5de-451d654355e0','7b0e6f05-6bc3-4745-ae17-e8c58e07fd5e'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','e2e0e1a5-45cc-4a28-97b0-2cf3b6cd7445'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','7f93e6d7-1e5c-45d7-8d33-d358e2a7b9ef'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','e4ab6ad3-5074-432d-a16d-0467ee1f512f'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','3f078684-b76c-45f6-9f49-23f2ff82b8bb');

INSERT INTO genre_tayangan VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','Action'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','Adventure'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','Fantasy'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','Sci-Fi'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','Drama'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','Mystery'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','Thriller'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','Comedy'),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','Romance'),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','Horror');

INSERT INTO perusahaan_produksi VALUES ('DreamWorks Animation'),
	('Paramount Pictures'),
	('Warner Bros. Pictures'),
	('Universal Pictures'),
	('Columbia Pictures'),
	('Pixar Animation Studios'),
	('20th Century Studios'),
	('New Line Cinema'),
	('Walt Disney Pictures'),
	('Lionsgate'),
	('Metro-Goldwyn-Mayer (MGM)'),
	('Sony Pictures Entertainment (SPE)'),
	('Legendary Entertainment'),
	('Village Roadshow Pictures'),
	('Amblin Entertainment');

INSERT INTO persetujuan VALUES ('DreamWorks Animation','164c4142-3163-4e85-8b36-36b2b2e9c31c','2024-06-15 00:00:00',120,50000,'2024-07-01 00:00:00'),
	('Paramount Pictures','64a9a4bb-1f78-43c6-8d7b-df188b2b396f','2024-07-20 00:00:00',90,40000,'2024-08-10 00:00:00'),
	('Warner Bros. Pictures','52ab837e-ff35-4932-80b0-d00198ba2543','2024-08-05 00:00:00',110,60000,'2024-08-25 00:00:00'),
	('Universal Pictures','7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2024-08-30 00:00:00',100,55000,'2024-09-15 00:00:00'),
	('Columbia Pictures','72d21279-3823-4f33-a64d-d63a5b0bfb11','2024-09-15 00:00:00',95,45000,'2024-10-01 00:00:00'),
	('Pixar Animation Studios','68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','2024-10-05 00:00:00',105,58000,'2024-10-20 00:00:00'),
	('20th Century Studios','67b9a84e-75e1-462e-93c3-3ff11095b898','2024-11-01 00:00:00',80,35000,'2024-11-15 00:00:00'),
	('New Line Cinema','7c24374a-9f6d-45df-8c02-5df825e255d7','2024-11-20 00:00:00',115,62000,'2024-12-05 00:00:00'),
	('Walt Disney Pictures','60b9e2aa-1467-44db-b5de-451d654355e0','2024-12-10 00:00:00',125,68000,'2024-12-25 00:00:00'),
	('Lionsgate','52ab837e-ff35-4932-80b0-d00198ba2543','2025-01-05 00:00:00',90,40000,'2025-01-20 00:00:00'),
	('Metro-Goldwyn-Mayer (MGM)','164c4142-3163-4e85-8b36-36b2b2e9c31c','2025-02-01 00:00:00',105,55000,'2025-02-15 00:00:00'),
	('Sony Pictures Entertainment (SPE)','67b9a84e-75e1-462e-93c3-3ff11095b898','2025-02-20 00:00:00',110,60000,'2025-03-05 00:00:00'),
	('Legendary Entertainment','68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','2025-03-10 00:00:00',95,45000,'2025-03-25 00:00:00'),
	('Village Roadshow Pictures','7c24374a-9f6d-45df-8c02-5df825e255d7','2025-04-05 00:00:00',85,37000,'2025-04-20 00:00:00'),
	('Amblin Entertainment','60b9e2aa-1467-44db-b5de-451d654355e0','2025-04-20 00:00:00',120,62000,'2025-05-05 00:00:00'),
	('DreamWorks Animation','52ab837e-ff35-4932-80b0-d00198ba2543','2025-05-10 00:00:00',110,58000,'2025-05-25 00:00:00'),
	('Paramount Pictures','164c4142-3163-4e85-8b36-36b2b2e9c31c','2025-06-05 00:00:00',100,53000,'2025-06-20 00:00:00'),
	('Warner Bros. Pictures','67b9a84e-75e1-462e-93c3-3ff11095b898','2025-06-20 00:00:00',95,48000,'2025-07-05 00:00:00'),
    ('Metro-Goldwyn-Mayer (MGM)','7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2024-01-16 00:00:00',112,80000,'2024-08-31 00:00:00'),
	('Universal Pictures','68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','2025-07-05 00:00:00',115,65000,'2025-07-20 00:00:00');

INSERT INTO series VALUES ('67b9a84e-75e1-462e-93c3-3ff11095b897'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f'),
	('60b9e2aa-1467-44db-b5de-451d654355e1'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899');

INSERT INTO film VALUES ('5e567f84-6bcf-41d2-89c8-8d24b3b7f95e','http://example.com/film1.mp4','2024-07-15 00:00:00',120),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c92','http://example.com/film2.mp4','2024-08-20 00:00:00',110),
	('67b9a84e-75e1-462e-93c3-3ff11095b898','http://example.com/film3.mp4','2024-09-25 00:00:00',100),
	('52ab837e-ff35-4932-80b0-d00198ba2543','http://example.com/film4.mp4','2024-10-30 00:00:00',95),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','http://example.com/film5.mp4','2024-12-05 00:00:00',90),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','http://example.com/film6.mp4','2025-01-10 00:00:00',85),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','http://example.com/film7.mp4','2025-02-15 00:00:00',80),
	('68f41e8a-38fd-4e16-a59a-f4a4d0aa0c91','http://example.com/film8.mp4','2025-03-20 00:00:00',75),
	('60b9e2aa-1467-44db-b5de-451d654355e0','http://example.com/film9.mp4','2025-04-25 00:00:00',70),
	('7c24374a-9f6d-45df-8c02-5df825e255d7','http://example.com/film10.mp4','2025-05-30 00:00:00',65);

INSERT INTO episode VALUES ('67b9a84e-75e1-462e-93c3-3ff11095b897','Episode 1','The Beginning',30,'http://example.com/episode1.mp4','2024-07-01 00:00:00'),
	('67b9a84e-75e1-462e-93c3-3ff11095b897','Episode 2','The Journey Begins',35,'http://example.com/episode2.mp4','2024-07-08 00:00:00'),
	('67b9a84e-75e1-462e-93c3-3ff11095b897','Episode 3','The Challenges Ahead',30,'http://example.com/episode3.mp4','2024-07-15 00:00:00'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8','Episode 4','Overcoming Adversity',35,'http://example.com/episode4.mp4','2024-07-22 00:00:00'),
	('7c24374a-9f6d-45df-8c02-5df825e255d8','Episode 5','Unraveling Mysteries',30,'http://example.com/episode5.mp4','2024-07-29 00:00:00'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','Episode 6','The Final Confrontation',35,'http://example.com/episode6.mp4','2024-08-05 00:00:00'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','Episode 1','A New Beginning',40,'http://example.com/episode7.mp4','2024-08-12 00:00:00'),
	('67b9a84e-75e1-462e-93c3-3ff11095b899','Episode 2','Facing the Unknown',45,'http://example.com/episode8.mp4','2024-08-19 00:00:00'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','Episode 3','The Plot Thickens',40,'http://example.com/episode9.mp4','2024-08-26 00:00:00'),
	('64a9a4bb-1f78-43c6-8d7b-df188b2b396f','Episode 4','Climbing the Mountain',45,'http://example.com/episode10.mp4','2024-09-02 00:00:00'),
	('60b9e2aa-1467-44db-b5de-451d654355e1','Episode 5','Confronting the Enemy',40,'http://example.com/episode11.mp4','2024-09-09 00:00:00'),
	('60b9e2aa-1467-44db-b5de-451d654355e1','Episode 6','The Final Showdown',45,'http://example.com/episode12.mp4','2024-09-16 00:00:00');

INSERT INTO ulasan VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','coolcat123','2024-07-01 08:30:00',4,'Great animation and storyline!'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','skywalker87','2024-07-03 09:45:00',5,'Absolutely loved it!'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','rainbowunicorn','2024-07-05 10:20:00',3,'Decent but could be better.'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','gamer_guru','2024-07-07 11:55:00',4,'Enjoyable and entertaining.'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','adventureseeker','2024-07-09 13:10:00',5,'Fantastic! Must watch.'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','musiclover3','2024-07-11 14:25:00',4,'Great soundtrack!'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','techwizard101','2024-07-13 15:40:00',3,'Average, nothing special.'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','bookworm99','2024-07-15 16:55:00',5,'Brilliantly done!'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','coolcat123','2024-08-01 10:30:00',5,'Amazing plot twists!'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','skywalker87','2024-08-03 11:45:00',4,'Intriguing storyline.'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','rainbowunicorn','2024-08-05 12:20:00',3,'Not bad, but expected more.'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','gamer_guru','2024-08-07 13:55:00',4,'Kept me hooked till the end.'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','adventureseeker','2024-08-09 15:10:00',5,'Must-watch for mystery lovers.'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','musiclover3','2024-08-11 16:25:00',4,'Beautifully shot scenes.'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','techwizard101','2024-08-13 17:40:00',3,'Decent but not outstanding.'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','bookworm99','2024-08-15 18:55:00',5,'Riveting from start to finish.');

INSERT INTO tayangan_memiliki_daftar_favorit VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','2024-07-01 08:30:00','coolcat123'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','2024-07-03 09:45:00','skywalker87'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','2024-07-05 10:20:00','rainbowunicorn'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','2024-07-07 11:55:00','gamer_guru'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','2024-08-01 10:30:00','coolcat123'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','2024-08-03 11:45:00','skywalker87'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','2024-08-05 12:20:00','rainbowunicorn'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','2024-08-07 13:55:00','gamer_guru'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2024-08-30 14:30:00','coolcat123'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2024-09-01 15:45:00','skywalker87'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2024-09-03 16:20:00','rainbowunicorn'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','2024-09-05 17:55:00','gamer_guru'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','2024-09-15 18:30:00','coolcat123'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','2024-09-17 19:45:00','skywalker87'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','2024-09-19 20:20:00','rainbowunicorn'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','2024-09-21 21:55:00','gamer_guru');

INSERT INTO daftar_favorit VALUES ('2024-07-01 08:30:00','coolcat123','The Lion King'),
	('2024-07-03 09:45:00','skywalker87','Harry Potter'),
	('2024-07-05 10:20:00','rainbowunicorn','The Lord of the Rings'),
	('2024-07-07 11:55:00','gamer_guru','Star Wars'),
	('2024-08-01 10:30:00','coolcat123','The Avengers'),
	('2024-08-03 11:45:00','skywalker87','Jurassic Park'),
	('2024-08-05 12:20:00','rainbowunicorn','Pirates of the Caribbean'),
	('2024-08-07 13:55:00','gamer_guru','The Matrix'),
	('2024-08-30 14:30:00','coolcat123','The Shawshank Redemption'),
	('2024-09-01 15:45:00','skywalker87','Inception'),
	('2024-09-03 16:20:00','rainbowunicorn','The Dark Knight'),
	('2024-09-05 17:55:00','gamer_guru','Forrest Gump'),
	('2024-09-15 18:30:00','coolcat123','Interstellar'),
	('2024-09-17 19:45:00','skywalker87','Gladiator'),
	('2024-09-19 20:20:00','rainbowunicorn','The Godfather'),
	('2024-09-21 21:55:00','gamer_guru','Fight Club');

INSERT INTO riwayat_nonton VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','coolcat123','2024-07-01 08:00:00','2024-07-01 09:30:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','skywalker87','2024-07-03 09:15:00','2024-07-03 10:45:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','rainbowunicorn','2024-07-05 10:10:00','2024-07-05 11:40:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','gamer_guru','2024-07-07 11:45:00','2024-07-07 13:15:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','coolcat123','2024-08-01 10:20:00','2024-08-01 11:50:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','skywalker87','2024-08-03 11:30:00','2024-08-03 13:00:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','rainbowunicorn','2024-08-05 12:15:00','2024-08-05 13:45:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','gamer_guru','2024-08-07 13:40:00','2024-08-07 15:10:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','coolcat123','2024-08-30 14:10:00','2024-08-30 15:40:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','skywalker87','2024-09-01 15:25:00','2024-09-01 16:55:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','rainbowunicorn','2024-09-03 16:10:00','2024-09-03 17:40:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','gamer_guru','2024-09-05 17:35:00','2024-09-05 19:05:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','coolcat123','2024-09-15 18:20:00','2024-09-15 19:50:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','skywalker87','2024-09-17 19:35:00','2024-09-17 21:05:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','rainbowunicorn','2024-09-19 20:30:00','2024-09-19 22:00:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','gamer_guru','2024-09-21 21:45:00','2024-09-21 23:15:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','coolcat123','2024-07-02 08:00:00','2024-07-02 09:30:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','skywalker87','2024-07-05 09:15:00','2024-07-05 10:45:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','rainbowunicorn','2024-07-10 10:10:00','2024-07-10 11:40:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','gamer_guru','2024-09-07 11:45:00','2024-09-07 13:15:00');

INSERT INTO tayangan_terunduh VALUES ('164c4142-3163-4e85-8b36-36b2b2e9c31c','coolcat123','2024-07-01 08:30:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','skywalker87','2024-07-03 09:45:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','rainbowunicorn','2024-07-05 10:20:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','gamer_guru','2024-07-07 11:55:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','coolcat123','2024-08-01 10:30:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','skywalker87','2024-08-03 11:45:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','rainbowunicorn','2024-08-05 12:20:00'),
	('52ab837e-ff35-4932-80b0-d00198ba2543','gamer_guru','2024-08-07 13:55:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','coolcat123','2024-08-30 14:30:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','skywalker87','2024-09-01 15:45:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','rainbowunicorn','2024-09-03 16:20:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','gamer_guru','2024-09-05 17:55:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','coolcat123','2024-09-15 18:30:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','skywalker87','2024-09-17 19:45:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','rainbowunicorn','2024-09-19 20:20:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','gamer_guru','2024-09-21 21:55:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','coolcat123','2024-07-11 08:30:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','skywalker87','2024-07-13 09:45:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','rainbowunicorn','2024-07-15 10:20:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','gamer_guru','2024-07-17 11:55:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','coolcat123','2024-08-31 14:45:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','skywalker87','2024-09-11 15:10:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','rainbowunicorn','2024-09-13 16:35:00'),
	('7f011a9f-1d3f-4ef9-8a8e-72d1e443d194','gamer_guru','2024-09-15 17:20:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','coolcat123','2024-09-25 18:55:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','skywalker87','2024-09-27 19:20:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','rainbowunicorn','2024-09-29 20:45:00'),
	('72d21279-3823-4f33-a64d-d63a5b0bfb11','gamer_guru','2024-09-30 21:10:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','coolcat123','2024-07-31 08:55:00'),
	('164c4142-3163-4e85-8b36-36b2b2e9c31c','skywalker87','2024-07-13 09:20:00');

