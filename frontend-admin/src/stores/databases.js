
import { defineStore } from "pinia";
import _ from 'lodash'; 

export const useDatabasesStore = defineStore({
  id: "databases",
  state: () => {
    return {
        databases:  [
          {
            id: 1,
            title_en: "database 1 (en)",
            title_sv: "database 1 (sv)",
            desc_en: "description goes here",
            desc_sv: "Beskrivning  här"
          },
          {
            id: 2,
            title_en: "database 2 (en)",
            title_sv: "database 2 (sv)",
            desc_en: "descripton goes here",
            desc_sv: "beskrivning här"
          },       
        ]
      } 
  },
  getters: {
    getDatabaseById: (state) => (id) => {
        try {
          return state.databases.find((db) => db.id === parseInt(id) );
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
              database: 'Error while saving database',
            }),
          1000
        )
      })
    },
    removeDatabase(payload) {
        try {
            this.databases.splice(this.databases.indexOf(payload), 1)
        } catch (err)  {
          console.log(err.message)
        }
    },
    async updateDatabase(payload) {
        try {
           //await this.fakeApiCall(payload)
            // http://shzhangji.com/blog/2018/04/17/form-handling-in-vuex-strict-mode/
            var obj = this.databases.find(item => item.id === payload.id);
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
    async newDatabase(payload) {
      try {
       // await this.fakeApiCall(payload)
        payload.id = parseInt(_.now());
        this.databases.push(payload)
      } catch (inputErrors) {
        if (inputErrors) {
          console.log(`backend error: ${ inputErrors }`);
          return inputErrors;
        }
      }
    }
  }
});
