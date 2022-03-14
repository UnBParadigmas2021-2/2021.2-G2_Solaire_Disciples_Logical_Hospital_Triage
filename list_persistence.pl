:- use_module(library(dialect/sicstus/system)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(dicts)).

:- [triage_category].

insert_patient_to_queue(_{nome:N,
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
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    now(T),
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
    ),
    append(DictIn.queue, [_{nome:N, manchester_priority: ManchesterPriority, arrival_time:T, relative_priority: ManchesterPriority}], PatientList),
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

call_next_patient(Patient) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),

    select(Patient, DictIn.queue, ResultList),
    DictOut = DictIn.put(queue, ResultList),

    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.


update_relative_priority(UpdateStatus) :-
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    update_item_priority(DictIn.queue, []),
    UpdateStatus = "Ok".
    

update_item_priority([], UpdatedList) :- 
    FPath = 'patients.json',
    open(FPath, read, StreamIn),
    json_read_dict(StreamIn, DictIn),
    close(StreamIn),
    DictOut = DictIn.put(queue, UpdatedList),

    tell(FPath),
    json_write_dict(current_output, DictOut, [null('')]),
    told.

update_item_priority([H|T], UpdatedList) :-
    RelativePriority is H.relative_priority - (H.manchester_priority * 0.1),
    UpdatedValue = H.put(relative_priority, RelativePriority),
    append(UpdatedList, [UpdatedValue], NewUpdatedList),
    update_item_priority(T, NewUpdatedList).