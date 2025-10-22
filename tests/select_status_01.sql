-- Define uma variavel aleatoria
\set station_id_random random(1, 80)

BEGIN;

-- Simula a busca dos status de uma estacao qualquer
SELECT *
FROM status s
WHERE s.station_id = :station_id_random;


ROLLBACK;