-- =========================================================
-- MODELOS MER - EXERCICIOS A A M (MySQL 8+)
-- Padrao: snake_case, ENGINE=InnoDB, FKs com NOT NULL quando obrigatorias
-- =========================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- EXERCICIO A - SEGURADORA
-- =========================================================
DROP DATABASE IF EXISTS ex_a_seguradora;
CREATE DATABASE ex_a_seguradora CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_a_seguradora;

-- BLOCO LOCALIZACAO
CREATE TABLE estado (
  id_estado INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  sigla VARCHAR(3) NOT NULL,
  UNIQUE KEY uk_estado_sigla (sigla)
) ENGINE=InnoDB;

CREATE TABLE cidade (
  id_cidade INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  id_estado INT NOT NULL,
  CONSTRAINT fk_cidade_estado FOREIGN KEY (id_estado) REFERENCES estado(id_estado),
  KEY idx_cidade_estado (id_estado)
) ENGINE=InnoDB;

-- BLOCO CLIENTE
CREATE TABLE sexo (
  id_sexo INT AUTO_INCREMENT PRIMARY KEY,
  sigla VARCHAR(3) NOT NULL,
  nome VARCHAR(20) NOT NULL,
  UNIQUE KEY uk_sexo_sigla (sigla)
) ENGINE=InnoDB;

CREATE TABLE cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cpf VARCHAR(18) NOT NULL,
  data_nascimento DATE,
  email VARCHAR(255),
  id_sexo INT NOT NULL,
  CONSTRAINT fk_cliente_sexo FOREIGN KEY (id_sexo) REFERENCES sexo(id_sexo),
  UNIQUE KEY uk_cliente_cpf (cpf),
  KEY idx_cliente_sexo (id_sexo)
) ENGINE=InnoDB;

CREATE TABLE endereco (
  id_endereco INT AUTO_INCREMENT PRIMARY KEY,
  logradouro VARCHAR(100) NOT NULL,
  cep VARCHAR(12) NOT NULL,
  bairro VARCHAR(50) NOT NULL,
  complemento VARCHAR(50),
  id_cidade INT NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT fk_endereco_cidade FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),
  CONSTRAINT fk_endereco_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  KEY idx_endereco_cidade (id_cidade),
  KEY idx_endereco_cliente (id_cliente)
) ENGINE=InnoDB;

