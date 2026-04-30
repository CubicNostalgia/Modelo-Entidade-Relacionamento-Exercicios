-- Modelo Entidade-Relacionamento - Exercícios (a até m)
-- Compatível com MySQL 8+

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

/* =========================================================
   a) Seguradora de automóveis
   ========================================================= */
DROP DATABASE IF EXISTS ex_a_seguradora;
CREATE DATABASE ex_a_seguradora CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_a_seguradora;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  email VARCHAR(180),
  telefone VARCHAR(20)
);

CREATE TABLE carro (
  id_carro INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) NOT NULL UNIQUE,
  chassi VARCHAR(25) UNIQUE,
  marca VARCHAR(60) NOT NULL,
  modelo VARCHAR(60) NOT NULL,
  ano_fabricacao YEAR,
  ano_modelo YEAR
);

CREATE TABLE apolice (
  id_apolice INT AUTO_INCREMENT PRIMARY KEY,
  numero_apolice VARCHAR(30) NOT NULL UNIQUE,
  id_cliente INT NOT NULL,
  id_carro INT NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  valor_premio DECIMAL(12,2) NOT NULL,
  valor_franquia DECIMAL(12,2),
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_carro) REFERENCES carro(id_carro),
  CHECK (data_fim >= data_inicio)
);

CREATE TABLE ocorrencia (
  id_ocorrencia INT AUTO_INCREMENT PRIMARY KEY,
  id_apolice INT NOT NULL,
  tipo_ocorrencia ENUM('ACIDENTE','ROUBO','PANE','OUTRO') NOT NULL,
  data_ocorrencia DATE NOT NULL,
  local_ocorrencia VARCHAR(180),
  descricao TEXT,
  valor_prejuizo DECIMAL(12,2),
  FOREIGN KEY (id_apolice) REFERENCES apolice(id_apolice)
);

/* =========================================================
   b) Indústria (peças, depósitos, fornecedores, projetos,
      funcionários e departamentos)
   ========================================================= */
DROP DATABASE IF EXISTS ex_b_industria;
CREATE DATABASE ex_b_industria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_b_industria;

CREATE TABLE departamento (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cargo VARCHAR(60),
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE projeto (
  id_projeto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE,
  descricao TEXT
);

CREATE TABLE funcionario_projeto (
  id_funcionario INT NOT NULL,
  id_projeto INT NOT NULL,
  data_alocacao DATE,
  PRIMARY KEY (id_funcionario, id_projeto),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto)
);

CREATE TABLE fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razao_social VARCHAR(150) NOT NULL,
  cnpj VARCHAR(18) UNIQUE
);

CREATE TABLE deposito (
  id_deposito INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  localizacao VARCHAR(150)
);

CREATE TABLE peca (
  id_peca INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  unidade_medida VARCHAR(20),
  id_deposito INT,
  FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito)
);

CREATE TABLE fornecedor_peca (
  id_fornecedor INT NOT NULL,
  id_peca INT NOT NULL,
  preco_unitario DECIMAL(12,2),
  PRIMARY KEY (id_fornecedor, id_peca),
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),
  FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);

CREATE TABLE projeto_fornecedor (
  id_projeto INT NOT NULL,
  id_fornecedor INT NOT NULL,
  PRIMARY KEY (id_projeto, id_fornecedor),
  FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),
  FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);

CREATE TABLE projeto_peca (
  id_projeto INT NOT NULL,
  id_peca INT NOT NULL,
  quantidade DECIMAL(12,3),
  PRIMARY KEY (id_projeto, id_peca),
  FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),
  FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
);

/* =========================================================
   c) Indústria por setores, peças e matéria-prima
   ========================================================= */
DROP DATABASE IF EXISTS ex_c_setores;
CREATE DATABASE ex_c_setores CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_c_setores;

CREATE TABLE setor (
  id_setor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_setor INT NOT NULL,
  FOREIGN KEY (id_setor) REFERENCES setor(id_setor)
);

CREATE TABLE peca (
  id_peca INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_setor_responsavel INT NOT NULL,
  FOREIGN KEY (id_setor_responsavel) REFERENCES setor(id_setor)
);

CREATE TABLE composicao_peca (
  id_peca_produto INT NOT NULL,
  id_materia_prima INT NOT NULL,
  quantidade DECIMAL(12,3) NOT NULL,
  PRIMARY KEY (id_peca_produto, id_materia_prima),
  FOREIGN KEY (id_peca_produto) REFERENCES peca(id_peca),
  FOREIGN KEY (id_materia_prima) REFERENCES peca(id_peca)
);

