import { defineStore } from 'pinia'
import { inject } from 'vue'
import axios from 'axios'

export const useStore = defineStore('main', {
    state: () => {
        return {
          baseURL: inject("baseURL"),
        }
      },

      actions: {
        async fetchDatabases(payload) {
          try {
            const result = await axios.get(`${this.baseURL}/databases`, {params: {payload}});
            return result.data;
          } catch (error) {
            console.log(error.message);
          }
        },
        async fetchPopularDatabases({_, state }, payload) {
          try {
            const result = await axios.get(`${this.baseURL}/databases/popular`, {params: {payload}});
            return result.data;
          } catch (error) {
            console.log(error.message);
          }
        },
        async fetchDatabase(id) {
          try {
            const result = await axios.get(`${this.baseURL}/databases/${id}`);
            return result.data;
          } catch (error) {
            console.log(error.message);
          }
        },
      },
      getters: {
      },
  })