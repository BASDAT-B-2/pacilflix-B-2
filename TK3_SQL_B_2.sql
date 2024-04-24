CREATE SCHEMA PACILFLIX;

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
    timestamp_pembayaran datetime NOT NULL
);

CREATE TABLE contributors (
    id UUID,
    nama varchar(50) NOT NULL,
    jenis_kelamin int NOT NULL,
    kewarganegaraan varchar(50) NOT NULL
);

CREATE TABLE penulis_skenario (
    id UUID,
);

CREATE TABLE pemain (
    id UUID,
);

CREATE TABLE sutradara (
    id UUID,
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
    id_tayangan UUID,
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
    timestamp datetime,
    rating int NOT NULL DEFAULT 0,
    deskripsi varchar(255)
);

CREATE TABLE tayangan_memiliki_daftar_favorit (
    id_tayangan UUID,
    timestamp datetime,
    username varchar(50)
);

CREATE TABLE daftar_favorit (
    timestamp datetime,
    username varchar(50),
    judul varchar(50) NOT NULL
);

CREATE TABLE riwayat_nonton (
    id_tayangan UUID,
    username varchar(50),
    start_date_time datetime,
    end_date_time datetime NOT NULL
);

CREATE TABLE tayangan_terunduh (
    id_tayangan UUID,
    username varchar(50),
    timestamp datetime
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
ADD PRIMARY KEY (username, start_date_time);
  ADD CONSTRAINT transaction_ibfk_1 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT transaction_ibfk_2 FOREIGN KEY (nama_paket) REFERENCES paket (nama) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE penulis_skenario
ADD PRIMARY KEY (id);
  ADD CONSTRAINT penulis_skenario_ibfk_1 FOREIGN KEY (id) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pemain
ADD PRIMARY KEY (id);
  ADD CONSTRAINT pemain_ibfk_1 FOREIGN KEY (id) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE sutradara
ADD PRIMARY KEY (id);
  ADD CONSTRAINT sutradara_ibfk_1 FOREIGN KEY (id) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tayangan
ADD PRIMARY KEY (id);
  ADD CONSTRAINT tayangan_ibfk_1 FOREIGN KEY (id_sutradara) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE memainkan_tayangan
ADD PRIMARY KEY (id_tayangan, id_pemain);
  ADD CONSTRAINT memainkan_tayangan_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE menulis_skenario_tayangan
ADD PRIMARY KEY (id_tayangan, id_penulis_skenario);
  ADD CONSTRAINT penulis_skenario_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT penulis_skenario_ibfk_2 FOREIGN KEY (id_penulis_skenario) REFERENCES contributors (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE genre_tayangan
ADD PRIMARY KEY (id_tayangan, genre);
  ADD CONSTRAINT genre_tayangan_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE perusahaan_produksi
ADD PRIMARY KEY (nama);

ALTER TABLE persetujuan
ADD PRIMARY KEY (nama, id_tayangan, tanggal_persetujuan);
  ADD CONSTRAINT persetujuan_ibfk_1 FOREIGN KEY (nama) REFERENCES perusahaan_produksi (nama) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT persetujuan_ibfk_2 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE series
ADD PRIMARY KEY (id_tayangan);
  ADD CONSTRAINT series_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE film
ADD PRIMARY KEY (id_tayangan);
  ADD CONSTRAINT film_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE episode
ADD PRIMARY KEY (id_series, sub_judul);
  ADD CONSTRAINT episode_ibfk_1 FOREIGN KEY (id_series) REFERENCES series (id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ulasan
ADD PRIMARY KEY (username, timestamp);
  ADD CONSTRAINT ulasan_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT ulasan_ibfk_2 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tayangan_memiliki_daftar_favorit
ADD PRIMARY KEY (id_tayangan, timestamp, username);
  ADD CONSTRAINT tayangan_memiliki_daftar_favorit_ibfk_1 FOREIGN KEY (timestamp) REFERENCES daftar_favorit (timestamp) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT tayangan_memiliki_daftar_favorit_ibfk_2 FOREIGN KEY (username) REFERENCES daftar_favorit (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE daftar_favorit
ADD PRIMARY KEY (timestamp, username);
  ADD CONSTRAINT daftar_favorit_ibfk_1 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE riwayat_nonton
ADD PRIMARY KEY (username, start_date_time);
  ADD CONSTRAINT riwayat_nonton_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT riwayat_nonton_ibfk_2 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tayangan_terunduh
ADD PRIMARY KEY (id_tayangan, username, timestamp);
  ADD CONSTRAINT tayangan_terunduh_ibfk_1 FOREIGN KEY (id_tayangan) REFERENCES tayangan (id) ON DELETE CASCADE ON UPDATE CASCADE;
  ADD CONSTRAINT tayangan_terunduh_ibfk_2 FOREIGN KEY (username) REFERENCES pengguna (username) ON DELETE CASCADE ON UPDATE CASCADE;