CREATE TABLE tipo_telefone (
  id_tipo_telefone INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(15) NOT NULL,
  UNIQUE KEY uk_tipo_telefone_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE telefone (
  id_telefone INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(25) NOT NULL,
  id_tipo_telefone INT NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT fk_telefone_tipo FOREIGN KEY (id_tipo_telefone) REFERENCES tipo_telefone(id_tipo_telefone),
  CONSTRAINT fk_telefone_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  KEY idx_telefone_tipo (id_tipo_telefone),
  KEY idx_telefone_cliente (id_cliente)
) ENGINE=InnoDB;

CREATE TABLE habilitacao (
  id_habilitacao INT AUTO_INCREMENT PRIMARY KEY,
  numero VARCHAR(20) NOT NULL,
  data_validade DATE NOT NULL,
  id_cliente INT NOT NULL,
  CONSTRAINT fk_habilitacao_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  UNIQUE KEY uk_habilitacao_numero (numero),
  KEY idx_habilitacao_cliente (id_cliente)
) ENGINE=InnoDB;

CREATE TABLE categoria_habilitacao (
  id_categoria_habilitacao INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(5) NOT NULL,
  UNIQUE KEY uk_categoria_habilitacao_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE habilitacao_categoria (
  id_habilitacao INT NOT NULL,
  id_categoria_habilitacao INT NOT NULL,
  PRIMARY KEY (id_habilitacao, id_categoria_habilitacao),
  CONSTRAINT fk_hc_hab FOREIGN KEY (id_habilitacao) REFERENCES habilitacao(id_habilitacao),
  CONSTRAINT fk_hc_cat FOREIGN KEY (id_categoria_habilitacao) REFERENCES categoria_habilitacao(id_categoria_habilitacao),
  KEY idx_hc_cat (id_categoria_habilitacao)
) ENGINE=InnoDB;

CREATE TABLE foto_habilitacao (
  id_foto_habilitacao INT AUTO_INCREMENT PRIMARY KEY,
  caminho_arquivo VARCHAR(255) NOT NULL,
  id_habilitacao INT NOT NULL,
  CONSTRAINT fk_foto_habilitacao FOREIGN KEY (id_habilitacao) REFERENCES habilitacao(id_habilitacao),
  KEY idx_foto_habilitacao (id_habilitacao)
) ENGINE=InnoDB;

-- BLOCO VEICULO
CREATE TABLE fabricante (
  id_fabricante INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  UNIQUE KEY uk_fabricante_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE modelo (
  id_modelo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  id_fabricante INT NOT NULL,
  CONSTRAINT fk_modelo_fabricante FOREIGN KEY (id_fabricante) REFERENCES fabricante(id_fabricante),
  KEY idx_modelo_fabricante (id_fabricante)
) ENGINE=InnoDB;

CREATE TABLE tipo_veiculo (
  id_tipo_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  UNIQUE KEY uk_tipo_veiculo_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE cor (
  id_cor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(30) NOT NULL,
  UNIQUE KEY uk_cor_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE veiculo (
  id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(12) NOT NULL,
  ano YEAR,
  km INT,
  chassi VARCHAR(25),
  valor DECIMAL(10,2),
  id_modelo INT NOT NULL,
  id_tipo_veiculo INT NOT NULL,
  id_cor INT NOT NULL,
  CONSTRAINT fk_veiculo_modelo FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
  CONSTRAINT fk_veiculo_tipo FOREIGN KEY (id_tipo_veiculo) REFERENCES tipo_veiculo(id_tipo_veiculo),
  CONSTRAINT fk_veiculo_cor FOREIGN KEY (id_cor) REFERENCES cor(id_cor),
  UNIQUE KEY uk_veiculo_placa (placa),
  UNIQUE KEY uk_veiculo_chassi (chassi),
  KEY idx_veiculo_modelo (id_modelo),
  KEY idx_veiculo_tipo (id_tipo_veiculo),
  KEY idx_veiculo_cor (id_cor)
) ENGINE=InnoDB;

CREATE TABLE cobertura (
  id_cobertura INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  UNIQUE KEY uk_cobertura_nome (nome)
) ENGINE=InnoDB;

CREATE TABLE apolice (
  id_apolice INT AUTO_INCREMENT PRIMARY KEY,
  numero_apolice VARCHAR(30) NOT NULL,
  data_inicio DATE NOT NULL,
  data_termino DATE NOT NULL,
  valor_indenizacao DECIMAL(10,2) NOT NULL,
  id_cliente INT NOT NULL,
  id_veiculo INT NOT NULL,
  CONSTRAINT fk_apolice_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  CONSTRAINT fk_apolice_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
  CONSTRAINT ck_apolice_datas CHECK (data_termino >= data_inicio),
  UNIQUE KEY uk_apolice_numero (numero_apolice),
  KEY idx_apolice_cliente (id_cliente),
  KEY idx_apolice_veiculo (id_veiculo)
) ENGINE=InnoDB;

CREATE TABLE apolice_cobertura (
  id_apolice INT NOT NULL,
  id_cobertura INT NOT NULL,
  PRIMARY KEY (id_apolice, id_cobertura),
  CONSTRAINT fk_ac_apolice FOREIGN KEY (id_apolice) REFERENCES apolice(id_apolice),
  CONSTRAINT fk_ac_cobertura FOREIGN KEY (id_cobertura) REFERENCES cobertura(id_cobertura),
  KEY idx_ac_cobertura (id_cobertura)
) ENGINE=InnoDB;

CREATE TABLE ocorrencia (
  id_ocorrencia INT AUTO_INCREMENT PRIMARY KEY,
  data_ocorrencia DATE NOT NULL,
  hora_ocorrencia TIME,
  numero_boletim VARCHAR(20),
  endereco VARCHAR(150),
  observacao VARCHAR(250),
  id_apolice INT NOT NULL,
  CONSTRAINT fk_ocorrencia_apolice FOREIGN KEY (id_apolice) REFERENCES apolice(id_apolice),
  KEY idx_ocorrencia_apolice (id_apolice)
) ENGINE=InnoDB;

CREATE TABLE envolvido_ocorrencia (
  id_envolvido_ocorrencia INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  placa VARCHAR(20),
  observacao VARCHAR(250),
  id_ocorrencia INT NOT NULL,
  CONSTRAINT fk_envolvido_ocorrencia FOREIGN KEY (id_ocorrencia) REFERENCES ocorrencia(id_ocorrencia),
  KEY idx_envolvido_ocorrencia (id_ocorrencia)
) ENGINE=InnoDB;

CREATE TABLE cliente_veiculo (
  id_cliente INT NOT NULL,
  id_veiculo INT NOT NULL,
  PRIMARY KEY (id_cliente, id_veiculo),
  CONSTRAINT fk_cv_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  CONSTRAINT fk_cv_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
  KEY idx_cv_veiculo (id_veiculo)
) ENGINE=InnoDB;

-- =========================================================
-- EXERCICIO B
-- =========================================================
DROP DATABASE IF EXISTS ex_b_industria;
CREATE DATABASE ex_b_industria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_b_industria;
CREATE TABLE departamento (id_departamento INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE deposito (id_deposito INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL,localizacao VARCHAR(150)) ENGINE=InnoDB;
CREATE TABLE fornecedor (id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,razao_social VARCHAR(150) NOT NULL,cnpj VARCHAR(18) UNIQUE) ENGINE=InnoDB;
CREATE TABLE projeto (id_projeto INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE funcionario (id_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_departamento INT NOT NULL,CONSTRAINT fk_func_dep FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento),KEY idx_func_dep (id_departamento)) ENGINE=InnoDB;
CREATE TABLE peca (id_peca INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_deposito INT NOT NULL,CONSTRAINT fk_peca_deposito FOREIGN KEY (id_deposito) REFERENCES deposito(id_deposito),KEY idx_peca_deposito (id_deposito)) ENGINE=InnoDB;
CREATE TABLE funcionario_projeto (id_funcionario INT NOT NULL,id_projeto INT NOT NULL,PRIMARY KEY(id_funcionario,id_projeto),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),KEY idx_fp_proj(id_projeto)) ENGINE=InnoDB;
CREATE TABLE fornecedor_peca (id_fornecedor INT NOT NULL,id_peca INT NOT NULL,PRIMARY KEY(id_fornecedor,id_peca),FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),FOREIGN KEY (id_peca) REFERENCES peca(id_peca),KEY idx_forp_peca(id_peca)) ENGINE=InnoDB;
CREATE TABLE fornecedor_projeto (id_fornecedor INT NOT NULL,id_projeto INT NOT NULL,PRIMARY KEY(id_fornecedor,id_projeto),FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),KEY idx_forp_proj(id_projeto)) ENGINE=InnoDB;
CREATE TABLE projeto_peca (id_projeto INT NOT NULL,id_peca INT NOT NULL,PRIMARY KEY(id_projeto,id_peca),FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),FOREIGN KEY (id_peca) REFERENCES peca(id_peca),KEY idx_pp_peca(id_peca)) ENGINE=InnoDB;

-- EXERCICIO C
DROP DATABASE IF EXISTS ex_c_setores;
CREATE DATABASE ex_c_setores CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_c_setores;
CREATE TABLE setor (id_setor INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE funcionario (id_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_setor INT NOT NULL,FOREIGN KEY (id_setor) REFERENCES setor(id_setor),KEY idx_func_setor(id_setor)) ENGINE=InnoDB;
CREATE TABLE peca (id_peca INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_setor_responsavel INT NOT NULL,FOREIGN KEY (id_setor_responsavel) REFERENCES setor(id_setor),KEY idx_peca_setor(id_setor_responsavel)) ENGINE=InnoDB;
CREATE TABLE composicao_peca (id_peca_produto INT NOT NULL,id_peca_materia_prima INT NOT NULL,quantidade DECIMAL(12,3) NOT NULL,PRIMARY KEY(id_peca_produto,id_peca_materia_prima),FOREIGN KEY (id_peca_produto) REFERENCES peca(id_peca),FOREIGN KEY (id_peca_materia_prima) REFERENCES peca(id_peca),KEY idx_cp_mp(id_peca_materia_prima)) ENGINE=InnoDB;

-- EXERCICIO D
DROP DATABASE IF EXISTS ex_d_contratos;
CREATE DATABASE ex_d_contratos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_d_contratos;
CREATE TABLE cliente (id_cliente INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(150) NOT NULL,documento VARCHAR(20) UNIQUE) ENGINE=InnoDB;
CREATE TABLE advogado (id_advogado INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,oab VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE contrato (id_contrato INT AUTO_INCREMENT PRIMARY KEY,numero_contrato VARCHAR(40) NOT NULL UNIQUE,id_cliente INT NOT NULL,data_inicio DATE NOT NULL,data_fim DATE,FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),KEY idx_contrato_cliente(id_cliente)) ENGINE=InnoDB;
CREATE TABLE contrato_advogado (id_contrato INT NOT NULL,id_advogado INT NOT NULL,PRIMARY KEY(id_contrato,id_advogado),FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato),FOREIGN KEY (id_advogado) REFERENCES advogado(id_advogado),KEY idx_ca_adv(id_advogado)) ENGINE=InnoDB;

-- EXERCICIO E
DROP DATABASE IF EXISTS ex_e_funcionarios;
CREATE DATABASE ex_e_funcionarios CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_e_funcionarios;
CREATE TABLE departamento (id_departamento INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE tipo_funcionario (id_tipo_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE funcionario (id_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_departamento INT NOT NULL,id_tipo_funcionario INT NOT NULL,FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento),FOREIGN KEY (id_tipo_funcionario) REFERENCES tipo_funcionario(id_tipo_funcionario),KEY idx_f_dep(id_departamento),KEY idx_f_tipo(id_tipo_funcionario)) ENGINE=InnoDB;
CREATE TABLE curso_especializacao (id_curso INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE funcionario_curso (id_funcionario INT NOT NULL,id_curso INT NOT NULL,PRIMARY KEY(id_funcionario,id_curso),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),FOREIGN KEY (id_curso) REFERENCES curso_especializacao(id_curso),KEY idx_fc_curso(id_curso)) ENGINE=InnoDB;
CREATE TABLE idioma (id_idioma INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(50) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE secretaria_idioma (id_funcionario INT NOT NULL,id_idioma INT NOT NULL,nivel VARCHAR(20),PRIMARY KEY(id_funcionario,id_idioma),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma),KEY idx_si_idioma(id_idioma)) ENGINE=InnoDB;
CREATE TABLE veiculo (id_veiculo INT AUTO_INCREMENT PRIMARY KEY,placa VARCHAR(10) NOT NULL UNIQUE,modelo VARCHAR(60)) ENGINE=InnoDB;
CREATE TABLE motorista_veiculo (id_funcionario INT NOT NULL,id_veiculo INT NOT NULL,data_inicio DATE NOT NULL,data_fim DATE,PRIMARY KEY(id_funcionario,id_veiculo,data_inicio),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),KEY idx_mv_veiculo(id_veiculo)) ENGINE=InnoDB;
CREATE TABLE acidente (id_acidente INT AUTO_INCREMENT PRIMARY KEY,id_funcionario INT NOT NULL,id_veiculo INT NOT NULL,data_acidente DATE NOT NULL,descricao VARCHAR(250),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),KEY idx_ac_func(id_funcionario),KEY idx_ac_veiculo(id_veiculo)) ENGINE=InnoDB;

-- EXERCICIO F
DROP DATABASE IF EXISTS ex_f_pesca;
CREATE DATABASE ex_f_pesca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_f_pesca;
CREATE TABLE campeonato (id_campeonato INT AUTO_INCREMENT PRIMARY KEY,ano INT NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE temporada (id_temporada INT AUTO_INCREMENT PRIMARY KEY,id_campeonato INT NOT NULL,numero TINYINT NOT NULL,UNIQUE KEY uk_temp(id_campeonato,numero),FOREIGN KEY (id_campeonato) REFERENCES campeonato(id_campeonato),KEY idx_temp_camp(id_campeonato)) ENGINE=InnoDB;
CREATE TABLE equipe (id_equipe INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE pescador (id_pescador INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_equipe INT NOT NULL,eh_chefe TINYINT(1) NOT NULL DEFAULT 0,FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),KEY idx_pesc_equipe(id_equipe)) ENGINE=InnoDB;
CREATE TABLE area_pesqueira (id_area INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE distribuicao_equipe_area (id_campeonato INT NOT NULL,data_competicao DATE NOT NULL,id_equipe INT NOT NULL,id_area INT NOT NULL,PRIMARY KEY(id_campeonato,data_competicao,id_equipe),UNIQUE KEY uk_equipe_area_unica(id_campeonato,id_equipe,id_area),FOREIGN KEY (id_campeonato) REFERENCES campeonato(id_campeonato),FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),FOREIGN KEY (id_area) REFERENCES area_pesqueira(id_area),KEY idx_dea_area(id_area)) ENGINE=InnoDB;
CREATE TABLE tipo_peixe (id_tipo_peixe INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(100) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE temporada_peixe_pontuacao (id_temporada INT NOT NULL,id_tipo_peixe INT NOT NULL,pontos INT NOT NULL,PRIMARY KEY(id_temporada,id_tipo_peixe),FOREIGN KEY (id_temporada) REFERENCES temporada(id_temporada),FOREIGN KEY (id_tipo_peixe) REFERENCES tipo_peixe(id_tipo_peixe),KEY idx_tpp_peixe(id_tipo_peixe)) ENGINE=InnoDB;
CREATE TABLE captura (id_captura INT AUTO_INCREMENT PRIMARY KEY,id_campeonato INT NOT NULL,data_competicao DATE NOT NULL,id_equipe INT NOT NULL,id_pescador INT NOT NULL,id_tipo_peixe INT NOT NULL,peso DECIMAL(8,3) NOT NULL,tamanho DECIMAL(8,2) NOT NULL,sexo VARCHAR(15) NOT NULL,FOREIGN KEY (id_campeonato,data_competicao,id_equipe) REFERENCES distribuicao_equipe_area(id_campeonato,data_competicao,id_equipe),FOREIGN KEY (id_pescador) REFERENCES pescador(id_pescador),FOREIGN KEY (id_tipo_peixe) REFERENCES tipo_peixe(id_tipo_peixe),KEY idx_capt_pesc(id_pescador),KEY idx_capt_tipo(id_tipo_peixe)) ENGINE=InnoDB;
CREATE TABLE escore_diario (id_campeonato INT NOT NULL,data_competicao DATE NOT NULL,id_equipe INT NOT NULL,pontos INT NOT NULL,PRIMARY KEY(id_campeonato,data_competicao,id_equipe),FOREIGN KEY (id_campeonato) REFERENCES campeonato(id_campeonato),FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),KEY idx_ed_equipe(id_equipe)) ENGINE=InnoDB;

-- EXERCICIO G
DROP DATABASE IF EXISTS ex_g_universidade;
CREATE DATABASE ex_g_universidade CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_g_universidade;
CREATE TABLE departamento (id_departamento INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE curso (id_curso INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_departamento INT NOT NULL,FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento),KEY idx_curso_dep(id_departamento)) ENGINE=InnoDB;
CREATE TABLE disciplina (id_disciplina INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_curso INT NOT NULL,FOREIGN KEY (id_curso) REFERENCES curso(id_curso),KEY idx_disc_curso(id_curso)) ENGINE=InnoDB;
CREATE TABLE aluno (id_aluno INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,cpf VARCHAR(14) UNIQUE) ENGINE=InnoDB;
CREATE TABLE matricula (id_matricula INT AUTO_INCREMENT PRIMARY KEY,numero_matricula VARCHAR(30) NOT NULL UNIQUE,id_aluno INT NOT NULL,id_curso INT NOT NULL,data_matricula DATE NOT NULL,FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),FOREIGN KEY (id_curso) REFERENCES curso(id_curso),KEY idx_mat_aluno(id_aluno),KEY idx_mat_curso(id_curso)) ENGINE=InnoDB;

-- EXERCICIO H
DROP DATABASE IF EXISTS ex_h_bancos;
CREATE DATABASE ex_h_bancos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_h_bancos;
CREATE TABLE agencia (id_agencia INT AUTO_INCREMENT PRIMARY KEY,codigo VARCHAR(20) NOT NULL UNIQUE,nome VARCHAR(120) NOT NULL) ENGINE=InnoDB;
CREATE TABLE funcionario (id_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_agencia INT NOT NULL,FOREIGN KEY (id_agencia) REFERENCES agencia(id_agencia),KEY idx_func_ag(id_agencia)) ENGINE=InnoDB;
CREATE TABLE cliente (id_cliente INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,cpf VARCHAR(14) UNIQUE,id_agencia INT NOT NULL,FOREIGN KEY (id_agencia) REFERENCES agencia(id_agencia),KEY idx_cli_ag(id_agencia)) ENGINE=InnoDB;
CREATE TABLE conta (id_conta INT AUTO_INCREMENT PRIMARY KEY,numero_conta VARCHAR(30) NOT NULL UNIQUE,id_cliente INT NOT NULL,id_tipo_conta INT NOT NULL,saldo DECIMAL(14,2) NOT NULL DEFAULT 0,ativa TINYINT(1) NOT NULL DEFAULT 1,FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),KEY idx_conta_cliente(id_cliente)) ENGINE=InnoDB;
CREATE TABLE tipo_conta (id_tipo_conta INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
ALTER TABLE conta ADD CONSTRAINT fk_conta_tipo FOREIGN KEY (id_tipo_conta) REFERENCES tipo_conta(id_tipo_conta), ADD KEY idx_conta_tipo(id_tipo_conta);

-- EXERCICIO I
DROP DATABASE IF EXISTS ex_i_companhia;
CREATE DATABASE ex_i_companhia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_i_companhia;
CREATE TABLE departamento (id_departamento INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE tipo_funcionario (id_tipo_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE funcionario (id_funcionario INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_departamento INT NOT NULL,id_tipo_funcionario INT NOT NULL,FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento),FOREIGN KEY (id_tipo_funcionario) REFERENCES tipo_funcionario(id_tipo_funcionario),KEY idx_i_func_dep(id_departamento),KEY idx_i_func_tipo(id_tipo_funcionario)) ENGINE=InnoDB;
CREATE TABLE projeto (id_projeto INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE,id_departamento INT NOT NULL,FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento),KEY idx_i_proj_dep(id_departamento)) ENGINE=InnoDB;
CREATE TABLE funcionario_projeto (id_funcionario INT NOT NULL,id_projeto INT NOT NULL,PRIMARY KEY(id_funcionario,id_projeto),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),KEY idx_i_fp_projeto(id_projeto)) ENGINE=InnoDB;
CREATE TABLE gerente_projeto (id_projeto INT NOT NULL,id_funcionario INT NOT NULL,PRIMARY KEY(id_projeto,id_funcionario),FOREIGN KEY (id_projeto) REFERENCES projeto(id_projeto),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),KEY idx_i_gp_func(id_funcionario)) ENGINE=InnoDB;
CREATE TABLE dependente (id_dependente INT AUTO_INCREMENT PRIMARY KEY,id_funcionario INT NOT NULL,nome VARCHAR(120) NOT NULL,parentesco VARCHAR(40),FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario),KEY idx_i_dep_func(id_funcionario)) ENGINE=InnoDB;

