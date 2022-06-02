import { defineStore } from "pinia";
import NProgress, { done } from 'nprogress';
import axios from 'axios';
import _ from 'lodash'; 
import nprogress from "nprogress";

export const useTopicsStore = defineStore({
  id: "topics",
  state: () => {
    return {
        baseUrl: 'https://jsonplaceholder.typicode.com',
        topics:  [
          {
            id: 1,
            name_sv: "Ekonomi",
            name_en: "Economy",
            sub_topics: [
              {
                id:21, 
                name_sv: "Ekonomi sub 21",
                name_en: "Economy sub 21",
                can_be_removed: false 
              },
              {
                id:22, 
                name_sv: "Ekonomi sub 22",
                name_en: "Economy sub 22",
                can_be_removed: false
              },
              {
                id:23, 
                name_sv: "Ekonomi sub 23",
                name_en: "Economy sub 23",
                can_be_removed: true
              }
            ]
          },
          {
            id: 2,
            name_sv: "Gender studies sv 23",
            name_en: "Gender studies 23",
            sub_topics:[
              {
                id:324532, 
                name_sv: "Gender sub 324532",
                name_en: "Gender sub 324532",
                can_be_removed: false
              }
            ]
          },
          {
            id: 3,
            name_sv: "Teknologi",
            name_en: "Technology",
            sub_topics:[
              {
                id:233432,
                name_sv: 'ooopps',
                name_en: 'ooops en',
                can_be_removed: false
              }
            ]
          },
        ]
      } 
  
  },
  getters: {
    getTopicById: (state) => (id) => {
        try {
          return state.topics.find((topic) => topic.id === parseInt(id) );
        } catch (err) {
          console.log(err.message);
        }
      }
  },
  actions: {
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

    removeTopic(payload) {
        try {
            this.topics.splice(this.topics.indexOf(payload), 1)
        } catch (err)  {
          console.log(err.message)
        }
    },
    async updateTopic(payload) {
        try {
          NProgress.start();
           const topic = await this.fakeApiCallEditTopic(true, payload)
           //const topic = await axios.put(this.baseUrl + '/topics', payload)
           console.log(topic);
           this.getTopicById(topic.id);
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
        const topic = await this.fakeApiCallNewTopic(false, payload);
        //const topic = await axios.post(this.baseUrl + '/topics', payload)
        console.log(topic);
        this.getTopicById(topic.id);
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
