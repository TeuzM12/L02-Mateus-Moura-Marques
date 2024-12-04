//PKG_ALUNO

CREATE OR REPLACE PACKAGE PKG_ALUNO AS
  PROCEDURE excluir_aluno(p_id_aluno NUMBER);
  CURSOR listar_maiores_de_18 IS
    SELECT nome, data_nascimento
    FROM alunos
    WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12) > 18;
  FUNCTION alunos_por_curso(p_id_curso NUMBER) RETURN SYS_REFCURSOR;
END PKG_ALUNO;

CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
  PROCEDURE excluir_aluno(p_id_aluno NUMBER) IS
  BEGIN
    DELETE FROM matriculas WHERE id_aluno = p_id_aluno;
    DELETE FROM alunos WHERE id_aluno = p_id_aluno;
  END excluir_aluno;

  FUNCTION alunos_por_curso(p_id_curso NUMBER) RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
      SELECT nome
      FROM alunos a
      JOIN matriculas m ON a.id_aluno = m.id_aluno
      WHERE m.id_curso = p_id_curso;
    RETURN v_cursor;
  END alunos_por_curso;
END PKG_ALUNO;

//PKG_DISCIPLINA

CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
  PROCEDURE cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER);
  CURSOR total_alunos_por_disciplina IS
    SELECT d.nome, COUNT(m.id_aluno) AS total_alunos
    FROM disciplinas d
    JOIN matriculas m ON d.id_disciplina = m.id_disciplina
    GROUP BY d.nome
    HAVING COUNT(m.id_aluno) > 10;
  FUNCTION media_idade_por_disciplina(p_id_disciplina NUMBER) RETURN NUMBER;
  PROCEDURE listar_alunos_por_disciplina(p_id_disciplina NUMBER);
END PKG_DISCIPLINA;

CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
  PROCEDURE cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER) IS
  BEGIN
    INSERT INTO disciplinas (nome, descricao, carga_horaria)
    VALUES (p_nome, p_descricao, p_carga_horaria);
  END cadastrar_disciplina;

  FUNCTION media_idade_por_disciplina(p_id_disciplina NUMBER) RETURN NUMBER IS
    v_media NUMBER;
  BEGIN
    SELECT AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12))
    INTO v_media
    FROM alunos a
    JOIN matriculas m ON a.id_aluno = m.id_aluno
    WHERE m.id_disciplina = p_id_disciplina;
    RETURN v_media;
  END media_idade_por_disciplina;

  PROCEDURE listar_alunos_por_disciplina(p_id_disciplina NUMBER) IS
  BEGIN
    FOR r IN (SELECT a.nome
              FROM alunos a
              JOIN matriculas m ON a.id_aluno = m.id_aluno
              WHERE m.id_disciplina = p_id_disciplina) LOOP
      DBMS_OUTPUT.PUT_LINE(r.nome);
    END LOOP;
  END listar_alunos_por_disciplina;
END PKG_DISCIPLINA;

//PKG_PROFESSOR

CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
  CURSOR total_turmas_por_professor IS
    SELECT p.nome, COUNT(t.id_turma) AS total_turmas
    FROM professores p
    JOIN turmas t ON p.id_professor = t.id_professor
    GROUP BY p.nome
    HAVING COUNT(t.id_turma) > 1;
  FUNCTION total_turmas_de_professor(p_id_professor NUMBER) RETURN NUMBER;
  FUNCTION professor_de_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/

CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
  FUNCTION total_turmas_de_professor(p_id_professor NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT COUNT(t.id_turma)
    INTO v_total
    FROM turmas t
    WHERE t.id_professor = p_id_professor;
    RETURN v_total;
  END total_turmas_de_professor;

  FUNCTION professor_de_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2 IS
    v_nome_professor VARCHAR2(100);
  BEGIN
    SELECT p.nome
    INTO v_nome_professor
    FROM professores p
    JOIN disciplinas d ON p.id_professor = d.id_professor
    WHERE d.id_disciplina = p_id_disciplina;
    RETURN v_nome_professor;
  END professor_de_disciplina;
END PKG_PROFESSOR;
