import logo from './logo.svg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
           <code>Welcome To CI/CD Workshop</code> 
        </p>
        <a
          className="App-link"
          href="https://youtu.be/qP8kir2GUgo"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn CI/CD
        </a>
      </header>
    </div>
  );
}

export default App;
