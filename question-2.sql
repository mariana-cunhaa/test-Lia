-- Para cada departamento, realize uma consulta em PostgresSQL que mostre o nome do departamento, a quantidade de empregados, a média salarial, o maior e o menor salários. Ordene o resultado pela maior média salarial.

SELECT 
    d.nome AS departamento,
    COUNT(DISTINCT e.matr) AS quantidade_empregados,
    ROUND(COALESCE(AVG(v.valor), 0), 2) AS media_salarial,
    COALESCE(MAX(v.valor), 0) AS maior_salario,
    COALESCE(MIN(v.valor), 0) AS menor_salario
FROM 
    departamento d
LEFT JOIN 
    empregado e ON d.cod_dep = e.lotacao
LEFT JOIN 
    emp_venc ev ON e.matr = ev.matr
LEFT JOIN 
    vencimento v ON ev.cod_venc = v.cod_venc
GROUP BY 
    d.nome
ORDER BY 
    media_salarial DESC;