:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).

% URL handlers.
:- http_handler('/add', handle_request_add, []).
:- http_handler('/sub', handle_request_sub, []).
:- http_handler('/', handle_request_default, []).

%.
% COMPUTATION FUNCTIONS .
%.
% Calculates a - b.
solve_sub(_{a:X, b:Y}, _{answer:N}) :-
    number(X),
    number(Y),
    N is X - Y.

% Calculates a + b.
solve_add(_{a:X, b:Y}, _{answer:N}) :-
    number(X),
    number(Y),
    N is X + Y.

hello_world(_{message: N}) :-
    N = "hello world!".

%.
% REQUEST HANDLERS.
%.

handle_request_default(_Request) :-
    hello_world(Response), % logic to be processed.
    reply_json_dict(Response).


handle_request_sub(Request) :-
    http_read_json_dict(Request, Query),
    solve_sub(Query, Solution), % logic to be processed.
    reply_json_dict(Solution).


handle_request_add(Request) :-
    http_read_json_dict(Request, Query),
    solve_add(Query, Solution), % logic to be processed.
    reply_json_dict(Solution).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).


