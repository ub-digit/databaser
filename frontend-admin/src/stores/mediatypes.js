
import { defineStore } from "pinia";
import _ from 'lodash'; 
import nProgress, { done } from 'nprogress';
import axios from "axios";

export const useMediatypesStore = defineStore({
  id: "mediatypes",
  state: () => {
    return {
        baseUrl: 'http://localhost:4010',
        mediatypes:  []
      } 
  },
  getters: {
  },
  actions: {
    async getMediatypeById(id) {
      try {
        const result = await axios.get(`${this.baseUrl}/media_types/${id}`);
        return result.data; // state.publishers.find((publisher) => publisher.id === parseInt(id) );
      } catch (err) {
        console.log(err.message);
      }
    },
    async fetchMediatypes(payload) {
      try {
        nProgress.start();
        const result = await axios.get(`${this.baseUrl}/media_types`);
        this.mediatypes = result.data;
        return result.data;
      } catch (error) {
        console.log(error)        
      } finally {
        nProgress.done();
      }
    },
    async removeMediatype(payload) {
      try {
        nProgress.start();
        const result = await axios.delete(this.baseUrl + '/media_types/' + payload.id)
        console.log(result);
        if (result.data.status && result.data.status === "deleted") {
          this.fetchMediatypes();
        }
        return result;
    } catch (err)  {
      console.log(err.message)
    } finally {
      nProgress.done();
    }
    },
    async updateMediatype(payload) {
      try {
        nProgress.start();
        const result = await axios.post(this.baseUrl + '/media_types', payload)
        console.log(result);
        if (result.data.media_type.id) {
          this.fetchMediatypes();
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
