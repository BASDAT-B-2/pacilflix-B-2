CREATE OR REPLACE FUNCTION check_active_subscription()
RETURNS TRIGGER AS
$$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM TRANSACTION
        WHERE username = NEW.username
          AND end_date_time > CURRENT_DATE
    ) THEN
        UPDATE TRANSACTION
        SET start_date_time = CURRENT_DATE,
            end_date_time = CURRENT_DATE + INTERVAL '30 days',
            nama_paket = NEW.nama_paket,
            metode_pembayaran = NEW.metode_pembayaran,
            timestamp_pembayaran = CURRENT_TIMESTAMP
        WHERE username = NEW.username
          AND end_date_time > CURRENT_DATE;
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$
LANGUAGE plpgsql;