/* =========================================================
   d) Contratos de serviços, clientes e advogados
   ========================================================= */
DROP DATABASE IF EXISTS ex_d_contratos;
CREATE DATABASE ex_d_contratos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_d_contratos;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  tipo_pessoa ENUM('FISICA','JURIDICA') NOT NULL,
  documento VARCHAR(20) UNIQUE
);

CREATE TABLE advogado (
  id_advogado INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  oab VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE contrato (
  id_contrato INT AUTO_INCREMENT PRIMARY KEY,
  numero_contrato VARCHAR(40) NOT NULL UNIQUE,
  id_cliente INT NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE,
  objeto TEXT,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE contrato_advogado (
  id_contrato INT NOT NULL,
  id_advogado INT NOT NULL,
  papel VARCHAR(60),
  PRIMARY KEY (id_contrato, id_advogado),
  FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato),
  FOREIGN KEY (id_advogado) REFERENCES advogado(id_advogado)
);

/* =========================================================
   e) Funcionários, departamentos, cursos, secretárias, motoristas
   ========================================================= */
DROP DATABASE IF EXISTS ex_e_funcionarios;
CREATE DATABASE ex_e_funcionarios CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_e_funcionarios;

CREATE TABLE departamento (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  tipo_funcionario ENUM('ENGENHEIRO','SECRETARIA','MOTORISTA','OUTRO') NOT NULL,
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE curso_especializacao (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE,
  instituicao VARCHAR(120)
);

CREATE TABLE funcionario_curso (
  id_funcionario INT NOT NULL,
  id_curso INT NOT NULL,
  data_conclusao DATE,
  PRIMARY KEY (id_funcionario, id_curso),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  FOREIGN KEY (id_curso) REFERENCES curso_especializacao(id_curso)
);

CREATE TABLE idioma (
  id_idioma INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE secretaria_idioma (
  id_funcionario INT NOT NULL,
  id_idioma INT NOT NULL,
  nivel ENUM('BASICO','INTERMEDIARIO','AVANCADO','FLUENTE') NOT NULL,
  PRIMARY KEY (id_funcionario, id_idioma),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma)
);

CREATE TABLE veiculo (
  id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) NOT NULL UNIQUE,
  marca VARCHAR(60),
  modelo VARCHAR(60)
);

CREATE TABLE motorista_veiculo (
  id_funcionario INT NOT NULL,
  id_veiculo INT NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  PRIMARY KEY (id_funcionario, id_veiculo, data_inicio),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
);

CREATE TABLE acidente (
  id_acidente INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario_motorista INT NOT NULL,
  id_veiculo INT,
  data_acidente DATE NOT NULL,
  descricao TEXT,
  FOREIGN KEY (id_funcionario_motorista) REFERENCES funcionario(id_funcionario),
  FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
);

/* =========================================================
   f) Campeonato de pesca submarina
   ========================================================= */
DROP DATABASE IF EXISTS ex_f_pesca;
CREATE DATABASE ex_f_pesca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_f_pesca;

CREATE TABLE campeonato (
  id_campeonato INT AUTO_INCREMENT PRIMARY KEY,
  ano INT NOT NULL UNIQUE
);

CREATE TABLE temporada (
  id_temporada INT AUTO_INCREMENT PRIMARY KEY,
  id_campeonato INT NOT NULL,
  numero_temporada TINYINT NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  UNIQUE (id_campeonato, numero_temporada),
  FOREIGN KEY (id_campeonato) REFERENCES campeonato(id_campeonato),
  CHECK (numero_temporada BETWEEN 1 AND 4)
);

CREATE TABLE equipe (
  id_equipe INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE pescador (
  id_pescador INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_equipe INT NOT NULL,
  eh_chefe BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
);

CREATE TABLE area_pesqueira (
  id_area INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE distribuicao_diaria (
  id_distribuicao INT AUTO_INCREMENT PRIMARY KEY,
  id_campeonato INT NOT NULL,
  data_competicao DATE NOT NULL,
  id_equipe INT NOT NULL,
  id_area INT NOT NULL,
  UNIQUE (id_campeonato, data_competicao, id_equipe),
  UNIQUE (id_campeonato, id_equipe, id_area),
  FOREIGN KEY (id_campeonato) REFERENCES campeonato(id_campeonato),
  FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
  FOREIGN KEY (id_area) REFERENCES area_pesqueira(id_area)
);

CREATE TABLE tipo_peixe (
  id_tipo_peixe INT AUTO_INCREMENT PRIMARY KEY,
  nome_comum VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE temporada_pontuacao_peixe (
  id_temporada INT NOT NULL,
  id_tipo_peixe INT NOT NULL,
  pontos INT NOT NULL,
  PRIMARY KEY (id_temporada, id_tipo_peixe),
  FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada),
  FOREIGN KEY (id_tipo_peixe) REFERENCES tipo_peixe(id_tipo_peixe)
);

CREATE TABLE captura (
  id_captura INT AUTO_INCREMENT PRIMARY KEY,
  id_distribuicao INT NOT NULL,
  id_pescador INT NOT NULL,
  id_tipo_peixe INT NOT NULL,
  peso_kg DECIMAL(8,3) NOT NULL,
  tamanho_cm DECIMAL(8,2) NOT NULL,
  sexo ENUM('M','F','INDETERMINADO') NOT NULL,
  FOREIGN KEY (id_distribuicao) REFERENCES distribuicao_diaria(id_distribuicao),
  FOREIGN KEY (id_pescador) REFERENCES pescador(id_pescador),
  FOREIGN KEY (id_tipo_peixe) REFERENCES tipo_peixe(id_tipo_peixe)
);

CREATE TABLE escore_diario (
  id_escore INT AUTO_INCREMENT PRIMARY KEY,
  id_campeonato INT NOT NULL,
  data_competicao DATE NOT NULL,
  id_equipe INT NOT NULL,
  pontos_total INT NOT NULL,
  UNIQUE (id_campeonato, data_competicao, id_equipe),
  FOREIGN KEY (id_campeonato) REFERENCES campeonato(id_campeonato),
  FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe)
);

/* =========================================================
   g) Universidade: aluno, matrícula, curso, disciplina, departamento
   ========================================================= */
DROP DATABASE IF EXISTS ex_g_universidade;
CREATE DATABASE ex_g_universidade CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_g_universidade;

CREATE TABLE departamento (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE curso (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_departamento INT NOT NULL,
  UNIQUE (nome, id_departamento),
  FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE disciplina (
  id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  carga_horaria INT,
  id_curso INT NOT NULL,
  FOREIGN KEY (id_curso) REFERENCES curso(id_curso)
);

CREATE TABLE aluno (
  id_aluno INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf VARCHAR(14) UNIQUE
);

CREATE TABLE matricula (
  id_matricula INT AUTO_INCREMENT PRIMARY KEY,
  numero_matricula VARCHAR(30) NOT NULL UNIQUE,
  id_aluno INT NOT NULL,
  id_curso INT NOT NULL,
  data_matricula DATE NOT NULL,
  FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
  FOREIGN KEY (id_curso) REFERENCES curso(id_curso)
);

/* =========================================================
   h) Rede de bancos
   ========================================================= */
DROP DATABASE IF EXISTS ex_h_bancos;
CREATE DATABASE ex_h_bancos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_h_bancos;

CREATE TABLE agencia (
  id_agencia INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(20) NOT NULL UNIQUE,
  nome VARCHAR(120) NOT NULL,
  cidade VARCHAR(100)
);

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cargo VARCHAR(60),
  id_agencia INT NOT NULL,
  FOREIGN KEY (id_agencia) REFERENCES agencia(id_agencia)
);

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  id_agencia INT NOT NULL,
  FOREIGN KEY (id_agencia) REFERENCES agencia(id_agencia)
);

CREATE TABLE conta (
  id_conta INT AUTO_INCREMENT PRIMARY KEY,
  numero_conta VARCHAR(30) NOT NULL UNIQUE,
  id_cliente INT NOT NULL,
  tipo_conta ENUM('CORRENTE','POUPANCA','SALARIO','INVESTIMENTO') NOT NULL,
  saldo DECIMAL(14,2) NOT NULL DEFAULT 0,
  ativa BOOLEAN NOT NULL DEFAULT TRUE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

/* =========================================================
   i) Companhia de projetos
   ========================================================= */
DROP DATABASE IF EXISTS ex_i_companhia;
CREATE DATABASE ex_i_companhia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_i_companhia;

CREATE TABLE departamento (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
  id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  tipo_funcionario ENUM('PESQUISADOR','PROJETISTA','ARQUITETO') NOT NULL,
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE projeto (
  id_projeto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE,
  id_departamento INT NOT NULL,
  FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento)
);

CREATE TABLE funcionario_projeto (
  id_funcionario INT NOT NULL,
  id_projeto INT NOT NULL,
  data_inicio DATE,
  data_fim DATE,
  PRIMARY KEY (id_funcionario, id_projeto),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),
  FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto)
);

CREATE TABLE gerente_projeto (
  id_projeto INT NOT NULL,
  id_funcionario INT NOT NULL,
  PRIMARY KEY (id_projeto, id_funcionario),
  FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

CREATE TABLE dependente (
  id_dependente INT AUTO_INCREMENT PRIMARY KEY,
  id_funcionario INT NOT NULL,
  nome VARCHAR(120) NOT NULL,
  parentesco VARCHAR(40),
  data_nascimento DATE,
  FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

/* =========================================================
   j) Agência de turismo
   ========================================================= */
DROP DATABASE IF EXISTS ex_j_turismo;
CREATE DATABASE ex_j_turismo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_j_turismo;

CREATE TABLE cidade (
  id_cidade INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  estado VARCHAR(60),
  pais VARCHAR(60),
  UNIQUE (nome, estado, pais)
);

CREATE TABLE tipo_atracao (
  id_tipo_atracao INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE atracao_turistica (
  id_atracao INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_tipo_atracao INT NOT NULL,
  FOREIGN KEY (id_tipo_atracao) REFERENCES tipo_atracao(id_tipo_atracao)
);

CREATE TABLE cidade_atracao (
  id_cidade INT NOT NULL,
  id_atracao INT NOT NULL,
  PRIMARY KEY (id_cidade, id_atracao),
  FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),
  FOREIGN KEY (id_atracao) REFERENCES atracao_turistica(id_atracao)
);

CREATE TABLE rede_hotel (
  id_rede_hotel INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE hotel (
  id_hotel INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_rede_hotel INT,
  classificacao ENUM('PADRAO','ALTO_PADRAO','LUXO','SUPER_LUXO') NOT NULL,
  FOREIGN KEY (id_rede_hotel) REFERENCES rede_hotel(id_rede_hotel)
);

CREATE TABLE cidade_hotel (
  id_cidade INT NOT NULL,
  id_hotel INT NOT NULL,
  PRIMARY KEY (id_cidade, id_hotel),
  FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),
  FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)
);

CREATE TABLE rede_restaurante (
  id_rede_restaurante INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE restaurante (
  id_restaurante INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_rede_restaurante INT,
  FOREIGN KEY (id_rede_restaurante) REFERENCES rede_restaurante(id_rede_restaurante)
);

CREATE TABLE cidade_restaurante (
  id_cidade INT NOT NULL,
  id_restaurante INT NOT NULL,
  PRIMARY KEY (id_cidade, id_restaurante),
  FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),
  FOREIGN KEY (id_restaurante) REFERENCES restaurante(id_restaurante)
);

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  email VARCHAR(180)
);

CREATE TABLE viagem (
  id_viagem INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_cidade INT NOT NULL,
  data_ida DATE NOT NULL,
  data_volta DATE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade)
);

