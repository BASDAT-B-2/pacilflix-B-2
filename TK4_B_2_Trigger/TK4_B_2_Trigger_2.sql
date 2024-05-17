CREATE OR REPLACE FUNCTION check_username()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.username IN (SELECT username FROM PENGGUNA) THEN
        RAISE EXCEPTION 'Username % telah digunakan', NEW.username;
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER check_username
BEFORE INSERT ON PENGGUNA
FOR EACH ROW EXECUTE PROCEDURE check_username();
