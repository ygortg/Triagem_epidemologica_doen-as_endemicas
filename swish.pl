% ====================================================================
% SISTEMA ESPECIALISTA SUS - TRIAGEM EPIDEMIOLÓGICA
% ====================================================================

% 1. DECLARAÇÃO DE FATOS DINÂMICOS
% Permite que o sistema aprenda durante a execução gravando as respostas do usuário.
:- dynamic sim/1.
:- dynamic nao/1.

% 2. MOTOR DE INFERÊNCIA E REGRAS DE DIAGNÓSTICO (Encadeamento para trás)
% Sugestão para alcançar as 20 regras mínimas: desmembrar sintomas e níveis de gravidade.

hipotese(dengue_classica) :-
    verifica(febre_alta),
    verifica(dor_atras_dos_olhos),
    verifica(dor_de_cabeca),
    verifica(dor_muscular_intensa).

hipotese(chikungunya) :-
    verifica(febre_alta_subita),
    verifica(dor_intensa_nas_articulacoes),
    verifica(inchaco_nas_articulacoes).

hipotese(zika) :-
    verifica(febre_baixa_ou_ausente),
    verifica(manchas_vermelhas_com_coceira),
    verifica(olhos_vermelhos_sem_secrecao).

% Tratamento de Exceção: Regra ativada caso nenhuma das anteriores seja satisfeita
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


% 5. MÓDULO DE EXPLICAÇÃO (Como / Por que)
explicar(dengue_classica) :- 
    nl, write('JUSTIFICATIVA (Como o sistema chegou a essa conclusao):'), nl,
    write('- Fatos confirmados: O paciente relatou febre alta, dor retro-orbital, dor de cabeca e mialgia intensa.'), nl,
    write('- Regra aplicada: Estes sintomas combinados fecham o protocolo primario de suspeita de Dengue Classica.').

explicar(chikungunya) :- 
    nl, write('JUSTIFICATIVA (Como o sistema chegou a essa conclusao):'), nl,
    write('- Fatos confirmados: O paciente relatou febre alta subita associada a forte dor e inchaco articular.'), nl,
    write('- Regra aplicada: O comprometimento articular agudo e o principal diferencial da Chikungunya.').

explicar(zika) :- 
    nl, write('JUSTIFICATIVA (Como o sistema chegou a essa conclusao):'), nl,
    write('- Fatos confirmados: Ausencia de febre alta, presenca de exantema pruriginoso (manchas com coceira) e conjuntivite.'), nl,
    write('- Regra aplicada: Sintomas brandos com forte presenca de manchas e olhos vermelhos indicam Zika virus.').

% Limpeza da memória para nova consulta
limpar_fatos :- 
    retractall(sim(_)), 
    retractall(nao(_)).