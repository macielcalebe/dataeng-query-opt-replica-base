-- Define variaveis aleatorias
\set station_id_random random(200, 50000)
\set qtde_dock random(10, 30)

BEGIN;

INSERT INTO public.station
(id, "name", lat, long, dock_count, city, installation_date)
VALUES(:station_id_random, 'Algum nome', 0, 0, :qtde_dock, 'Sao Paulo', CURRENT_DATE);


ROLLBACK;