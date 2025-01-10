-- Convertido para PostgreSQL 14
DROP TABLE fato_desempenho_vendas;
DROP TABLE fato_capacitacao;
DROP TABLE dim_treinamento;
DROP TABLE dim_tempo;
DROP TABLE dim_produto_servico;
DROP TABLE dim_objeto_aprendizado;
DROP TABLE dim_loja;
DROP TABLE dim_colaborador;

CREATE TABLE dim_colaborador (
    sk_colaborador        SERIAL NOT NULL,
    ldap                  VARCHAR(50),
    nm_colaborador        VARCHAR(50),
    cargo                 VARCHAR(100),
    loja_assessor         VARCHAR(100),
    grau_instrucao        VARCHAR(50),
    idade                 SMALLINT,
    situacao_colaborador  VARCHAR(50),
    dt_admissao           DATE,
    nm_diretoria          VARCHAR(100),
    nm_area_rh            VARCHAR(100),
    nm_posicao            VARCHAR(100),
    dt_nascimento         DATE,
    nm_area_folha         VARCHAR(100),
    nm_estado_civil       VARCHAR(50),
    nm_nacionalidade      VARCHAR(50),
    nm_genero             VARCHAR(20),
    nr_ldap               BIGINT,
    st_ocupacao           VARCHAR(10),
    nm_grau_instrucao     VARCHAR(50),
    nm_motivo_afastamento VARCHAR(50),
    dt_inicio_afastamento DATE,
    dt_fim_afastamento    DATE,
    nr_tempo_casa         NUMERIC(5, 2),
    nr_tempo_missao       NUMERIC(5, 2),
    dim_colaborador_id    BIGSERIAL PRIMARY KEY
);

ALTER TABLE dim_colaborador ADD CONSTRAINT dim_colaborador_pk UNIQUE (sk_colaborador);

ALTER TABLE dim_colaborador ADD CONSTRAINT unique_ldap UNIQUE (ldap); 

CREATE TABLE dim_loja (
    sk_loja      INTEGER PRIMARY KEY,
    nm_loja      VARCHAR(50),
    centro_custo VARCHAR(50)
);

CREATE TABLE dim_objeto_aprendizado (
    sk_objeto_aprendizado INTEGER PRIMARY KEY,
    nm_titulo             VARCHAR(50) NOT NULL,
    tp_objeto             VARCHAR(50),
    nr_tempo_duracao      SMALLINT,
    nm_nivel_complexidade VARCHAR(10)
);

COMMENT ON COLUMN dim_objeto_aprendizado.tp_objeto IS 'eg. Video, Quiz, eBook';

CREATE TABLE dim_produto_servico (
    sk_produto_servico INTEGER PRIMARY KEY,
    tp_venda           VARCHAR(50),
    nm_categoria       VARCHAR(100) NOT NULL
);

COMMENT ON COLUMN dim_produto_servico.tp_venda IS 'Tipo de venda (produto, serviço, solução)';
COMMENT ON COLUMN dim_produto_servico.nm_categoria IS '-- Categoria do produto/serviço';

CREATE TABLE dim_tempo (
    sk_tempo      INTEGER PRIMARY KEY,
    dt_data       DATE NOT NULL,
    nr_dia        SMALLINT,
    nr_mes        SMALLINT,
    nr_ano        SMALLINT,
    ct_feriado    CHAR(1),
    nr_trimestre  SMALLINT,
    nr_semestre   SMALLINT,
    nm_dia_semana VARCHAR(20),
    ct_fim_semana CHAR(1)
);

CREATE TABLE dim_treinamento (
    sk_treinamento    INTEGER PRIMARY KEY,
    nm_treinamento    VARCHAR(255) NOT NULL,
    tp_treinamento    VARCHAR(50) NOT NULL,
    nm_categoria      VARCHAR(100) NOT NULL,
    nr_horas          SMALLINT,
    nivel_dificuldade VARCHAR(50) NOT NULL
);

