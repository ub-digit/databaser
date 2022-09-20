
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
        nProgress.start();
        this.databases = [];
        const result = await axios.get(`${this.baseUrl}/databases/`, {params: { term: payload}});
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
        if (result.data.status && result.data.status === "deleted") {
         // this.fetchDatabases();
        }
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
        console.log(result);
        if (result.data.id) {
        //  this.fetchDatabases();
        }
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
        console.log(result);
        if (result.data.id) {
       //   this.fetchDatabases();
        }
        return result;
      } 
      catch (errors) {
      } finally {
        nProgress.done();
      }
    },
  }
});
