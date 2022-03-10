:- use_module(library(dialect/sicstus/system)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(dicts)).

insert_patient_to_queue(_{nome:N}) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    now(T),
    append(DictIn.queue, [_{nome:N, arrival_time:T}], PatientList),
    DictOut = DictIn.put(queue, PatientList),
    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.


initialize_json :-
    FPath = 'patients.json',
    tell(FPath),
    json_write_dict(current_output, _{queue:[]}, [null('')]),
    told.


sort_patients_by(Key) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    sort(Key, @=<, DictIn.queue, SortedList),
    DictOut = DictIn.put(queue, SortedList),
    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.

get_patient_list(PatientsList) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    PatientsList = DictIn.
