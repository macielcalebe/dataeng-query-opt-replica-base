-- Define uma variavel aleatoria
\set station_id_random random(1, 50)

BEGIN;

INSERT INTO public.status
(station_id, bikes_available, docks_available, "time", category1, category2)
VALUES(:station_id_random, 30, 10, NOW(), 1, 2);

ROLLBACK;
