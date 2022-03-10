% Logic to handle triage_category

% 1. Collect some info about the patients

triage_info :- 
    write('Enter the patient ID: '),
    read(PatientID),
    write('Enter the patient name: '),
    read(PatientName),
    write('Enter the patient age: '),
    read(PatientAge),
    write('Enter the patient: '),