import React, { lazy, useEffect, useContext, useState } from "react";
import api from "./services/api";
import logo from "./logo.svg";
import "./App.css";

export default function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [ManchesterPatientList, setManchesterPatientList] = useState();
  const [RelativePatientList, setRelativePatientList] = useState();
  const [ArrivalPatientList, setArrivalPatientList] = useState();

  const getManchesterOrderList = async () => {
    let patientList = null;
    await api
      .get("/get-patients/manchester-order")
      .then((result) => {
        console.log(result)
        console.log('deu certo dessa vez')
        // patientList = result.data.queue;
        // setManchesterPatientList(patientList)
      })
      .catch((error) => {
        console.log('erro')
      });
    
  };

  // const getRelativeOrderList = async () => {
  //   let patientList = null;
  //   await api
  //     .get("/get-patients/relative-order")
  //     .then((result) => {
  //       patientList = result.data;
  //     })
  //     .catch((error) => {
  //       patientList = {};
  //     });
  //   return patientList;
  // };

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

  const getData = async() => {
    setManchesterPatientList(getManchesterOrderList());
    // setRelativePatientList(getRelativeOrderList());
    // setArrivalPatientList(getArrivalOrderList());
  }

  useEffect(() => {
    if (isLoading === true) {
      getData()
      if(ManchesterPatientList){
        setIsLoading(false)
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
            style={{ background: "linear-gradient(45deg, rgba(254,203,125,1) 0%, rgba(255,244,171,1) 23%, rgba(255,193,153,1) 100%)" }}
          >
            <div className="Header-Container">
              <header className="App-header">
                <img src={logo} className="App-logo" alt="logo" />
                <p>Hospital Warrior of Sunlight</p>
              </header>
            </div>

            <div className="App-container">
              <div className="List-Patients">
                
              </div>

              <div className="Add-Patients">
                <form>
                  <label>
                    Nome:
                    <input type="text" name="name" />
                  </label>
                </form>
                <form>
                  <label>
                    Prioridade:
                    <input type="text" name="name" />
                  </label>
                </form>
                <input type="submit" value="Enviar" />
              </div>
            </div>
          </div>
        </>
      )}
    </>
  );
}
