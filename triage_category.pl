% Logic to handle triage_category

% Legend: 1 -> Red, 2 -> Orange, 3 -> Yellow, 4-> Green, 5-> Blue.

% Facts -> syntoms and urgency

category(hemorrhage, red).
category(convulsion, red).
category(heartAttack, red).
category(irresponsiveChild, red).

category(intensePain, orange).
category(feverishChild, orange).
category(unconscious, orange).
category(fever, orange).

category(moderatePain, yellow).
category(vomit, yellow).
category(moderateFever, yellow).

category(recentProblem, green).
category(respiratoryInfection, green).



% Triage questions

getIdade :- 
    write('Type the age of patient: '),
    read(Idade),
    assert(idade(Idade)).

getPainScale :- 
    write('Type the scale of pain: '),
    read(PainScale),
    assert(painScale(PainScale)).

isBleeding :- 
    write('Is the patient bleeding? (yes/no): '),
    read(Bleeding),
    assert(bleeding(Bleeding)).

isFeverish :- 
    write('Is the patient feverish? (yes/no): '),
    read(Feverish),
    assert(feverish(Feverish)).

isVomiting :- 
    write('Is the patient vomiting? (yes/no): '),
    read(Vomit),
    assert(vomit(Vomit)).

isPregnant :- 
    write('Is the patient pregnant? (yes/no): '),
    read(Pregnant),
    assert(pregnite(Pregnant)).

getPressure :- 
    write('Type the pressure of the patient: '),
    read(Pressure),
    assert(pressure(Pressure)).

hasChestPain :- 
    write('Is the patient with chest pain? (yes/no): '),
    read(ChestPain),
    assert(chestPain(ChestPain)).


% Rules to age

isChild:- idade(Idade), Idade < 5,!.
isElderly :- idade(Idade), Idade > 65, !.


    











