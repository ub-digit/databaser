
import { defineStore } from "pinia";
import _ from 'lodash';
import axios from 'axios';
import nProgress, { done } from 'nprogress';
import { inject } from 'vue'

export const useAlertStore = defineStore({
  id: "alert",
  state: () => {
    return {
      baseUrl: inject("baseURL")
    }
  },
  getters: {
  },
  actions: {
    async getAlertMessage() {
      try {
       const result = await axios.get(`${this.baseUrl}/alert/`);
       return result.data;
        //return {en: {msg: "hellog from english"}, sv: {msg: "hello from swedish"}};// result.data;
       // return {en:"english message", show_alert_message:false, sv:"svenskt meddelande"}
      } catch (err) {
        console.log(err.message);
      }
    },
    async saveAlertMessage(payload) {
      try {
        nProgress.start();
        //const result = payload;
        const result = await axios.post(this.baseUrl + '/alert', payload)
        return result;
      } 
      catch (errors) {
      } finally {
        nProgress.done();
      }
    }
  }
});