/* =========================================================
   k) DETRAN
   ========================================================= */
DROP DATABASE IF EXISTS ex_k_detran;
CREATE DATABASE ex_k_detran CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_k_detran;

CREATE TABLE tipo_veiculo (
  id_tipo_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE fabricante (
  id_fabricante INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE modelo_veiculo (
  id_modelo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL,
  id_fabricante INT NOT NULL,
  id_tipo_veiculo INT NOT NULL,
  FOREIGN KEY (id_fabricante) REFERENCES fabricante(id_fabricante),
  FOREIGN KEY (id_tipo_veiculo) REFERENCES tipo_veiculo(id_tipo_veiculo)
);

CREATE TABLE motorista (
  id_motorista INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cnh VARCHAR(20) NOT NULL UNIQUE,
  cpf VARCHAR(14) UNIQUE
);

CREATE TABLE veiculo (
  id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) NOT NULL UNIQUE,
  id_modelo INT NOT NULL,
  id_motorista INT NOT NULL,
  FOREIGN KEY (id_modelo) REFERENCES modelo_veiculo(id_modelo),
  FOREIGN KEY (id_motorista) REFERENCES motorista(id_motorista)
);

CREATE TABLE agente_transito (
  id_agente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  matricula VARCHAR(30) UNIQUE
);

CREATE TABLE infracao (
  id_infracao INT AUTO_INCREMENT PRIMARY KEY,
  id_motorista INT NOT NULL,
  id_veiculo INT NOT NULL,
  data_infracao DATETIME NOT NULL,
  descricao VARCHAR(255) NOT NULL,
  origem_registro ENUM('AGENTE','CAMERA','RADAR') NOT NULL,
  id_agente INT,
  FOREIGN KEY (id_motorista) REFERENCES motorista(id_motorista),
  FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
  FOREIGN KEY (id_agente) REFERENCES agente_transito(id_agente)
);

/* =========================================================
   l) Administradora de condomínios
   ========================================================= */
DROP DATABASE IF EXISTS ex_l_condominios;
CREATE DATABASE ex_l_condominios CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_l_condominios;

CREATE TABLE cidade (
  id_cidade INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  estado VARCHAR(60),
  UNIQUE (nome, estado)
);

CREATE TABLE condominio (
  id_condominio INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  id_cidade INT NOT NULL,
  FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade)
);

