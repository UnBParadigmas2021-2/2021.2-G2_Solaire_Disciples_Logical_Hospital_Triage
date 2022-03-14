import React, { lazy, useEffect, useContext, useState } from "react";
import api from "./services/api";
import PatientsTable from "./components/Table/Table";
import logo from "./logo.svg";
import "./App.css";
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import Button from '@mui/material/Button';

export default function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [isRequestingData, setIsRequestingData] = useState(true);
  const [ManchesterPatientList, setManchesterPatientList] = useState([]);
  const [RelativePatientList, setRelativePatientList] = useState();
  const [ArrivalPatientList, setArrivalPatientList] = useState();

  const [name, setName] = useState();
  const [priority, setPriority] = useState();

  const [viewPatientList, setViewPatientList] = useState(1);
  const [open, setOpen] = useState();

  const colNames = ["Hora da chegada", "Prioridade Manchester", "Nome", "Prioridade relativa"];

  const handleViewChange = (event) => {
    console.log(event.target.value)
    setViewPatientList(event.target.value);
  };

  const handleClose = () => {
    setOpen(false);
  }

  const handleOpen = () => {
    setOpen(true);
  }

  const filterPatientResult = (result) => {
    let regex = new RegExp('.*charset=UTF-8\n\n', 'gmius')

    // TO-DO: transformar cada "arrival_time" em Date
  
    return JSON.parse(result.data.replace(regex, ''));
  }

  const getManchesterOrderList = async () => {
    let patientList = null;
    await api
      .get("/get-patients/manchester-order")
      .then((result) => {
        console.log('deu certo dessa vez')
        patientList = filterPatientResult(result)
        console.log(patientList.queue)
        setManchesterPatientList(patientList.queue)
      })
      .catch((error) => {
        console.log(error)
      });
  };

  const getRelativeOrderList = async () => {
    let patientList = null;
    await api
      .get("/get-patients/relative-order")
      .then((result) => {
        patientList = filterPatientResult(result)
        setRelativePatientList(patientList.queue)
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
        patientList = filterPatientResult(result)
        setArrivalPatientList(patientList.queue);
      })
      .catch((error) => {
        patientList = {};
      });
  };

  const sendNewPatient = async () => {
    var data = {
      nome: name,
      manchester_priority: parseInt(priority),
    };
    await api
      .post("/register-patient", data)
      .then((result) => {
        getData()
        console.log(result);
      })
      .catch((error) => {
        console.log(error);
      });
  };

  async function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
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
      console.log('Loading data.')
      if (isRequestingData === true){
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
              <div className="List-Patients">
                <div>
                  <FormControl sx={{ m: 1, minWidth: 120 }}>
                    <InputLabel id="demo-controlled-open-select-label">Order By</InputLabel>
                    <Select
                      labelId="demo-controlled-open-select-label"
                      id="demo-controlled-open-select"
                      open={open}
                      onClose={handleClose}
                      onOpen={handleOpen}
                      value={viewPatientList}
                      label="ViewList"
                      onChange={handleViewChange}
                    >
                      <MenuItem value={1}>Pure Manchester Protocol</MenuItem>
                      <MenuItem value={2}>Relative Algorithm (Manchester Protocol + Arrival Time)</MenuItem>
                      <MenuItem value={3}>Arrival Order</MenuItem>
                    </Select>
                  </FormControl>
                </div>

                <div>
                  {viewPatientList == 1 &&
                    <PatientsTable list={ManchesterPatientList} colNames={colNames} />
                  }
                  {viewPatientList == 2 &&
                    <PatientsTable list={RelativePatientList} colNames={colNames} />
                  }
                  {viewPatientList == 3 &&
                    <PatientsTable list={ArrivalPatientList} colNames={colNames} />
                  }
                </div>
              </div>

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
                    Prioridade:
                    <input
                      type="text"
                      name="priority"
                      onChange={(patient_priority) => {
                        setPriority(patient_priority.target.value);
                      }}
                    />
                  </label>
                </form>
                <input
                  type="submit"
                  value="Enviar"
                  onClick={() => sendNewPatient()}
                />
              </div>

            </div>
          </div>
        </>
      )}
    </>
  );
}
