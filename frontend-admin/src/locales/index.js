import { createI18n } from "vue-i18n";
import { en } from "@/locales/en.js";
//import { sv } from "@/locales/en.js";

const messages = {
  en: en
};



const i18n = createI18n({
  messages
});

export { i18n };
