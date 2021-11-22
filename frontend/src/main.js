import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import axios from 'axios';
import { i18n } from "./locales";
import { library } from "@fortawesome/fontawesome-svg-core";
import {faArrowLeft, faArrowRight, faTimes, faChevronDown, faChevronUp, faPlus, faMinus, faLock, faLockOpen} from "@fortawesome/free-solid-svg-icons";
import {faSquare, faCheckSquare} from "@fortawesome/free-regular-svg-icons";

import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

import "./scss/custom.scss";

library.add(faArrowLeft, faArrowRight, faChevronDown, faChevronUp, faTimes, faPlus, faMinus, faSquare, faCheckSquare, faLock, faLockOpen);


const local_url = '/cgi-bin/backend.cgi'
axios.get(local_url).then((result) => {
  return result.data.backend_url
},() => {
  return process.env["VUE_APP_BACKEND_BASE_URL"] || "http://localhost:4000"
}).then((baseURL) => {
  let app = createApp(App)
  app.baseURL = baseURL
  app
  .component("font-awesome-icon", FontAwesomeIcon)
  .use(i18n)
  .use(store)
  .use(router)
  .mount("#app");
})
