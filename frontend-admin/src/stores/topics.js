import { defineStore } from "pinia";
import NProgress, { done } from 'nprogress';
import axios from 'axios';
import _ from 'lodash'; 
import nProgress from "nprogress";
import { inject } from 'vue'

export const useTopicsStore = defineStore({
  id: "topics",
  state: () => {
    return {
        baseUrl: inject("baseURL"),
        topics: []
      } 
  
  },
  actions: {
    async fetchTopics(payload) {
      try {
        NProgress.start();
        const result = await axios.get(`${this.baseUrl}/topics`);
        this.topics = result.data;
        return result.data;
      } catch (error) {
        console.log(error)        
      } finally {
        NProgress.done();
      }
    },
    async getTopicById(id) {
      try {
        nProgress.start();
        const result = await axios.get(`${this.baseUrl}/topics/${id}`)
        return result.data;
      } catch (err) {
        console.log(err.message);
      } finally {
        nProgress.done();
      }
    },


    async removeTopic(payload) {
        try{
          NProgress.start();
          const topic = await axios.delete(this.baseUrl + '/topics/' + payload.id)
          this.fetchTopics();
        } catch (err)  {
          console.log(err.message)
        } finally {
          NProgress.done();
        }
    },
    async updateTopic(payload) {
        try {
          NProgress.start();
           //const topic = await this.fakeApiCallEditTopic(true, payload)
           const topic = await axios.post(this.baseUrl + '/topics', payload)
           this.fetchTopics();
           return topic;
           console.log(topic);
           //this.getTopicById(topic.id);
        } catch (errors) {
            if (errors) {
              console.log(`backend update topic errors: ${ errors }` );
              return errors;
            }
        } finally {
          NProgress.done();
        }
    },
  }
});
