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










