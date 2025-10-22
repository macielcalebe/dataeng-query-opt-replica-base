-- Define uma variavel aleatoria
\set qtde_dock random(10, 30)

BEGIN;

-- Simula a busca de uma estacao com uma quantidade X de docks
SELECT *
FROM station s
WHERE S.dock_count = :qtde_dock;


ROLLBACK;