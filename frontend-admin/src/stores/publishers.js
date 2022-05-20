
import { defineStore } from "pinia";
import _ from 'lodash'; 

export const usePublishersStore = defineStore({
  id: "publishers",
  state: () => {
    return {
        publishers:  [
          {
            id: 1,
            title: "Publisher 1",
          },
          {
            id: 2,
            title: "Publisher 2",
          },        ]
      } 
  },
  getters: {
    getPublisherById: (state) => (id) => {
        try {
          return state.publishers.find((publisher) => publisher.id === parseInt(id) );
        } catch (err) {
          console.log(err.message);
        }
      }
  },
  actions: {
    fakeApiCall(data) {
      return new Promise((_, reject) => {
        setTimeout(
          () =>
            reject({
              publisher: 'Error while saving publisher',
            }),
          1000
        )
      })
    },
    removePublisher(payload) {
        try {
            this.publishers.splice(this.publishers.indexOf(payload), 1)
        } catch (err)  {
          console.log(err.message)
        }
    },
    async updatePublisher(payload) {
        try {
           //await this.fakeApiCall(payload)
            // http://shzhangji.com/blog/2018/04/17/form-handling-in-vuex-strict-mode/
            var obj = this.publishers.find(item => item.id === payload.id);
            if (obj) {
                _.assign(obj,payload);
            }
        } catch (inputErrors) {
            if (inputErrors) {
              console.log(`backend error: ${ inputErrors}` );
              return inputErrors;
            }
        }
    },
    async newPublisher(payload) {
      try {
       // await this.fakeApiCall(payload)
        payload.id = parseInt(_.now());
        this.publishers.push(payload)
      } catch (inputErrors) {
        if (inputErrors) {
          console.log(`backend error: ${ inputErrors }`);
          return inputErrors;
        }
      }
    }
  }
});
