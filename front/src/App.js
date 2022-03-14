import React, { lazy, useEffect, useContext, useState } from "react";
import api from "./services/api";
import PatientsTable from "./components/Table/Table";
import logo from "./logo.svg";
import "./App.css";
import InputLabel from "@mui/material/InputLabel";
import MenuItem from "@mui/material/MenuItem";
import FormControl from "@mui/material/FormControl";
import Select from "@mui/material/Select";
import Button from "@mui/material/Button";

export default function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [isRequestingData, setIsRequestingData] = useState(true);
  const [ManchesterPatientList, setManchesterPatientList] = useState([]);
  const [RelativePatientList, setRelativePatientList] = useState();
  const [ArrivalPatientList, setArrivalPatientList] = useState();

  const [name, setName] = useState();
  const [age, setAge] = useState();
  const [bad_breathing, setBad_breathing] = useState(false); //bool ok
  const [bleeding_level, setBleeding_level] = useState();
  const [shock_state, setShock_state] = useState(false); //bool
  const [is_convulsioning, setIs_convulsioning] = useState(false); //bool
  const [pain_level, setPain_level] = useState();
  const [unconscious, setUnconscious] = useState(false); //bool
  const [body_temperature, setBody_temperature] = useState();
  const [unconscious_history, setUnconscious_history] = useState(false); //bool
  const [minor_recent_problem, setMinor_recent_problem] = useState(false); //bool

  const [viewPatientList, setViewPatientList] = useState(1);
  const [openFilterList, setOpenFilterList] = useState();
  const [openBadBreathing, setOpenBadBreathing] = useState(false);
  const [openShockState, setOpenShockState] = useState(false);
  const [openIsConvulsioning, setOpenIsConvulsioning] = useState(false);
  const [openUnconscious, setOpenUnconscious] = useState(false);
  const [openUnconsciousHistory, setOpenUnconsciousHistory] = useState(false);
  const [openMinorRecentProblem, setOpenMinorRecentProblem] = useState(false);

  const colNames = [
    "Hora da chegada",
    "Prioridade Manchester",
    "Nome",
    "Prioridade relativa",
  ];

  const handleViewChange = (event) => {
    console.log(event.target.value);
    setViewPatientList(event.target.value);
  };

  const handleCloseFilterList = () => {
    setOpenFilterList(false);
  };

  const handleOpenFilterList = () => {
    setOpenFilterList(true);
  };

  const filterPatientResult = (result) => {
    let regex = new RegExp(".*charset=UTF-8\n\n", "gmius");

    // TO-DO: transformar cada "arrival_time" em Date

    return JSON.parse(result.data.replace(regex, ""));
  };

  const getManchesterOrderList = async () => {
    let patientList = null;
    await api
      .get("/get-patients/manchester-order")
      .then((result) => {
        console.log("deu certo dessa vez");
        patientList = filterPatientResult(result);
        console.log(patientList.queue);
        setManchesterPatientList(patientList.queue);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  const getRelativeOrderList = async () => {
    let patientList = null;
    await api
      .get("/get-patients/relative-order")
      .then((result) => {
        patientList = filterPatientResult(result);
        setRelativePatientList(patientList.queue);
      })
      .catch((error) => {
        patientList = {};
      });
    return patientList;
  };

  const getArrivalOrderList = async () => {
    let patientList = null;
    await api
      .get("/get-patients/arrival-order")
      .then((result) => {
        patientList = filterPatientResult(result);
        setArrivalPatientList(patientList.queue);
      })
      .catch((error) => {
        patientList = {};
      });
  };

  const sendNewPatient = async () => {
    var data = {
      nome: name,
      age: parseInt(age),
      bad_breathing: bad_breathing,
      bleeding_level: parseInt(bleeding_level),
      shock_state: shock_state,
      is_convulsioning: is_convulsioning,
      pain_level: parseInt(pain_level),
      unconscious: unconscious,
      body_temperature: parseInt(body_temperature),
      unconscious_history: unconscious_history,
      minor_recent_problem: minor_recent_problem,
    };
    await api
      .post("/register-patient", data)
      .then((result) => {
        getData();
        console.log(result);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  async function delay(time) {
    return new Promise((resolve) => setTimeout(resolve, time));
  }

  const getData = async () => {
    getManchesterOrderList();
    await delay(500);
    getRelativeOrderList();
    await delay(1000);
    getArrivalOrderList();
    await delay(1500);
  };

  useEffect(() => {
    if (isLoading === true) {
      console.log("Loading data.");
      if (isRequestingData === true) {
        setIsRequestingData(false);
        getData();
      }
      if (ManchesterPatientList && RelativePatientList && ArrivalPatientList) {
        setIsLoading(false);
      }
    }
  });

  return (
    <>
      {isLoading ? (
        <div>Carregando...</div>
      ) : (
        <>
          <div
            className="App"
            style={{
              background:
                "linear-gradient(45deg, rgba(254,203,125,1) 0%, rgba(255,244,171,1) 23%, rgba(255,193,153,1) 100%)",
            }}
          >
            <div className="Header-Container">
              <header className="App-header">
                <img src={logo} className="App-logo" alt="logo" />
                <p>Hospital Warrior of Sunlight</p>
              </header>
            </div>

            <div className="App-container">
              <div className="Add-Patients">
                <form>
                  <label>
                    Nome:
                    <input
                      type="text"
                      name="name"
                      onChange={(patient_name) => {
                        setName(patient_name.target.value);
                      }}
                    />
                  </label>
                </form>
                <form>
                  <label>
                    Idade:
                    <input
                      type="text"
                      name="age"
                      onChange={(age) => {
                        setAge(age.target.value);
                      }}
                    />
                  </label>
                </form>
                <form>
                  <label>
                    Respiração inadequada e/ou comprometimento das vias aéreas:
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openBadBreathing}
                      onClose={() => setOpenBadBreathing(false)}
                      onOpen={() => setOpenBadBreathing(true)}
                      value={bad_breathing}
                      label="Problemas Respiratórios"
                      onChange={(event) => setBad_breathing(event.target.value)}
                    >
                      <MenuItem value={true}>Sim</MenuItem>
                      <MenuItem value={false}>Não</MenuItem>
                    </Select>
                  </label>
                </form>
                <form>
                  <label>
                    Nível de Hemorragia:
                    <input
                      type="text"
                      name="bleeding_level"
                      onChange={(bleeding_level) => {
                        setBleeding_level(bleeding_level.target.value);
                      }}
                    />
                  </label>
                </form>
                <form>
                  <label>
                    Estado de Choque:
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openShockState}
                      onClose={() => setOpenShockState(false)}
                      onOpen={() => setOpenShockState(true)}
                      value={shock_state}
                      label="Estado de Choque"
                      onChange={(event) => setShock_state(event.target.value)}
                    >
                      <MenuItem value={true}>Sim</MenuItem>
                      <MenuItem value={false}>Não</MenuItem>
                    </Select>
                  </label>
                </form>
                <form>
                  <label>
                    Está convulsionando:
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openIsConvulsioning}
                      onClose={() => setOpenIsConvulsioning(false)}
                      onOpen={() => setOpenIsConvulsioning(true)}
                      value={is_convulsioning}
                      label="Convulsionando"
                      onChange={(event) =>
                        setIs_convulsioning(event.target.value)
                      }
                    >
                      <MenuItem value={true}>Sim</MenuItem>
                      <MenuItem value={false}>Não</MenuItem>
                    </Select>
                  </label>
                </form>
                <form>
                  <label>
                    Nível de Dor (1 a 3):
                    <input
                      type="text"
                      name="pain_level"
                      onChange={(pain_level) => {
                        setPain_level(pain_level.target.value);
                      }}
                    />
                  </label>
                </form>
                <form>
                  <label>
                    Inconsciente:
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openUnconscious}
                      onClose={() => setOpenUnconscious(false)}
                      onOpen={() => setOpenUnconscious(true)}
                      value={unconscious}
                      label="Inconsciente"
                      onChange={(event) => setUnconscious(event.target.value)}
                    >
                      <MenuItem value={true}>Sim</MenuItem>
                      <MenuItem value={false}>Não</MenuItem>
                    </Select>
                  </label>
                </form>
                <form>
                  <label>
                    Temperatura Corporal:
                    <input
                      type="text"
                      name="body_temperature"
                      onChange={(body_temperature) => {
                        setBody_temperature(body_temperature.target.value);
                      }}
                    />
                  </label>
                </form>
                <form>
                  <label>
                    Histórico de Inconsciência:
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openUnconsciousHistory}
                      onClose={() => setOpenUnconsciousHistory(false)}
                      onOpen={() => setOpenUnconsciousHistory(true)}
                      value={unconscious_history}
                      label="Inconsciente"
                      onChange={(event) =>
                        setUnconscious_history(event.target.value)
                      }
                    >
                      <MenuItem value={true}>Sim</MenuItem>
                      <MenuItem value={false}>Não</MenuItem>
                    </Select>
                  </label>
                </form>
                <form>
                  <label>
                    Problema Recente:
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openMinorRecentProblem}
                      onClose={() => setOpenMinorRecentProblem(false)}
                      onOpen={() => setOpenMinorRecentProblem(true)}
                      value={minor_recent_problem}
                      label="Problema Recente"
                      onChange={(event) =>
                        setMinor_recent_problem(event.target.value)
                      }
                    >
                      <MenuItem value={true}>Sim</MenuItem>
                      <MenuItem value={false}>Não</MenuItem>
                    </Select>
                  </label>
                </form>
                <input
                  type="submit"
                  value="Enviar"
                  onClick={() => sendNewPatient()}
                />
              </div>

              <div className="List-Patients">
                <div>
                  <FormControl sx={{ m: 1, minWidth: 120 }}>
                    <InputLabel id="demo-controlled-open-select-label">
                      Order By
                    </InputLabel>
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={openFilterList}
                      onClose={handleCloseFilterList}
                      onOpen={handleOpenFilterList}
                      value={viewPatientList}
                      label="ViewList"
                      onChange={handleViewChange}
                    >
                      <MenuItem value={1}>Pure Manchester Protocol</MenuItem>
                      <MenuItem value={2}>
                        Relative Algorithm (Manchester Protocol + Arrival Time)
                      </MenuItem>
                      <MenuItem value={3}>Arrival Order</MenuItem>
                    </Select>
                  </FormControl>
                </div>
                <div>
                  {viewPatientList === 1 && (
                    <PatientsTable
                      list={ManchesterPatientList}
                      colNames={colNames}
                    />
                  )}
                  {viewPatientList === 2 && (
                    <PatientsTable
                      list={RelativePatientList}
                      colNames={colNames}
                    />
                  )}
                  {viewPatientList === 3 && (
                    <PatientsTable
                      list={ArrivalPatientList}
                      colNames={colNames}
                    />
                  )}
                </div>
              </div>
            </div>
          </div>
        </>
      )}
    </>
  );
}
