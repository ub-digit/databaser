import { defineStore } from "pinia";
import NProgress, { done } from 'nprogress';
import axios from 'axios';
import _ from 'lodash'; 
import nProgress from "nprogress";

export const useTopicsStore = defineStore({
  id: "topics",
  state: () => {
    return {
        baseUrl: 'http://localhost:4010'
      } 
  
  },
  actions: {
    async fetchTopics(payload) {
      try {
        NProgress.start();
        const result = await axios.get(`${this.baseUrl}/topics`);
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
// ##################### FAKE API CALLS ############# 
    fakeApiCallNewTopic(shouldResolve, payload) {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (shouldResolve === true) {
              payload.id = Date.now();
              payload.sub_topics.forEach(topic => topic.id = Date.now())
              this.topics.push(payload)
              return resolve(payload)
            } else {
              return reject({
                topic: [{field: "name_en", error_code: "validation_required"}, {field: "name_sv", error_code: "validation_required"}],
                sub_topics: [{field: 'sub_topic_name_en',  error_code: 'validation_required'},{field: 'sub_topic_name_en',  error_code: 'validation_required'}]
              })
            }
          },1000)
      })
    },

    fakeApiCallEditTopic(shouldResolve, payload) {
      return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (shouldResolve === true) {
              var obj = this.topics.find(item => item.id === payload.id);
              if (obj) {
                _.assign(obj,payload);
              }
              return resolve(payload)
            } else {
              return reject({
                topic: [{field: "name_en", error_code: "validation_required"}, {field: "name_sv", error_code: "validation_required"}],
                sub_topics: [{field: 'sub_topic_name_en',  error_code: 'validation_required'},{field: 'sub_topic_name_en',  error_code: 'validation_required'}]
              })
            }
          },1000)
      })
    },


// #################### END FAKE API CALLS ###########

    async removeTopic(payload) {
        try{
          NProgress.start();
          const topic = await axios.delete(this.baseUrl + '/topics/' + payload.id)
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
    async newTopic(payload) {
      try {
        NProgress.start();
        const topic = await axios.post(this.baseUrl + '/topics', payload)
        console.log(topic);
        return topic;
        //this.getTopicById(topic.id);
      } catch (errors) {
        if (errors) {
          console.log('backend new topic errors:',errors);
          return errors;
        }
      } finally {
        NProgress.done();
      }
    }
  }
});
