% Logic to handle triage_category

% Legend: 1 -> Red, 2 -> Orange, 3 -> Yellow, 4-> Green, 5-> Blue.

% Facts -> syntoms and urgency

% Add combinations of syntoms that represent the Manchester Priority

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
) :-
    !,  (BadBreathing 
        ; extremeBleeding(BleedingLevel) 
        ; ShockState
        ; Convulsioning
        ; (isChild(Age), Unconscious)) 
        -> ManchesterPriority is 1
    ;   (isHighPain(PainLevel)
        ;highBleeding(BleedingLevel)
        ;Unconscious
        ; (isChild(Age), isTemperatureHigh(BodyTemperature))
        ; isTemperatureLow(BodyTemperature)
        ; isMediumPain(PainLevel))
        -> ManchesterPriority is 2
    ;   (lowBleeding(BleedingLevel)
        ; UnconsciousHistory
        ; isTemperatureHigh(BodyTemperature)) 
        -> ManchesterPriority is 3
    ;   (isLowPain(PainLevel)
        ; isLowFeverish(BodyTemperature)
        ; MinorRecentProblem)
        -> ManchesterPriority is 4
    ;   ManchesterPriority is 5.
    
        
isTemperatureHigh(BodyTemperature) :-
    BodyTemperature > 38 -> true.

isTemperatureLow(BodyTemperature) :-
    35 >= BodyTemperature -> true.

isLowFeverish(BodyTemperature) :-
    BodyTemperature =:= 38 -> true.


isChild(Age):-
    12 >= Age -> true.

isOxigenLow(OxigenLevel):-
    89 >= OxigenLevel -> true. 

isNoPain(PainLevel):-
    PainLevel =:= 0 -> true.

isLowPain(PainLevel):-
    PainLevel =:= 1 -> true.

isMediumPain(PainLevel):-
    PainLevel =:= 2 -> true.

isHighPain(PainLevel):-
    PainLevel =:= 3 -> true.

extremeBleeding(BleedingLevel):-
    BleedingLevel =:= 3 -> true.

highBleeding(BleedingLevel):-
    BleedingLevel =:= 2 -> true.

lowBleeding(BleedingLevel):-
    BleedingLevel =:= 1 -> true.

