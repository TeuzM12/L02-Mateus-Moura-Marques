Sistema de Gestão Acadêmica:

Este repositório tem alguns pacotes PL/SQL para trabalhar com alunos, disciplinas e professores no Oracle. A ideia é praticar procedures, functions e cursores de forma simples e direta.

O que cada pacote faz:
PKG_ALUNO:
* excluir_aluno(p_id_aluno NUMBER): Apaga o aluno pelo ID e remove as matrículas relacionadas.
* Cursor listar_maiores_de_18: Mostra nome e data de nascimento dos alunos maiores de 18 anos.
* alunos_por_curso(p_id_curso NUMBER) (Function): Dá uma lista dos alunos de um curso específico.

PKG_DISCIPLINA:
* cadastrar_disciplina(p_nome, p_descricao, p_carga_horaria): Cadastra uma disciplina com as informações fornecidas.
* Cursor total_alunos_por_disciplina: Mostra disciplinas com mais de 10 alunos matriculados.
* media_idade_por_disciplina(p_id_disciplina NUMBER) (Function): Calcula a média de idade dos alunos da disciplina indicada.
* listar_alunos_por_disciplina(p_id_disciplina NUMBER) (Procedure): Mostra os alunos matriculados na disciplina.

PKG_PROFESSOR:
* Cursor total_turmas_por_professor: Lista professores e quantas turmas eles têm (só os que têm mais de uma turma aparecem).
* total_turmas_de_professor(p_id_professor NUMBER) (Function): Conta quantas turmas um professor tem.
* professor_de_disciplina(p_id_disciplina NUMBER) (Function): Diz quem é o professor responsável por uma disciplina.

Como usar:
* Configurar o ambiente: Antes de rodar o script, garanta que as tabelas (alunos, disciplinas, professores, matriculas, turmas) já existem no banco.

Rodar o script:
* Rode o arquivo script.sql assim: @script.sql
* Testar os pacotes: Depois de criar os pacotes, você pode testar os procedimentos e funções no Oracle.

Exemplos:
* Excluir um aluno pelo ID:
BEGIN
  PKG_ALUNO.excluir_aluno(101); -- Troque o 101 pelo ID do aluno.
END; 

* Listar alunos maiores de 18 anos:
DECLARE
  CURSOR c IS PKG_ALUNO.listar_maiores_de_18;
  r c%ROWTYPE;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO r;
    EXIT WHEN c%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Nome: ' || r.nome || ' | Nascimento: ' || r.data_nascimento);
  END LOOP;
  CLOSE c;
END;
