:- use_module(library(dialect/sicstus/system)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(dicts)).

:- [triage_category].

% Recebe JSON com os dados do paciente e insere paciente no arquivo patients.json que contem a lista de espera
insert_patient_to_queue(_{
    nome:N,
    bad_breathing:BadBreathing,
    bleeding_level:BleedingLevel,
    shock_state: ShockState,
    is_convulsioning: Convulsioning,
    pain_level:PainLevel,
    unconscious:Unconscious,
    body_temperature:BodyTemperature,
    unconscious_history: UnconsciousHistory,
    age: Age,
    minor_recent_problem: MinorRecentProblem
    }) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn), % Abre o arquivo patients.json para leitura
    json_read_dict(StreamIn, DictIn), % Realiza o parsing do JSON aberto
    close(StreamIn),
    now(T), % Pega a data/hora atual em formato epoch UNIX
    get_manchester_priority(
         Age,
         BadBreathing,
         BleedingLevel,
         ShockState,
         Convulsioning,
         PainLevel,
         Unconscious,
         BodyTemperature,
         UnconsciousHistory,
         MinorRecentProblem,
         ManchesterPriority
    ), % Envia os dados do paciente para a funcao que ira avaliar qual a sua prioridade
    % Insere o paciente atual na lista de espera
    append(DictIn.queue, [_{nome:N, manchester_priority: ManchesterPriority, arrival_time:T, relative_priority: ManchesterPriority}], PatientList),
    DictOut = DictIn.put(queue, PatientList), % Atualiza o dicionario atual com os dados do novo paciente
    tell(FPath), % Informa o current_output
    json_write_dict(current_output, DictOut, [null('')]), % Escreve o JSON atualizado no current_output (patients.json)
    told. % Informa que o current_output ja foi utilizado


% Inicializa um json novo em patients.json
initialize_json :-
    FPath = 'patients.json',
    tell(FPath),
    json_write_dict(current_output, _{queue:[]}, [null('')]),
    told.

% Ordena os pacientes de acordo com a key definida e salva em patients.json
sort_patients_by(Key) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn), % Abre o arquivo patients.json para leitura
    json_read_dict(StreamIn, DictIn),  % Realiza o parsing do JSON aberto
    close(StreamIn),
    sort(Key, @=<, DictIn.queue, SortedList), % Realiza a ordenacao de acordo com a key
    DictOut = DictIn.put(queue, SortedList), % Atualiza o dicionario ordenado
    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]), % Escreve o dicionario atualizado em patients.json
    told.

% Le a lista de pacientes e retorna o dicionario a ser enviado como resposta do servidor
get_patient_list(PatientsList) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    PatientsList = DictIn.

% Le a lista de pacientes e retira o primeiro da lista.
call_next_patient(Patient) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),

    select(Patient, DictIn.queue, ResultList), % Retira o primeiro elemento da lista
    DictOut = DictIn.put(queue, ResultList),

    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.

% Atualiza a prioridade relativa dos itens da lista de espera
update_relative_priority(UpdateStatus) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    update_item_priority(DictIn.queue, []),
    UpdateStatus = "Ok".
    
% Atualiza a prioridade relativa do item atual
update_item_priority([], UpdatedList) :- 
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    DictOut = DictIn.put(queue, UpdatedList),

    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.

% Funcao recursiva que atualiza a prioridade relativa do item atual e chama ela mesma para realizar a atualizacao de dados em todos os elementos da lista
update_item_priority([H|T], UpdatedList) :-
    RelativePriority is H.relative_priority - ((1/H.manchester_priority) * 0.1), % Calculo da prioridade relativa
    UpdatedValue = H.put(relative_priority, RelativePriority),
    append(UpdatedList, [UpdatedValue], NewUpdatedList),
    update_item_priority(T, NewUpdatedList).