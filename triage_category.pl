
% Recebe sintomas do paciente e retorna a prioridade de acordo com o protocolo de manchester
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
    !,  (BadBreathing % Respiracao obstruida/inadequada, comprometimento das vias aereas
        ; extremeBleeding(BleedingLevel) % Hemorragia exanguinante
        ; ShockState % Paciente em estado de choque
        ; Convulsioning % Paciente esta convulcionando
        ; (isChild(Age), Unconscious)) % O paciente eh uma crianca desacordada
        -> ManchesterPriority is 1 % Caso algum desses sintomas seja verdade, a prioridade eh 1
    ;   (isHighPain(PainLevel) % Dor intensa
        ;highBleeding(BleedingLevel) % Hemorragia maior incontrolavel
        ;Unconscious % Pessoa inconsciente
        ; (isChild(Age), isTemperatureHigh(BodyTemperature)) % Paciente eh uma crianca em estado febril
        ; isTemperatureLow(BodyTemperature) % Esfriamento/Hiportemia
        ; isMediumPain(PainLevel)) % Dor moderada
        -> ManchesterPriority is 2 % Caso algum desses sintomas seja verdade, a prioridade eh 2
    ;   (lowBleeding(BleedingLevel) % Hemorragia menor incontrolavel
        ; UnconsciousHistory % Paciente tem historico de inconsciencia recente
        ; isTemperatureHigh(BodyTemperature)) % Paciente em estado febril
        -> ManchesterPriority is 3 % Caso algum desses sintomas seja verdade, a prioridade eh 3
    ;   (isLowPain(PainLevel) % Dor leve recente
        ; isLowFeverish(BodyTemperature) % Febre baixa
        ; MinorRecentProblem) % Problema recente
        -> ManchesterPriority is 4 % Caso algum desses sintomas seja verdade, a prioridade eh 4
    ;   ManchesterPriority is 5. % Caso nenhum desses sintomas que definam prioridade seja verdade, a prioridade eh 5
    
        
isTemperatureHigh(BodyTemperature) :- % Caso a temperatura do paciente seja maior que 38 graus, ele esta em estado febril
    BodyTemperature > 38 -> true.

isTemperatureLow(BodyTemperature) :- % Caso a temperatura do paciente seja menor que 35 graus, ele esta em estado de esfriamento
    35 >= BodyTemperature -> true.

isLowFeverish(BodyTemperature) :- % Caso a temperatura do paciente seja igual a 38 graus, ele esta em estado febril leve
    BodyTemperature =:= 38 -> true.


isChild(Age):- % Caso o paciente tenha 12 anos ou menos, ele eh consideraco crianca
    12 >= Age -> true.

isOxigenLow(OxigenLevel):- % Nivel de oxigenacao do sangue menor que 89 eh menor do que o saudavel
    89 >= OxigenLevel -> true. 

isNoPain(PainLevel):- % Paciente nao esta sentindo dor
    PainLevel =:= 0 -> true.

isLowPain(PainLevel):- % Paciente esta sentindo pouca dor
    PainLevel =:= 1 -> true.

isMediumPain(PainLevel):- % Paciente esta sentindo dor moderada
    PainLevel =:= 2 -> true.

isHighPain(PainLevel):- % Paciente esta sentindo dor intensa
    PainLevel =:= 3 -> true.

extremeBleeding(BleedingLevel):- % Paciente esta com hemorragia exanguinante
    BleedingLevel =:= 3 -> true.

highBleeding(BleedingLevel):- % Paciente esta com hemorragia maior incontrolavel
    BleedingLevel =:= 2 -> true.

lowBleeding(BleedingLevel):- % Paciente esta com hemorragia menor incontrolavel
    BleedingLevel =:= 1 -> true.

