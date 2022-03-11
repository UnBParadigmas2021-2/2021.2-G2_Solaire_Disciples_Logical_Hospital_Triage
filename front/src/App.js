import logo from './logo.svg';
import './App.css';

function App() {
  return (
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
        
        <div className="Add-Patients">

        </div>
      </div>
    </div>
  );
}

export default App;
