:- [list_persistence].

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).

% URL handlers.
:- http_handler('/', handle_request_default, []).
:- http_handler('/register-patient', handle_patient_registration, []).
:- http_handler('/get-patients/arrival-order', handle_list_by_arrival, []).
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
    reply_json_dict(Response).

% POST Request
handle_patient_registration(Request) :-
    http_read_json_dict(Request, Query),
    insert_patient_to_queue(Query),
    reply_json_dict(_{status: "Ok"}).

% GET Request
handle_list_by_arrival(_Request) :-
    sort_patients_by(arrival_time),
    get_patient_list(PatientsList),
    reply_json_dict(PatientsList).

% GET Request
handle_call_patient(_Request) :-
    call_next_patient(Patient),
    reply_json_dict(Patient).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).


