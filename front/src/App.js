import React, { lazy, useEffect, useContext, useState } from "react";
import api from "./services/api";
import Table from "./components/Table/Table";
import logo from "./logo.svg";
import "./App.css";

export default function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [ManchesterPatientList, setManchesterPatientList] = useState([]);
  const [RelativePatientList, setRelativePatientList] = useState();
  // const [ArrivalPatientList, setArrivalPatientList] = useState();

  const [name, setName] = useState();
  const [priority, setPriority] = useState();

  const colNames = ["Hora da chegada", "Prioridade Manchester", "Nome", "Prioridade relativa"];

  const filterPatientResult = (result) => {
    let regex = new RegExp('.*charset=UTF-8\n\n', 'gmius')
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

        // TO-DO: transformar cada "arrival_time" em Date

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

  // const getArrivalOrderList = async () => {
  //   let patientList = null;
  //   await api
  //     .get("/get-patients/arrival-order")
  //     .then((result) => {
  //       patientList = result.data;
  //     })
  //     .catch((error) => {
  //       patientList = {};
  //     });
  //   setArrivalPatientList(patientList);
  // };

  const sendNewPatient = async () => {
    let register;
    var data = {
      nome: name,
      manchester_priority: parseInt(priority),
    };
    await api
      .post("/register-patient", data)
      .then((result) => {
        console.log(result);
        register = result.data;
      })
      .catch((error) => {
        console.log(error);
        register = {};
      });
  };

  const getData = async () => {
    setManchesterPatientList(getManchesterOrderList());
    setRelativePatientList(getRelativeOrderList());
    // setArrivalPatientList(getArrivalOrderList());
  };

  useEffect(() => {
    if (isLoading === true) {
      getData();
      if (ManchesterPatientList) {
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
                {JSON.stringify(ManchesterPatientList)}
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

              <div className="Add-Patients">
                      <h2>Fila de atendimento de pacientes</h2>
                      <div>
                        <h4>Por ordem de chegada</h4>
                        {/* <Table /> */}
                      </div>
                      <div>
                        <h4>Por prioridade (protocolo Manchester)</h4>
                        <Table list={ManchesterPatientList} colNames={colNames} />
                      </div>
                      <div>
                        <h4>Por prioridade relativa</h4>
                        <Table list={RelativePatientList} colNames={colNames} />
                      </div>
              </div>

            </div>
          </div>
        </>
      )}
    </>
  );
}
