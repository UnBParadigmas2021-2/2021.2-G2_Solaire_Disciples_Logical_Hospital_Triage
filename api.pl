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
handle_request_default(_Request) :-
    hello_world(Response), % logic to be processed.
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(Response).


% POST Request
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
handle_list_sort_by_arrival(_Request) :-
    sort_patients_by(arrival_time),
    get_patient_list(PatientsList),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(PatientsList).

% GET Request
handle_list_sort_by_manchester(_Request) :-
    sort_patients_by(manchester_priority),
    get_patient_list(PatientsList),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(PatientsList).

handle_list_sort_by_relative_priority(_Request) :-
    sort_patients_by(relative_priority),
    get_patient_list(PatientsList),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(PatientsList).

% GET Request
handle_call_patient(_Request) :-
    call_next_patient(Patient),
    cors_enable(_Request,[methods([get,post,delete])]),
    format('Access-Control-Allow-Credentials:true'),
    format('~n'),
    cors_enable,
    reply_json_dict(Patient).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% :- set_setting(http:cors, ['http://localhost:3000\n']).
:- set_setting(http:cors, ['http://localhost:3000\n']).

:- multifile http_json/1.

http_json:json_type('application/x-javascript').
http_json:json_type('text/javascript').
http_json:json_type('a/b').
http_json:json_type('text/x-json').