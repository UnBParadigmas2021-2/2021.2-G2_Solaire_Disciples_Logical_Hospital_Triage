:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(dicts)).

insert_patient_to_queue({nome:N}) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    write("PatientList: "),
    write(PatientList), nl,
    write("DictIn: "),
    write(DictIn), nl,
    
    
    append(DictIn.queue, [_{nome:N}], PatientList),
    
    
    write("JsonPatient: "),
    write(Patient), nl,
    write("DictIn: "),
    write(DictIn), nl,
    write("Patient: "),
    write(Patient), nl,
    write("PatientList: "),
    write(PatientList), nl,
    write("DictIn.queue: "),
    write(DictIn.queue), nl,
    
    
    DictOut = DictIn.put(queue, PatientList),
    
    
    write("DictOut: "),
    write(DictOut),nl,
    write("DictIn.queue: "),
    write(DictIn.queue), nl,
    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.

    
