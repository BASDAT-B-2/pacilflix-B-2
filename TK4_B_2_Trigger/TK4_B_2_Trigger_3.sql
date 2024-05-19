CREATE OR REPLACE FUNCTION cek_new_ulasan()
RETURNS TRIGGER AS $$
BEGIN
    -- Periksa apakah ada ulasan dari pengguna untuk tayangan yang sama
    IF EXISTS (
        SELECT 1
        FROM ulasan
        WHERE username = NEW.username
          AND id_tayangan = NEW.id_tayangan
    ) THEN
        -- Jika sudah ada, kirim pesan error
        RAISE EXCEPTION 'Pengguna sudah memberikan ulasan untuk tayangan ini';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cek_new_ulasan_trigger
BEFORE INSERT ON ulasan
FOR EACH ROW
EXECUTE FUNCTION cek_new_ulasan();
