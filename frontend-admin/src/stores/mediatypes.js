
import { defineStore } from "pinia";
import _ from 'lodash'; 

export const useMediatypesStore = defineStore({
  id: "mediatypes",
  state: () => {
    return {
        mediatypes:  [
          {
            id: 1,
            name_sv: "mediatype 1 (sv)",
            name_en: "mediatype 1 (en)",
          },
          {
            id: 2,
            name_sv: "mediatype 2 (sv)",
            name_en: "mediatype 2 (en)",
          },        
        ]
      } 
  
  },
  getters: {
    getMediatypeById: (state) => (id) => {
        try {
          return state.mediatypes.find((mediatype) => mediatype.id === parseInt(id) );
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
              mediatype: 'Error while saving mediatype',
            }),
          1000
        )
      })
    },
    removeMediatype(payload) {
        try {
            this.mediatypes.splice(this.mediatypes.indexOf(payload), 1)
        } catch (err)  {
          console.log(err.message)
        }
    },
    async updateMediatype(payload) {
        try {
           //await this.fakeApiCall(payload)
            // http://shzhangji.com/blog/2018/04/17/form-handling-in-vuex-strict-mode/
            var obj = this.mediatypes.find(item => item.id === payload.id);
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
    async newMediatype(payload) {
      try {
       // await this.fakeApiCall(payload)
        payload.id = parseInt(_.now());
        this.mediatypes.push(payload)
      } catch (inputErrors) {
        if (inputErrors) {
          console.log(`backend error: ${ inputErrors }`);
          return inputErrors;
        }
      }
    }
  }
});
