import { createI18n } from "vue-i18n";
import { en } from "@/locales/en.js";
import { sv } from "@/locales/sv.js";

const messages = {
  en: en,
  sv: sv,
};


const i18n = createI18n({
 // locale: url_lang || "en",
  fallbackLocale: "en",
  messages,
});

export { i18n };
