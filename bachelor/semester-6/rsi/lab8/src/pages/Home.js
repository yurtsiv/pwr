import { useState, useEffect } from "react";
import AddForm from "../components/AddForm";
import {
  getCountries,
  deleteCountry as deleteCountryApi,
} from "../api";
import Country from "../components/Country";

export const defaultEditing = {
  editing: false,
  country: {},
};

export default function Home() {
  const [countries, setCountries] = useState([]);
  const [editing, setEditing] = useState(defaultEditing);
  const [union, setUnion] = useState([]);

  useEffect(() => {
    getCountries()
      .then((res) => setCountries(res))
      .catch((err) => alert(err));
  }, []);

  useEffect(() => {
    if (union.length > 2) {
      setUnion([]);
    }
  }, [union]);

  function deleteCountry(id) {
    deleteCountryApi(id)
      .then(() => setCountries((p) => p.filter((e) => e.Id !== id)))
      .catch((err) => alert(err));
  }


  return (
    <>
      <AddForm
        edit={editing}
        setEditing={setEditing}
        setCountries={setCountries}
      />
      {countries.length === 0 && <p>There is no any country yet</p>}
      {countries.length > 0 && (
        <div className="row">
          <h4>Countries:</h4>
          {countries.map((country) => (
            <Country
              setUnion={setUnion}
              key={country.Id}
              editable={true}
              setEditing={setEditing}
              deleteCountry={deleteCountry}
              {...country}
            />
          ))}
        </div>
      )}
    </>
  );
}
