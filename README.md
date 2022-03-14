# Hospital Triage

**Disciplina**: FGA0210 - PARADIGMAS DE PROGRAMAÇÃO - T01 <br>
**Nro do Grupo**: 02<br>
**Paradigma**: Lógico<br>

## Alunos
|Matrícula | Aluno |
| -- | -- |
| 18/0014412 |  Cainã Freitas |
| 17/0141161 |  Erick Giffoni |
| 18/0016563 |  Filipe Machado |
| 18/0105345 |  Lucas Ferraz |
| 16/0015006 |  Matheus O. Patrício |
| 17/0122468 |  Nilvan Peres |
| 18/0011308 |  Peniel Etèmana |
| 18/0078640 |  Yuri Alves |

## Sobre 
O projeto contempla a implementação de um sistema de triagem de pacientes considerando um contexto hospitalar.

A motivação para esse projeto surgiu porque um dos membros ficou bastante doente e teve que passar a frequentar o hospital. Em uma dessas visitas, notou a existência de um processo de triagem de pacientes seguido da adição deles a uma fila de prioridades de atendimento. Imediatamente observou-se que isso poderia ser implementado seguindo o paradigma lógico.

O projeto contempla desde a triagem do paciente até a adição dele na fila de prioridades. A triagem é feita ao preencher um formulário de anamnese na página inicial com informações sobre o estado de saúde do paciente. Em seguida, nossos algoritmos são capazes de identificar qual a classificação daquele paciente segundo o [Protocolo de Manchester](https://passevip.com.br/pulseiras-protocolo-de-manchester/) e, então, adicioná-lo na fila.

A fila de prioridade de atendimento também é mostrada na página inicial. Foram implementadas 3 estratégias de prioridade para a fila: por ordem de chegada; por protocolo manchester; e por prioridade relativa (leva em conta a ordem de chegada e a classificação segundo o protocolo Manchester).

Para cada novo paciente inserido na fila, esta é reorganizada para que os atendimentos aconteçam segundo a lógica especificada (ordem de chegada, ou protocolo Manchester ou prioridade relativa).

## Screenshots

Página inicial:

![Inicial](imgs/inicial.png)

Após adicionados alguns pacientes...

Fila segundo a ordem de chegada:

![Ordem de chegada](imgs/arrival.png)

Fila segundo o Protocolo Manchester:

![Fila Manchester](imgs/manchester.png)

Fila segundo a prioridade relativa:

![Fila Relativa](imgs/relativa.png)

## Instalação 
**Linguagens**: Prolog (back), Javascript (front)<br>
**Tecnologias**: Yarn, Docker, Docker-compose, Make<br>

## Uso 

1. Para iniciar o backend:

`$ prolog -f main.pl`

> No MacOS:

`$ swipl -f main.pl`

2. Para iniciar o frontend:

`$ make`


3. Atenção: O servidor http em prolog é simples, mas está com problema de CORS. Para ignorar isso, é necessário que [o seu navegador seja inicializado com opções de segurança desativadas](https://alfilatov.com/posts/run-chrome-without-cors/). Exemplo:

Linux:
`$ google-chrome --disable-web-security --user-data-dir=~/chromeTemp`

Windows10:
`"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --disable-web-security --disable-gpu --user-data-dir=~/chromeTemp`

MacOS:
`open -n -a /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --user-data-dir="/tmp/chrome_dev_test" --disable-web-security`

4. Acesse o navegador web de sua preferência no endereço `127.0.0.1:3000`.
## Vídeo
Adicione 1 ou mais vídeos com a execução do projeto.

## Outros 
Quaisquer outras informações sobre seu projeto podem ser descritas a seguir.

## Fontes
Caso utilize materiais de terceiros, referencie-os adequadamente.
