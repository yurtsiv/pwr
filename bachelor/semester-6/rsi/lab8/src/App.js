import { Switch, Route } from "react-router";
import Home from "./pages/Home";

function App() {
  return (
    <div className="container py-5">
      <Switch>
        <Route component={Home} />
      </Switch>
    </div>
  );
}

export default App;
