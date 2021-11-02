import { createStore } from "vuex";
import axios from "axios";
//import { report } from '../../../routes/api/databases';

export default createStore({
  state: {
    databases: [],
    topics: [],
  },
  mutations: {
    SET_DATABASES(state, databases) {
      state.databases = databases;
    },
  },
  actions: {
    async fetchMediatypes() {
      try {
        const result = await axios.get("http://localhost:5000/api/mediatypes");
        return result.data;
      } catch (error) {
        console.log(error.message);
      }
    },
    async fetchTopics() {
      try {
        const result = await axios.get("http://localhost:5000/api/topics");
        return result.data;
      } catch (error) {
        console.log(error.message);
      }
    },
    async fetchDatabases({ _, state }, payload) {
      console.log(payload);
      try {
        const result = await axios.get("http://localhost:5000/api/databases", {
          params: {
            payload,
          },
        });
        return result.data;
      } catch (error) {
        console.log(error.message);
      }
    },
    async fetchPopularDatabases({ commit }) {
      try {
        const result = await axios.get(
          "http://localhost:5000/api/databases/popular"
        );
        return result.data;
      } catch (error) {
        console.log(error.message);
      }
    },
    async fetchFilteredDatabaseList(_, filter) {
      console.log(filter);
      try {
        const result = await axios.get(
          "http://localhost:5000/api/databases/popular"
        );
        return result.data;
      } catch (error) {
        console.log(error.message);
      }
    },
    async fetchDatabase(_, id) {
      try {
        const result = await axios.get(
          `http://localhost:5000/api/databases/${id}`
        );
        return result.data;
      } catch (error) {
        console.log(error.message);
      }
    },
  },
  getters: {
    allDatabases: (state) => state.databases,
  },
});
