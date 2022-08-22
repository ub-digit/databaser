
import { defineStore } from "pinia";
import _ from 'lodash';
import axios from 'axios';

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
            desc_sv: "beskrivning här",
            terms_of_use: [
              {
                id: 1, 
                code: "print_article_chapter", 
                description_en: "",     
                description_sv: "",           
                permitted: "yes"
              },
              {
                id: 2, 
                code: "course_pack_print", 
                description_en: "",     
                description_sv: "",           
                permitted: "yes"
              },
              {
                id: 3, 
                code: "gul_course_pack_electronic", 
                description_en: "",     
                description_sv: "",           
                permitted: "n/a"
              },
              {
                id: 4, 
                code: "scholarly_sharing", 
                description_en: "",     
                description_sv: "",           
                permitted: "no"
              },
              {
                id: 5, 
                code: "download_article_chapter", 
                description_en: "",     
                description_sv: "",           
                permitted: "yes"
              },
              {
                id: 6, 
                code: "interlibrary_loan", 
                description_en: "ILL print, fax or secure electronic transmission: Permitted",     
                description_sv: "",           
                permitted: "yes"
              }
            ],
            mediatypes: [
              {
                id: 1,
                name_sv: "mediatype 1 (sv)",
                name_en: "mediatype 1 (en)",
                selected: true
              },
              {
                id: 2,
                name_sv: "mediatype 2 (sv)",
                name_en: "mediatype 2 (en)",
                selected: false
              }
            ],
            publishers: [
              {
                id: 1,
                name: "Publisher 1",
                selected: true
              },
              {
                id: 2,
                name: "Publisher 2",
                selected: false
              }
            ],
            topics: [
              {
                id: 3,
                name_sv: "main-topic sv",
                name_en: "main-topic en",
                selected: true,
                recommended: true,
                sub_topics: [
                  {
                    id: 233432,
                    topic_id: 3,
                    name_sv: "sub-topic sv",
                    name_en: "sub-topic en",
                    selected: true,
                    recommended: true,
                  }
                ]
              },
              {
                id: 4,
                name_sv: "main-topic sv",
                name_en: "main-topic en",
                selected: true,
                recommended: false,
                sub_topics: [
                  {
                    id: 233433,
                    topic_id: 4,
                    name_sv: "sub-topic sv",
                    name_en: "sub-topic en",
                    selected: false,
                    recommended: false
                  }
                ]
              }  
            ]
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
