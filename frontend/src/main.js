import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import { i18n } from "./locales";
import { library } from "@fortawesome/fontawesome-svg-core";
import {faArrowLeft, faArrowRight, faTimes, faChevronDown, faChevronUp, faPlus, faMinus, faLock, faLockOpen} from "@fortawesome/free-solid-svg-icons";
import {faSquare, faCheckSquare} from "@fortawesome/free-regular-svg-icons";

import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

import "./scss/custom.scss";

library.add(faArrowLeft, faArrowRight, faChevronDown, faChevronUp, faTimes, faPlus, faMinus, faSquare, faCheckSquare, faLock, faLockOpen);

createApp(App)
  .component("font-awesome-icon", FontAwesomeIcon)
  .use(i18n)
  .use(store)
  .use(router)
  .mount("#app");