-- EXERCICIO J
DROP DATABASE IF EXISTS ex_j_turismo;
CREATE DATABASE ex_j_turismo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_j_turismo;
CREATE TABLE cidade (id_cidade INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,estado VARCHAR(60),pais VARCHAR(60),UNIQUE KEY uk_j_cidade(nome,estado,pais)) ENGINE=InnoDB;
CREATE TABLE tipo_atracao (id_tipo_atracao INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE atracao_turistica (id_atracao INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_tipo_atracao INT NOT NULL,FOREIGN KEY (id_tipo_atracao) REFERENCES tipo_atracao(id_tipo_atracao),KEY idx_j_atr_tipo(id_tipo_atracao)) ENGINE=InnoDB;
CREATE TABLE cidade_atracao (id_cidade INT NOT NULL,id_atracao INT NOT NULL,PRIMARY KEY(id_cidade,id_atracao),FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),FOREIGN KEY (id_atracao) REFERENCES atracao_turistica(id_atracao),KEY idx_j_ca_atr(id_atracao)) ENGINE=InnoDB;
CREATE TABLE classificacao_hotel (id_classificacao_hotel INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE rede_hotel (id_rede_hotel INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE hotel (id_hotel INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_rede_hotel INT,id_classificacao_hotel INT NOT NULL,FOREIGN KEY (id_rede_hotel) REFERENCES rede_hotel(id_rede_hotel),FOREIGN KEY (id_classificacao_hotel) REFERENCES classificacao_hotel(id_classificacao_hotel),KEY idx_j_hotel_rede(id_rede_hotel),KEY idx_j_hotel_class(id_classificacao_hotel)) ENGINE=InnoDB;
CREATE TABLE cidade_hotel (id_cidade INT NOT NULL,id_hotel INT NOT NULL,PRIMARY KEY(id_cidade,id_hotel),FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel),KEY idx_j_ch_hotel(id_hotel)) ENGINE=InnoDB;
CREATE TABLE rede_restaurante (id_rede_restaurante INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE restaurante (id_restaurante INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_rede_restaurante INT,FOREIGN KEY (id_rede_restaurante) REFERENCES rede_restaurante(id_rede_restaurante),KEY idx_j_rest_rede(id_rede_restaurante)) ENGINE=InnoDB;
CREATE TABLE cidade_restaurante (id_cidade INT NOT NULL,id_restaurante INT NOT NULL,PRIMARY KEY(id_cidade,id_restaurante),FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),FOREIGN KEY (id_restaurante) REFERENCES restaurante(id_restaurante),KEY idx_j_cr_rest(id_restaurante)) ENGINE=InnoDB;
CREATE TABLE cliente (id_cliente INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,cpf VARCHAR(14) NOT NULL UNIQUE,email VARCHAR(180)) ENGINE=InnoDB;
CREATE TABLE viagem (id_viagem INT AUTO_INCREMENT PRIMARY KEY,id_cliente INT NOT NULL,id_cidade INT NOT NULL,data_ida DATE NOT NULL,data_volta DATE,FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),KEY idx_j_viagem_cli(id_cliente),KEY idx_j_viagem_cid(id_cidade)) ENGINE=InnoDB;

