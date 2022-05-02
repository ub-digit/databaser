import { defineStore } from 'pinia'
import { inject } from 'vue'
import axios from 'axios'
import NProgress from 'nprogress'


export const useStore = defineStore('main', {
    state: () => {
        return {
          baseURL: inject("baseURL"),
          alertURL: inject("alertURL"),
        }
      },

      actions: {
        async fetchDatabases(payload) {
          try {
            NProgress.start();
            const result = await axios.get(`${this.baseURL}/databases`, {params: {payload}});
            return result.data;
          } catch (error) {
            console.log(error.message);
          } finally {
            NProgress.done();
          }
        },
        async fetchPopularDatabases(payload) {
          try {
            const result = await axios.get(`${this.baseURL}/databases/popular`, {params: {payload}});
            return result.data;
          } catch (error) {
            console.log(error.message);
          }
        },
        async fetchDatabase(payload) {
          try {
            NProgress.start();
            const result = await axios.get(`${this.baseURL}/databases/${payload.id}`, {params: {payload}});
            return result.data;
          } catch (error) {
            console.log(error.message);
          } finally {
            NProgress.done();
          }
        },
      },
      getters: {
      },
  })