COMMENT ON COLUMN dim_treinamento.nm_categoria IS 'Vendas, soft skills, etc.';
COMMENT ON COLUMN dim_treinamento.nivel_dificuldade IS '-- Básico, intermediário, avançado';

CREATE TABLE fato_capacitacao (
    sk_capacitacao           INTEGER UNIQUE NOT NULL,
    sk_tempo                 INTEGER NOT NULL,
    sk_colaborador           INTEGER NOT NULL,
    sk_objeto_aprendizado    INTEGER NOT NULL,
    sk_treinamento           INTEGER NOT NULL,
    vl_nota_quiz             NUMERIC(9, 2),
    vl_avaliacao_treinamento INTEGER,
    nr_tempo_gasto           INTEGER,
    vl_taxa_engajamento      INTEGER,
    grau_instrucao           VARCHAR(50),
    fato_capacitacao_id      BIGSERIAL PRIMARY KEY
);

CREATE TABLE fato_desempenho_vendas (
    sk_fato_venda                      INTEGER PRIMARY KEY,
    sk_produto_servico                 INTEGER NOT NULL,
    sk_loja                            INTEGER NOT NULL,
    sk_colaborador                     INTEGER NOT NULL,
    sk_data_venda                      INTEGER NOT NULL,
    vl_total_faturada                  NUMERIC(9, 2) NOT NULL,
    vl_solucao_faturada                NUMERIC(9, 2),
    vl_produto_faturada                NUMERIC(9, 2),
    vl_pedidos_totais_pagos            NUMERIC(9, 2),
    vl_perc_efetividade_venda_servicos NUMERIC(9, 2),
    rk_lmb                             SMALLINT,
    rk_loja                            SMALLINT,
    rk_dp                              SMALLINT
);

COMMENT ON COLUMN fato_desempenho_vendas.vl_perc_efetividade_venda_servicos IS 'Taxa de conversão de serviços';
COMMENT ON COLUMN fato_desempenho_vendas.rk_lmb IS 'Ranking na Leroy Merlin Brasil';
COMMENT ON COLUMN fato_desempenho_vendas.rk_loja IS 'Ranking na loja';
COMMENT ON COLUMN fato_desempenho_vendas.rk_dp IS 'Ranking no departamento';

-- Foreign keys
ALTER TABLE fato_capacitacao
    ADD CONSTRAINT fk_colaborador_capacitacao FOREIGN KEY (sk_colaborador)
    REFERENCES dim_colaborador (sk_colaborador);

ALTER TABLE fato_desempenho_vendas
    ADD CONSTRAINT fk_colaborador_fato_venda FOREIGN KEY (sk_colaborador)
    REFERENCES dim_colaborador (sk_colaborador);

ALTER TABLE fato_desempenho_vendas
    ADD CONSTRAINT fk_loja_fato_venda FOREIGN KEY (sk_loja)
    REFERENCES dim_loja (sk_loja);

ALTER TABLE fato_capacitacao
    ADD CONSTRAINT fk_objaprendizado_fato FOREIGN KEY (sk_objeto_aprendizado)
    REFERENCES dim_objeto_aprendizado (sk_objeto_aprendizado);

ALTER TABLE fato_desempenho_vendas
    ADD CONSTRAINT fk_produtoservico_fatovenda FOREIGN KEY (sk_produto_servico)
    REFERENCES dim_produto_servico (sk_produto_servico);

ALTER TABLE fato_capacitacao
    ADD CONSTRAINT fk_tempo_capacitacao_dtquiz FOREIGN KEY (sk_tempo)
    REFERENCES dim_tempo (sk_tempo);

ALTER TABLE fato_desempenho_vendas
    ADD CONSTRAINT fk_tempo_fato_venda FOREIGN KEY (sk_data_venda)
    REFERENCES dim_tempo (sk_tempo);

ALTER TABLE fato_capacitacao
    ADD CONSTRAINT fk_treinamento_fato_capacitacao FOREIGN KEY (sk_treinamento)
    REFERENCES dim_treinamento (sk_treinamento);