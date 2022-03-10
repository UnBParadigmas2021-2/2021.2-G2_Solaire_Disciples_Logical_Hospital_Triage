:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(dicts)).

insert_patient_to_queue({nome:N}) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    append(DictIn.queue, [_{nome:N}], PatientList),
    DictOut = DictIn.put(queue, PatientList),
    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.


initialize_json :-
    FPath = 'patients.json',
    tell(FPath),
    json_write_dict(current_output, _{queue:[]}, [null('')]),
    told.
