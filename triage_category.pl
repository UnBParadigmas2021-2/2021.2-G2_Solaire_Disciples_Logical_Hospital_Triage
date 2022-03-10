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
    write('Type the scale of patient: '),
    read(PainScale),
    assert(painScale(PainScale)).

isBleeding :- 
    write('Is patient bleeding? (yes/no): '),
    read(Bleeding),
    assert(bleeding(Bleeding)).

isFeverish :- 
    write('Is patient feverish? (yes/no): '),
    read(Feverish),
    assert(feverish(Feverish)).

isVomiting :- 
    write('Is patient vomiting? (yes/no): '),
    read(Vomit),
    assert(vomit(Vomit)).

isPregnant :- 
    write('Is patient pregnant? (yes/no): '),
    read(Pregnant),
    assert(pregnite(Pregnant)).

getPressure :- 
    write('Type the pressure of patient: '),
    read(Pressure),
    assert(pressure(Pressure)).

hasChestPain :- 
    write('Is patient chest pain? (yes/no): '),
    read(ChestPain),
    assert(chestPain(ChestPain)).









