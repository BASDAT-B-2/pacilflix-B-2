-- Membuat atau mengganti function validate_hapus_tayangan_downloaded
CREATE OR REPLACE FUNCTION validate_hapus_tayangan_downloaded()
RETURNS TRIGGER AS
$$
BEGIN
    -- Memeriksa apakah selisih antara waktu saat ini (dalam zona waktu 'Asia/Jakarta')
    -- dengan waktu unduhan kurang dari 1 hari
    IF (CURRENT_TIMESTAMP AT TIME ZONE 'Asia/Jakarta' - OLD.timestamp) < INTERVAL '1 day' THEN
        RAISE EXCEPTION 'Tayangan yang diunduh harus berusia lebih dari 24 jam sebelum bisa dihapus';        -- Exception jika unduhan berusia kurang dari 24 jam
    ELSE 
        -- Mereturn baris lama jika unduhan berusia lebih dari 24 jam
        RETURN OLD;
    END IF;
END;
$$
LANGUAGE plpgsql;

-- Membuat trigger pada saat sebelum menghapus pada tabel 'TAYANGAN_TERUNDUH'
CREATE TRIGGER before_hapus_tayangan_downloaded()
BEFORE DELETE ON TAYANGAN_TERUNDUH
FOR EACH ROW
EXECUTE FUNCTION validate_hapus_tayangan_downloaded();


