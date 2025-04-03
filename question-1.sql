-- a. Escreva uma consulta PostgreSQL para obter, por nome da escola e por dia, a quantidade de alunos matriculados e o valor total das matrículas, tendo como restrição os cursos que começam com a palavra “data”. Ordene o resultado do dia mais recente para o mais antigo.

SELECT 
    sch.name AS nome_escola,
    stu.enrolled_at AS data_matricula,
    COUNT(stu.id) AS quantidade_alunos,
    SUM(c.price) AS receita_total
FROM 
    students stu
JOIN 
    courses c ON stu.course_id = c.id
JOIN 
    schools sch ON c.school_id = sch.id
WHERE 
    c.name LIKE 'data%'
GROUP BY 
    sch.name, stu.enrolled_at
ORDER BY 
    stu.enrolled_at DESC;
    
-- b.Utilizando a resposta do item a, escreva uma consulta para obter, por escola e por dia, a soma acumulada, a média móvel 7 dias e a média móvel 30 dias da quantidade de alunos.

WITH matriculas_diarias AS (
    SELECT 
        sch.name AS nome_escola,
        stu.enrolled_at AS data_matricula,
        COUNT(stu.id) AS quantidade_alunos
    FROM 
        students stu
    JOIN 
        courses c ON stu.course_id = c.id
    JOIN 
        schools sch ON c.school_id = sch.id
    WHERE 
        c.name LIKE 'data%'
    GROUP BY 
        sch.name, stu.enrolled_at
)
SELECT 
    nome_escola,
    data_matricula,
    quantidade_alunos,
    SUM(quantidade_alunos) OVER (
        PARTITION BY nome_escola 
        ORDER BY data_matricula
    ) AS soma_acumulada,
    AVG(quantidade_alunos) OVER (
        PARTITION BY nome_escola 
        ORDER BY data_matricula 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS media_movel_7dias,
    AVG(quantidade_alunos) OVER (
        PARTITION BY nome_escola 
        ORDER BY data_matricula 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS media_movel_30dias
FROM 
    matriculas_diarias
ORDER BY 
    nome_escola, data_matricula DESC;