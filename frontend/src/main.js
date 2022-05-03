import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
//import store from "./store";
import { createPinia } from 'pinia'
import axios from 'axios';
import { i18n } from "./locales";
import { library } from "@fortawesome/fontawesome-svg-core";
import {faInfoCircle, faExclamationTriangle, faGlobe, faArrowLeft, faArrowRight, faTimes, faChevronDown, faChevronUp, faPlus, faMinus, faLock, faLockOpen, faExclamation, faCompass} from "@fortawesome/free-solid-svg-icons";
import {faSquare, faCheckSquare} from "@fortawesome/free-regular-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

import "./scss/custom.scss";
import 'nprogress/nprogress.css';

library.add(faInfoCircle, faExclamationTriangle, faExclamation, faCompass, faGlobe, faArrowLeft, faArrowRight, faChevronDown, faChevronUp, faTimes, faPlus, faMinus, faSquare, faCheckSquare, faLock, faLockOpen);


const local_url = '/cgi-bin/backend.cgi'
axios.get(local_url).then((result) => {
  return result.data
},() => {
  return {
    backend_url: process.env["VUE_APP_API_BASE_URL"] || "http://localhost:4000",
    alert_url: process.env["VUE_APP_ALERT_URL"] || "http://localhost:4000/alert"
  }
}).then((data) => {
  let app = createApp(App)
  app.baseURL = data.backend_url
  app
  .provide('baseURL', data.backend_url)
  .provide('alertURL', data.alert_url)
  .component("font-awesome-icon", FontAwesomeIcon)
  .use(createPinia())
  .use(i18n)
  .use(router)
  .mount("#app");
})
