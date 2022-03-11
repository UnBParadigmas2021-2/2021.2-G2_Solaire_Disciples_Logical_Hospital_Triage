import React, { lazy, useEffect, useContext, useState } from 'react'
import logo from './logo.svg';
import './App.css';

export default function App() {
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    if (isLoading === true){
      
    }
  }, [])

  return (
    <>
      {isLoading ? (
        <div>Carregando...</div>
      ) : (
        <>
          <div className="App" style={{ background: 'linear-gradient(yellow,black)' }}>
            <div className="Header-Container">
              <header className="App-header">
                <img src={logo} className="App-logo" alt="logo" />
                <p>
                  Hospital Warrior of Sunlight
                </p>
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
