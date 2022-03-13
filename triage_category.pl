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
    assert(pregnant(Pregnant)).

hasChestPain :- 
    write('Is the patient with chest pain? (yes/no): '),
    read(ChestPain),
    assert(chestPain(ChestPain)).
















