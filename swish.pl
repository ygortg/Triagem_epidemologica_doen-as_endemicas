% ====================================================================
% SISTEMA ESPECIALISTA SUS - TRIAGEM EPIDEMIOLÓGICA
% ====================================================================

% 1. DECLARAÇÃO DE FATOS DINÂMICOS
% Permite que o sistema aprenda durante a execução gravando as respostas do usuário.
:- dynamic sim/1.
:- dynamic nao/1.

% 2. MOTOR DE INFERÊNCIA E REGRAS DE DIAGNÓSTICO (Encadeamento para trás)
% Sugestão para alcançar as 20 regras mínimas: desmembrar sintomas e níveis de gravidade.

% Bloco 1: Dengue e as suas variações de gravidade
hipotese(dengue_grave) :-
    verifica(febre_alta),
    verifica(dor_atras_dos_olhos),
    verifica(sangramento_nas_gengivas_ou_nariz),
    verifica(dor_abdominal_intensa).

hipotese(dengue_com_sinais_de_alarme) :-
    verifica(febre_alta),
    verifica(dor_muscular_intensa),
    verifica(vomitos_persistentes).

hipotese(dengue_classica) :-
    verifica(febre_alta),
    verifica(dor_atras_dos_olhos),
    verifica(dor_de_cabeca),
    verifica(dor_muscular_intensa).

% Bloco 2: Chikungunya e Zika
hipotese(chikungunya_aguda) :-
    verifica(febre_alta_subita),
    verifica(dor_intensa_nas_articulacoes),
    verifica(inchaco_nas_articulacoes).

hipotese(zika_gestante) :-
    verifica(febre_baixa_ou_ausente),
    verifica(manchas_vermelhas_com_coceira),
    verifica(paciente_gestante).

hipotese(zika_comum) :-
    verifica(febre_baixa_ou_ausente),
    verifica(manchas_vermelhas_com_coceira),
    verifica(olhos_vermelhos_sem_secrecao).

% Bloco 3: Doenças Respiratórias
hipotese(covid_grave) :-
    verifica(febre_alta),
    verifica(tosse_seca),
    verifica(falta_de_ar_grave),
    verifica(saturacao_baixa).

hipotese(covid_leve_moderada) :-
    verifica(febre_baixa_ou_ausente),
    verifica(tosse_seca),
    verifica(perda_de_olfato_ou_paladar).

hipotese(gripe_comum) :-
    verifica(febre_alta),
    verifica(tosse_com_catarro),
    verifica(dor_de_garganta),
    verifica(coriza).

% Bloco 4: Outras Endemias (Leptospirose e Febre Amarela)
hipotese(leptospirose_grave) :-
    verifica(febre_alta),
    verifica(dor_nas_panturrilhas),
    verifica(pele_e_olhos_amarelados).

hipotese(leptospirose_fase_inicial) :-
    verifica(febre_alta),
    verifica(dor_nas_panturrilhas),
    verifica(contacto_com_agua_de_enchentes).

hipotese(febre_amarela) :-
    verifica(febre_alta),
    verifica(calafrios),
    verifica(pele_e_olhos_amarelados),
    verifica(sangramento_nas_gengivas_ou_nariz).

% Tratamento de Exceção (Fallback)
hipotese(desconhecido).

% 3. INTERFACE DE INTERAÇÃO COM O USUÁRIO (Console/Terminal)
% Verifica se o sintoma já foi perguntado. Se não, pergunta ao usuário.
verifica(S) :-
   (sim(S) -> true ;
   (nao(S) -> fail ;
   perguntar(S))).

perguntar(S) :-
    format('O paciente apresenta o sintoma ~w? (s/n): ', [S]),
    read(Resposta),
    (Resposta == s -> assert(sim(S)) ;
    assert(nao(S)), fail).


% 4. FLUXO PRINCIPAL DO PROGRAMA
iniciar :-
    write('======================================================'), nl,
    write('   SISTEMA DE TRIAGEM EPIDEMIOLOGICA - SUS (PROLOG)   '), nl,
    write('======================================================'), nl,
    write('Responda com "s." para sim e "n." para nao (nao esqueca o ponto final!).'), nl, nl,
    limpar_fatos,
    hipotese(Doenca),
    mostrar_resultado(Doenca),
    limpar_fatos.

% Tratamento de saídas e exceções
mostrar_resultado(desconhecido) :-
    write('RESULTADO: Nao foi possivel concluir o diagnostico com as informacoes fornecidas.'), nl,
    write('RECOMENDACAO: Encaminhar para avaliacao medica detalhada.').

mostrar_resultado(Doenca) :-
    format('RESULTADO PRELIMINAR: O quadro sugere ~w.', [Doenca]), nl,
    explicar(Doenca).


% ====================================================================
% 5. MÓDULO DE EXPLICAÇÃO (Obrigatório para justificação)
% ====================================================================

explicar(dengue_grave) :- 
    nl, write('JUSTIFICATIVA:'), nl,
    write('- Factos: Presenca de febre associada a sinais de choque (dor abdominal intensa e hemorragia).'), nl,
    write('- Regra: O quadro evoluiu para Dengue Grave, exigindo internamento imediato.').

explicar(dengue_com_sinais_de_alarme) :- 
    nl, write('JUSTIFICATIVA:'), nl,
    write('- Factos: Febre e dor muscular associadas a vomitos persistentes.'), nl,
    write('- Regra: O vomito persistente altera a classificacao para risco moderado/alto.').

explicar(dengue_classica) :- 
    nl, write('JUSTIFICATIVA:'), nl,
    write('- Factos: Febre alta, dor retro-orbital e dor muscular intensa (mialgia).'), nl,
    write('- Regra: Sintomatologia padrao e clássica de infecao por Dengue sem complicacoes.').

explicar(zika_gestante) :- 
    nl, write('JUSTIFICATIVA:'), nl,
    write('- Factos: Sintomas brandos de Zika associados ao estado de gravidez.'), nl,
    write('- Regra: A combinacao ativa o protocolo de alerta maximo para risco de microcefalia fetal.').

explicar(covid_grave) :- 
    nl, write('JUSTIFICATIVA:'), nl,
    write('- Factos: Sintomas respiratorios associados a dispneia (falta de ar) e hipoxia.'), nl,
    write('- Regra: O comprometimento pulmonar severo indica COVID-19 em estagio grave.').

explicar(leptospirose_fase_inicial) :- 
    nl, write('JUSTIFICATIVA:'), nl,
    write('- Factos: Febre e mialgia severa nas panturrilhas, com historico epidemiologico de enchentes.'), nl,
    write('- Regra: O contacto com agua contaminada e a dor na panturrilha sao marcadores clinicos primarios.').

% Limpeza da memória para nova consulta
limpar_fatos :- 
    retractall(sim(_)), 
    retractall(nao(_)).