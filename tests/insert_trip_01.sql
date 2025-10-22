-- Define uma variavel aleatoria
\set id_random random(1000000, 100000000)

BEGIN;

INSERT INTO public.trip
(id, duration, start_date, start_station_id, end_date, end_station_id, bike_id, subscription_type, zip_code)
VALUES(:id_random, 0, now(), 10, now(), 21, 5, '', '');


ROLLBACK;