
import { defineStore } from "pinia";
import _ from 'lodash';
import axios from 'axios';
import nProgress, { done } from 'nprogress';
import { inject } from 'vue'

export const useDatabasesStore = defineStore({
  id: "databases",
  state: () => {
    return {
      baseUrl: inject("baseURL"),
      databases: [],
    }
  },
  getters: {
  },
  actions: {
    async getDatabaseById(id) {
      try {
        const result = await axios.get(`${this.baseUrl}/databases/${id}`);
        return result.data;
      } catch (err) {
        console.log(err.message);
      }
    },
    async fetchDatabases(payload) {
      try {
        console.log(payload)
        nProgress.start();
        this.databases = [];
        const result = await axios.get(`${this.baseUrl}/databases/`, {params: payload});
        this.databases = result.data;
        return result.data;
      } catch (error) {
        console.log(error)        
      } finally {
        nProgress.done();
      }
    },

    async removeDatabase(payload) {
      try {
        nProgress.start();
        const result = await axios.delete(this.baseUrl + '/databases/' + payload.id)
        console.log(result);
        return result.data;
    } catch (err)  {
      console.log(err.message)
    } finally {
      nProgress.done();
    }
    },
    async updateDatabase(payload) {
      try {
        nProgress.start();
        const result = await axios.post(this.baseUrl + '/databases', payload)
        return result;
      } 
      catch (errors) {
      } finally {
        nProgress.done();
      }
    },
    async newDatabase(payload) {
      try {
        nProgress.start();
        const result = await axios.get(this.baseUrl + '/databases/new')
        return result;
      } 
      catch (errors) {
      } finally {
        nProgress.done();
      }
    },
  }
});
