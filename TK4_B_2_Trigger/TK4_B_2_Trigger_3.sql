CREATE OR REPLACE FUNCTION cek_ulasan()
RETURNS TRIGGER AS $$
BEGIN
    -- Periksa apakah ada ulasan dari pengguna untuk tayangan yang sama
    IF EXISTS (
        SELECT 1
        FROM ulasan
        WHERE id_pengguna = NEW.id_pengguna
          AND id_tayangan = NEW.id_tayangan
    ) THEN
        -- Jika sudah ada, kirim pesan error
        RAISE EXCEPTION 'Pengguna sudah memberikan ulasan untuk tayangan ini';
    ELSE
        -- Jika belum ada, buat entri baru pada tabel ulasan
        INSERT INTO ulasan(id_pengguna, id_tayangan, ulasan)
        VALUES (NEW.id_pengguna, NEW.id_tayangan, NEW.ulasan);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cek_ulasan_trigger
BEFORE INSERT ON ulasan
FOR EACH ROW
EXECUTE FUNCTION cek_ulasan();
