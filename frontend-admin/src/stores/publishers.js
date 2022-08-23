
import { defineStore } from "pinia";
import axios from 'axios';
import _ from 'lodash'; 
import NProgress, { done } from 'nprogress';
import { findLastIndex } from "underscore";
import { faSignInAlt } from "@fortawesome/free-solid-svg-icons";
import nProgress from "nprogress";

export const usePublishersStore = defineStore({
  id: "publishers",
  state: () => {
    return {
      baseUrl: 'http://localhost:4010'
    } 
  },
  getters: {

  },
  actions: {
    async getPublisherById(id) {
      try {
        const result = await axios.get(`${this.baseUrl}/publishers/${id}`);
        return result.data; // state.publishers.find((publisher) => publisher.id === parseInt(id) );
      } catch (err) {
        console.log(err.message);
      }
    },
    async fetchPublishers(payload) {
      try {
        NProgress.start();
        const result = await axios.get(`${this.baseUrl}/publishers`);
        return result.data;
      } catch (error) {
        console.log(error)        
      } finally {
        NProgress.done();
      }
    },
    async removePublisher(payload) {
        try {
            nProgress.start();
            const result = await axios.delete(this.baseUrl + '/publishers/' + payload.id)
            console.log(result);
            return result;
        } catch (err)  {
          console.log(err.message)
        } finally {
          nProgress.done();
        }
    },
    async updatePublisher(payload) {
        try {
          nProgress.start();
          const result = await axios.post(this.baseUrl + '/publishers', payload)
          console.log(result);
          return result;
        } catch (errors) {
        } finally {
          nProgress.done();
        }
    },
    async newPublisher(payload) {
      try {
        nProgress.start();
        const result = await axios.post(this.baseUrl + '/publishers', payload)
        return result;
      } catch (err) {
          console.log(err);
      } finally {
        nProgress.done();
      }
    }
  }
});
