:- [list_persistence].

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).

% URL handlers.
:- http_handler('/', handle_request_default, []).
:- http_handler('/register-patient', handle_patient_registration, []).
:- http_handler('/get-patients/arrival-order', handle_list_sort_by_arrival, []).
:- http_handler('/get-patients/manchester-order', handle_list_sort_by_manchester, []).
:- http_handler('/get-patients/relative-order', handle_list_sort_by_relative_priority, []).
:- http_handler('/call-patient', handle_call_patient, []).

%.
% COMPUTATION FUNCTIONS .
%.

hello_world(_{message: N}) :-
    N = "hello world!".

%.
% REQUEST HANDLERS.
%.

% GET Request
% Apenas um request que não é utilizado, serve apenas para checar se o servidor esta online
handle_request_default(_Request) :-
    hello_world(Response), % logic to be processed.
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(Response).


% POST/OPTIONS Request
% Recebe a requisicao de cadastro de paciente na lista de espera
% Eh recebido um dicionario que eh processado pela funcao insert_patient_to_queue
% Em seguida eh atualizado as prioridades relativas de todos da lista
% Utilizando a funcao update_relative_priority
% No corpo da requisicao eh enviado tambem os dados de CORS
handle_patient_registration(Request) :-
    option(method(options), Request), !,
      cors_enable(Request,
                  [ methods([get,post,delete,options])]),
    format('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Origin~n'),
    cors_enable,
    format('~n~n')
    
    ; http_read_json_dict(Request, Query),
    insert_patient_to_queue(Query),
    update_relative_priority(UpdateStatus),
    cors_enable(Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(_{status: "Ok"}).
    
% GET Request
% Recebe a requisicao GET e em seguida ordena a lista de espera de acordo com a ordem de chegada
% E em seguida responde com um JSON da lista atualizada
handle_list_sort_by_arrival(_Request) :-
    sort_patients_by(arrival_time),
    get_patient_list(PatientsList),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(PatientsList).

% GET Request
% Recebe a requisicao GET e em seguida ordena a lista de espera de acordo com a prioridade do protocolo de manchester
% E em seguida responde com um JSON da lista atualizada
handle_list_sort_by_manchester(_Request) :-
    sort_patients_by(manchester_priority),
    get_patient_list(PatientsList),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(PatientsList).

% GET Request
% Recebe a requisicao GET e em seguida ordena a lista de espera de acordo com a prioridade relativa
% E em seguida responde com um JSON da lista atualizada
handle_list_sort_by_relative_priority(_Request) :-
    sort_patients_by(relative_priority),
    get_patient_list(PatientsList),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(PatientsList).

% GET Request
% Recebe a requisicao GET e em seguida retira o proximo paciente a ser chamado da lista de espera
% E em seguida retorna um JSON com os dados do paciente chamado
handle_call_patient(_Request) :-
    call_next_patient(Patient),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(Patient).


% Define a porta a ser utilizada do servidor HTTP
server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Define o header Allow Origin para ser o localhost:3000 para fins de nao ter problemas com CORS
:- set_setting(http:cors, ['http://localhost:3000\n']).


% Define mais tipos de aceitacao para reconhecimento de arquivos JSON
:- multifile http_json/1.

http_json:json_type('application/x-javascript').
http_json:json_type('text/javascript').
http_json:json_type('a/b').
http_json:json_type('text/x-json').