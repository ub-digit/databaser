
import { defineStore } from "pinia";
import axios from 'axios';
import _ from 'lodash'; 
import NProgress, { done } from 'nprogress';
import { inject } from 'vue'

export const usePublishersStore = defineStore({
  id: "publishers",
  state: () => {
    return {
      baseUrl: inject("baseURL"),
      publishers: []
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
        this.publishers = [];
        const result = await axios.get(`${this.baseUrl}/publishers`);
        this.publishers = result.data;
        return result.data;
      } catch (error) {
        console.log(error)        
      } finally {
        NProgress.done();
      }
    },
    async removePublisher(payload) {
        try {
            NProgress.start();
            const result = await axios.delete(this.baseUrl + '/publishers/' + payload.id)
            this.fetchPublishers();
            console.log(result);
            return result;
        } catch (err)  {
          console.log(err.message)
        } finally {
          NProgress.done();
        }
    },
    async updatePublisher(payload) {
        try {
          NProgress.start();
          const result = await axios.post(this.baseUrl + '/publishers', payload)
          console.log(result);
          this.fetchPublishers();
          return result;
        } catch (errors) {
        } finally {
          NProgress.done();
        }
    },
  }
});
