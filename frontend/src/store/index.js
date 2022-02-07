import { createStore } from "vuex";
import axios from "axios";

//import { report } from '../../../routes/api/databases';

export default (app) => {
  app.use(createStore({
    state() {
      return {
        baseURL: app.baseURL,

      }
    },
    mutations: {
  
    },
    actions: {

      async fetchDatabases({ _, state }, payload) {
        try {
          const result = await axios.get(`${state.baseURL}/databases`, {params: {payload}});
          return result.data;
        } catch (error) {
          console.log(error.message);
        }
      },
      async fetchPopularDatabases({_, state }) {
        try {
          const result = await axios.get(`${state.baseURL}/databases/popular`);
          return result.data;
        } catch (error) {
          console.log(error.message);
        }
      },
      async fetchDatabase({state}, id) {
        try {
          const result = await axios.get(`${state.baseURL}/databases/${id}`);
          return result.data;
        } catch (error) {
          console.log(error.message);
        }
      },
    },
    getters: {
    },
  }));
}