-- EXERCICIO K
DROP DATABASE IF EXISTS ex_k_detran;
CREATE DATABASE ex_k_detran CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_k_detran;
CREATE TABLE tipo_veiculo (id_tipo_veiculo INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE fabricante (id_fabricante INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE modelo_veiculo (id_modelo_veiculo INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(80) NOT NULL,id_fabricante INT NOT NULL,id_tipo_veiculo INT NOT NULL,FOREIGN KEY (id_fabricante) REFERENCES fabricante(id_fabricante),FOREIGN KEY (id_tipo_veiculo) REFERENCES tipo_veiculo(id_tipo_veiculo),KEY idx_k_mod_fab(id_fabricante),KEY idx_k_mod_tipo(id_tipo_veiculo)) ENGINE=InnoDB;
CREATE TABLE motorista (id_motorista INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,cnh VARCHAR(20) NOT NULL UNIQUE,cpf VARCHAR(14) UNIQUE) ENGINE=InnoDB;
CREATE TABLE veiculo (id_veiculo INT AUTO_INCREMENT PRIMARY KEY,placa VARCHAR(10) NOT NULL UNIQUE,id_modelo_veiculo INT NOT NULL,id_motorista INT NOT NULL,FOREIGN KEY (id_modelo_veiculo) REFERENCES modelo_veiculo(id_modelo_veiculo),FOREIGN KEY (id_motorista) REFERENCES motorista(id_motorista),KEY idx_k_vei_mod(id_modelo_veiculo),KEY idx_k_vei_mot(id_motorista)) ENGINE=InnoDB;
CREATE TABLE agente_transito (id_agente_transito INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,matricula VARCHAR(30) UNIQUE) ENGINE=InnoDB;
CREATE TABLE origem_infracao (id_origem_infracao INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(20) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE infracao (id_infracao INT AUTO_INCREMENT PRIMARY KEY,id_motorista INT NOT NULL,id_veiculo INT NOT NULL,id_origem_infracao INT NOT NULL,id_agente_transito INT,data_infracao DATETIME NOT NULL,descricao VARCHAR(255) NOT NULL,FOREIGN KEY (id_motorista) REFERENCES motorista(id_motorista),FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),FOREIGN KEY (id_origem_infracao) REFERENCES origem_infracao(id_origem_infracao),FOREIGN KEY (id_agente_transito) REFERENCES agente_transito(id_agente_transito),KEY idx_k_inf_mot(id_motorista),KEY idx_k_inf_vei(id_veiculo),KEY idx_k_inf_ori(id_origem_infracao),KEY idx_k_inf_age(id_agente_transito)) ENGINE=InnoDB;

-- EXERCICIO L
DROP DATABASE IF EXISTS ex_l_condominios;
CREATE DATABASE ex_l_condominios CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_l_condominios;
CREATE TABLE cidade (id_cidade INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,estado VARCHAR(60),UNIQUE KEY uk_l_cidade(nome,estado)) ENGINE=InnoDB;
CREATE TABLE condominio (id_condominio INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,id_cidade INT NOT NULL,FOREIGN KEY (id_cidade) REFERENCES cidade(id_cidade),KEY idx_l_cond_cid(id_cidade)) ENGINE=InnoDB;
CREATE TABLE bloco (id_bloco INT AUTO_INCREMENT PRIMARY KEY,id_condominio INT NOT NULL,identificacao VARCHAR(30) NOT NULL,FOREIGN KEY (id_condominio) REFERENCES condominio(id_condominio),KEY idx_l_bloco_cond(id_condominio)) ENGINE=InnoDB;
CREATE TABLE unidade (id_unidade INT AUTO_INCREMENT PRIMARY KEY,id_bloco INT NOT NULL,numero VARCHAR(20) NOT NULL,FOREIGN KEY (id_bloco) REFERENCES bloco(id_bloco),KEY idx_l_unidade_bloco(id_bloco)) ENGINE=InnoDB;
CREATE TABLE pessoa (id_pessoa INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,cpf VARCHAR(14) UNIQUE) ENGINE=InnoDB;
CREATE TABLE unidade_proprietario (id_unidade INT NOT NULL,id_pessoa INT NOT NULL,percentual_propriedade DECIMAL(5,2),PRIMARY KEY(id_unidade,id_pessoa),FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),KEY idx_l_up_pessoa(id_pessoa)) ENGINE=InnoDB;
CREATE TABLE locacao (id_locacao INT AUTO_INCREMENT PRIMARY KEY,id_unidade INT NOT NULL,id_locatario INT NOT NULL,data_inicio DATE NOT NULL,data_fim DATE,FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),FOREIGN KEY (id_locatario) REFERENCES pessoa(id_pessoa),UNIQUE KEY uk_l_loc_unidade_ativa(id_unidade,data_inicio),KEY idx_l_loc_pessoa(id_locatario)) ENGINE=InnoDB;
CREATE TABLE morador_unidade (id_unidade INT NOT NULL,id_pessoa INT NOT NULL,PRIMARY KEY(id_unidade,id_pessoa),FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade),FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),KEY idx_l_mu_pessoa(id_pessoa)) ENGINE=InnoDB;

