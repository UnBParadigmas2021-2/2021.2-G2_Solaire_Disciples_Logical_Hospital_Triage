% Logic to handle triage_category

% Legend: 1 -> Red, 2 -> Orange, 3 -> Yellow, 4-> Green, 5-> Blue.

% Facts -> syntoms and urgency

category(hemorrhage_severe, 1).
category(convulsion, 1).
category(heart_attack, 1).
category(chest_pain, 1).
category(irresponsive_child, 1).
category(ineffective_breathing, 1).

category(intense_pain, 2).
category(feverish_child, 2).
category(unconscious, 2).

category(moderate_pain, 3).
category(panic_crises, 3).
category(hypertension, 3).

category(pain, 4).
category(respiratory_infection, 4).
category(vomit, 4).
category(flue, 4).

category(recent_problem, 5).

% Triage questions
getAge :- 
    write('Type the age of patient: '),
    read(Idade),
    assert(idade(Idade)).

getPainScale :- 
    write('Type the scale of pain: '),
    read(PainScale),
    assert(painScale(PainScale)).

isBleeding(X) :-
    (
        X = yes, 
        assert(bleeding(true))
    ;
        X = no, 
        assert(bleeding(false))
    ).
    

isFeverish(X) :-
    (
        X = yes, 
        assert(feverish(true))
    ;
        X = no, 
        assert(feverish(false))
    ).

isVomiting(X) :-
    (
        X = yes, 
        assert(vomiting(true))
    ;
        X = no, 
        assert(vomiting(false))
    ).

isPregnant(X) :-
    (
        X = yes,
        assert(pregnant(true))
    ;
        assert(pregnant(false))
    ).

hasChestPain(X) :-
    (
        X = yes,
        assert(chestPain(true))
    ;
        false
    ).

hasDiabetes(X) :-
    (
        X = yes,
        assert(diabetes(true))
    ;
        false
    ).



getTemperature :-
    write('Type the temperature of the patient: '),
    read(Temperature),
    assert(temperature(Temperature)).

getBloodPressure :-
    write('Type the blood pressure of the patient: '),
    read(BloodPressure),
    assert(bloodPressure(BloodPressure)).

getOxygenLevel :- 
    write('Type the oxygen level of the patient: '),
    read(OxygenLevel),
    assert(oxygenLevel(OxygenLevel)).


    
% Rules to handle triage category
is_child:- idade(Idade), Idade < 5,!.
is_elderly :- idade(Idade), Idade > 60, !.
is_pain_high :- painScale(PainScale), PainScale > 7, !.



% Rules to check vital signs
are_vital_signs_normal :-
    temperature(Temperature),
    bloodPressure(BloodPressure),
    oxygenLevel(OxygenLevel),
    Temperature =< 38,
    Temperature >= 36,
    BloodPressure >= 95,
    BloodPressure =< 130,
    OxygenLevel > 89,
    !.

% Add combinations of syntoms that represent the Manchester Priority

priority1(ManchesterPriority) :-
    is_child; is_elderly; isPregnant(yes),
    is_pain_high, hasChestPain(yes), isBleeding(yes),
    ManchesterPriority is 1.

priority2(ManchesterPriority) :-
    is_elderly; is_child,
    isDiabetic(yes), isBleeding(yes),
    ManchesterPriority is 2.

priority3(ManchesterPriority) :-
    is_child; is_elderly; isPregnant(yes),
    not(are_vital_signs_normal), isFeverish(yes),
    ManchesterPriority is 3.

priority4(ManchesterPriority) :-
    is_child; is_elderly,
    are_vital_signs_normal, isVomiting(yes),
    ManchesterPriority is 4.

priority5(ManchesterPriority) :-
    isVomiting(yes); isFeverish(no),
    ManchesterPriority is 5.


% Function to call priority1, priority2, priority3, priority4, priority5 and return priority

triage_category(ManchesterPriority) :-
        priority1(ManchesterPriority);
        priority2(ManchesterPriority);
        priority3(ManchesterPriority);
        priority4(ManchesterPriority);
        priority5(ManchesterPriority);
    
    write('The patient has a priority of: '),
    write(ManchesterPriority).

get_manchester_priority(
    BadBreathing,
    BleedingLevel,
    ShockState,
    Convulsioning,
    NotRespondingChild,
    PainLevel,
    Unconscious,
    BodyTemperature,
    UnconsciousHistory,
    Adult,
    MinorRecentProblem,
    ManchesterPriority
) :-
    ManchesterPriority is 5.

        
isTemperatureHigh(BodyTemperature) :-
    BodyTemperature >= 38 -> true.

isTemperatureLow(BodyTemperature) :-
    35 >= BodyTemperature -> true.

isChild(Age):-
    12 >= Age -> true.

isOxigenLow(OxigenLevel):-
    89 >= OxigenLevel -> true. 

isNoPain(PainLevel):-
    PainLevel =:= 1 -> true.

isLowPain(PainLevel):-
    PainLevel =:= 2 -> true.

isHighPain(PainLevel):-
    PainLevel =:= 3 -> true.