import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import router from "./router";
import { plugin, defaultConfig } from '@formkit/vue';
import {useFontawesome} from '@/plugins/fontawesome.js';
import Toast from 'vue-toastification';
import "@/scss/custom.scss";
import 'nprogress/nprogress.css';
import { i18n } from "./locales";

const app = createApp(App);
const {FontAwesomeIcon} = useFontawesome();
app.component("font-awesome-icon", FontAwesomeIcon);

app.use(Toast, { timeout: 3000, position: 'top-center', transition: 'Vue-Toastification__fade', hideProgressBar: true });
app.use(createPinia());
app.use(router);
app.use(i18n);
app.use(plugin, defaultConfig);
app.mount("#app");