-- EXERCICIO M
DROP DATABASE IF EXISTS ex_m_biblioteca;
CREATE DATABASE ex_m_biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ex_m_biblioteca;
CREATE TABLE autor (id_autor INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL) ENGINE=InnoDB;
CREATE TABLE genero (id_genero INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE tipo_livro (id_tipo_livro INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(60) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE area_conhecimento (id_area_conhecimento INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(80) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE editora (id_editora INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL UNIQUE) ENGINE=InnoDB;
CREATE TABLE livro (id_livro INT AUTO_INCREMENT PRIMARY KEY,titulo VARCHAR(180) NOT NULL,id_genero INT NOT NULL,id_tipo_livro INT NOT NULL,id_area_conhecimento INT NOT NULL,id_editora INT NOT NULL,FOREIGN KEY (id_genero) REFERENCES genero(id_genero),FOREIGN KEY (id_tipo_livro) REFERENCES tipo_livro(id_tipo_livro),FOREIGN KEY (id_area_conhecimento) REFERENCES area_conhecimento(id_area_conhecimento),FOREIGN KEY (id_editora) REFERENCES editora(id_editora),KEY idx_m_livro_gen(id_genero),KEY idx_m_livro_tipo(id_tipo_livro),KEY idx_m_livro_area(id_area_conhecimento),KEY idx_m_livro_edit(id_editora)) ENGINE=InnoDB;
CREATE TABLE livro_autor (id_livro INT NOT NULL,id_autor INT NOT NULL,PRIMARY KEY(id_livro,id_autor),FOREIGN KEY (id_livro) REFERENCES livro(id_livro),FOREIGN KEY (id_autor) REFERENCES autor(id_autor),KEY idx_m_la_autor(id_autor)) ENGINE=InnoDB;
CREATE TABLE exemplar (id_exemplar INT AUTO_INCREMENT PRIMARY KEY,id_livro INT NOT NULL,codigo_tombo VARCHAR(40) NOT NULL UNIQUE,id_status_exemplar INT NOT NULL,FOREIGN KEY (id_livro) REFERENCES livro(id_livro),KEY idx_m_ex_livro(id_livro)) ENGINE=InnoDB;
CREATE TABLE status_exemplar (id_status_exemplar INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(30) NOT NULL UNIQUE) ENGINE=InnoDB;
ALTER TABLE exemplar ADD CONSTRAINT fk_exemplar_status FOREIGN KEY (id_status_exemplar) REFERENCES status_exemplar(id_status_exemplar), ADD KEY idx_m_ex_status(id_status_exemplar);
CREATE TABLE cliente (id_cliente INT AUTO_INCREMENT PRIMARY KEY,nome VARCHAR(120) NOT NULL,cpf VARCHAR(14) NOT NULL UNIQUE,email VARCHAR(180)) ENGINE=InnoDB;
CREATE TABLE locacao (id_locacao INT AUTO_INCREMENT PRIMARY KEY,id_cliente INT NOT NULL,data_locacao DATE NOT NULL,data_prevista_devolucao DATE NOT NULL,data_devolucao DATE,FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),KEY idx_m_loc_cliente(id_cliente)) ENGINE=InnoDB;
CREATE TABLE locacao_item (id_locacao INT NOT NULL,id_exemplar INT NOT NULL,PRIMARY KEY(id_locacao,id_exemplar),FOREIGN KEY (id_locacao) REFERENCES locacao(id_locacao),FOREIGN KEY (id_exemplar) REFERENCES exemplar(id_exemplar),KEY idx_m_li_ex(id_exemplar)) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