CREATE TABLE bloco (
  id_bloco INT AUTO_INCREMENT PRIMARY KEY,
  id_condominio INT NOT NULL,
  identificacao VARCHAR(30) NOT NULL,
  FOREIGN KEY (id_condominio) REFERENCES condominio(id_condominio)
);

CREATE TABLE unidade (
  id_unidade INT AUTO_INCREMENT PRIMARY KEY,
  id_bloco INT NOT NULL,
  numero VARCHAR(20) NOT NULL,
  FOREIGN KEY (id_bloco) REFERENCES bloco(id_bloco)
);

CREATE TABLE pessoa (
  id_pessoa INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf VARCHAR(14) UNIQUE
);

CREATE TABLE unidade_proprietario (
  id_unidade INT NOT NULL,
  id_pessoa INT NOT NULL,
  percentual_propriedade DECIMAL(5,2),
  PRIMARY KEY (id_unidade, id_pessoa),
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE aluguel (
  id_aluguel INT AUTO_INCREMENT PRIMARY KEY,
  id_unidade INT NOT NULL UNIQUE,
  id_locatario INT NOT NULL,
  data_inicio DATE NOT NULL,
  data_fim DATE,
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  FOREIGN KEY (id_locatario) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE morador_unidade (
  id_unidade INT NOT NULL,
  id_pessoa INT NOT NULL,
  PRIMARY KEY (id_unidade, id_pessoa),
  FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),
  FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

/* =========================================================
   m) Biblioteca
   ========================================================= */
DROP DATABASE IF EXISTS ex_m_biblioteca;
CREATE DATABASE ex_m_biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_m_biblioteca;

CREATE TABLE autor (
  id_autor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL
);

CREATE TABLE genero (
  id_genero INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE tipo_livro (
  id_tipo_livro INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE area_conhecimento (
  id_area INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE editora (
  id_editora INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE livro (
  id_livro INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(180) NOT NULL,
  id_genero INT NOT NULL,
  id_tipo_livro INT NOT NULL,
  id_area INT NOT NULL,
  id_editora INT NOT NULL,
  FOREIGN KEY (id_genero) REFERENCES genero(id_genero),
  FOREIGN KEY (id_tipo_livro) REFERENCES tipo_livro(id_tipo_livro),
  FOREIGN KEY (id_area) REFERENCES area_conhecimento(id_area),
  FOREIGN KEY (id_editora) REFERENCES editora(id_editora)
);

CREATE TABLE livro_autor (
  id_livro INT NOT NULL,
  id_autor INT NOT NULL,
  PRIMARY KEY (id_livro, id_autor),
  FOREIGN KEY (id_livro) REFERENCES livro(id_livro),
  FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
);

CREATE TABLE exemplar (
  id_exemplar INT AUTO_INCREMENT PRIMARY KEY,
  id_livro INT NOT NULL,
  codigo_tombo VARCHAR(40) NOT NULL UNIQUE,
  situacao ENUM('DISPONIVEL','ALUGADO','MANUTENCAO') NOT NULL DEFAULT 'DISPONIVEL',
  FOREIGN KEY (id_livro) REFERENCES livro(id_livro)
);

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cpf VARCHAR(14) NOT NULL UNIQUE,
  email VARCHAR(180)
);

CREATE TABLE locacao (
  id_locacao INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  data_locacao DATE NOT NULL,
  data_prevista_devolucao DATE NOT NULL,
  data_devolucao DATE,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE locacao_item (
  id_locacao INT NOT NULL,
  id_exemplar INT NOT NULL,
  PRIMARY KEY (id_locacao, id_exemplar),
  FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao),
  FOREIGN KEY (id_exemplar) REFERENCES exemplar(id_exemplar)
);

SET FOREIGN_KEY_CHECKS = 1;
