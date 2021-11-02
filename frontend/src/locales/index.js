import { createI18n } from "vue-i18n";
import { en } from "@/locales/en.js";
import { sv } from "@/locales/sv.js";

const messages = {
  en: en,
  sv: sv,
};

let url = new URL(window.location.href);
let url_lang = url.searchParams.get("lang");

const i18n = createI18n({
  locale: url_lang || "en",
  fallbackLocale: "en",
  messages,
});

export { i18n };
