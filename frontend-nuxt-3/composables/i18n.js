import { defineStore } from "pinia";

export const useLocaleStore = defineStore("locale", {
  state: () => {
    let data = {
      defaultLocale: "en",
      localeURLname: "lang",
      isWatched: false,
      en: {
        "seo.application_title":
          "Database search - Gothenburg university library",
        "appheader.logo_link": "http://gu.se/en",
        "appheader.header_level1_link": "http://www.ub.gu.se/en",
        "appheader.header_level1": "Gothenburg University Library",
        "appheader.header_level2": "Databases and e-resources",

        "appfooter.contact_link": "https://www.ub.gu.se/node/189487/",
        "appfooter.contact_link_text": "Contact us about databases",

        "shared.access_information_code.freely_available": "Freely available",
        "shared.access_information_code.available_to_the_university_of_gothenburg":
          "Available to the University of Gothenburg",
        "shared.access_information_code.available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone":
          "Available to the University of Gothenburg, on campus only. Available to anyone using the libraries' computers",
        "shared.access_information_code.available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers":
          "Available to the University of Gothenburg. Available to anyone using the libraries' computers",
        "shared.terms_of_use_code.print_article_chapter":
          "Print article or chapter",
        "shared.terms_of_use_code.download_article_chapter":
          "Download article or chapter",
        "shared.terms_of_use_code.course_pack_print": "Print course pack",
        "shared.terms_of_use_code.gul_course_pack_electronic":
          "Upload course pack to learning management system",
        "shared.terms_of_use_code.scholarly_sharing": "Scholarly sharing",
        "shared.terms_of_use_code.interlibrary_loan": "Interlibrary loan",
        "shared.terms_of_use_code.ai_rules": "AI",

        "components.popular_db_list.title": "Popular databases",

        "components.database_list_row.recommended": "Recommended",
        "components.database_list_row.link_prefix": "Directly to",
        "components.database_list_row.is_new": "new",
        "components.database_list_row.is_trial": "trial",

        "components.searchcount.meta": "Found {found} of {total} databases:",

        "components.topics_filter.label_topic": "Subject area",
        "components.topics_filter.label_sub_topics": "Subject",
        "components.mediatype_filter.label": "Media types and collections",
        "components.freely_accessible_filter.label": "Show freely accessible",

        "components.search_bar.placeholder": "Title, subject, supplier...",
        "components.search_bar.input_aria_label":
          "submit database title, subject or database supplier",
        "components.search_bar.submit": "Search",

        "views.home.title": "Databases and e-resources",
        "views.home.desc":
          "Find databases to which the library subscribes and freely available resources selected by librarians. These resources will lead you to articles, statistics, business information, audio recordings, sheet music, video and more in your subject area.",
        "views.home.primo_link_text": "Try searching in Supersearch instead",
        "views.home.no_result":
          "No database was found. Try one of the following: <ul><li>Check the spelling </li><li>Use fewer or more general search terms</li><li>Empty the search field and use the subject navigation to find a database</li></ul>",
        "views.home.pre_primo_link_text":
          "You cannot search for book or article titles.",
        "views.home.show_all": "Show all",
        "views.database.title": "Database",
        "views.database.backButton": "Back to search result",
        "views.database.homeButton": "To list of databases",
        "views.database.subjects": "Subjects",
        "views.database.mediatypes": "Media types and collections",
        "views.database.vendor": "Vendor",
        "views.database.alt_title": "Alternative title",
        "views.database.terms_of_use": "Terms of use",
        "views.database.permitted": "Permitted",
        "views.database.prohibited": "Prohibited",
        "views.database.link_prefix": "To",
        "views.database.is_new": "new",
        "views.database.is_trial": "trial",

        "locale.other_lang": "Svenska",
        "locale.other_locale_code": "sv",
      },
      sv: {
        "seo.application_title": "Databassök - Göteborgs universitetsbibliotek",
        "appheader.logo_link": "http://gu.se/",
        "appheader.header_level1_link": "http://www.ub.gu.se/sv",
        "appheader.header_level1": "Göteborgs universitetsbibliotek",
        "appheader.header_level2": "Databassök",

        "appfooter.contact_link": "https://www.ub.gu.se/node/189487/",
        "appfooter.contact_link_text": "Kontakta oss om databaser",

        "shared.access_information_code.freely_available": "Fritt tillgänglig",
        "shared.access_information_code.available_to_the_university_of_gothenburg":
          "Tillgänglig för Göteborgs universitet",
        "shared.access_information_code.available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone":
          "Tillgänglig för Göteborgs universitet, endast på campus. Tillgänglig för alla från bibliotekens datorer",
        "shared.access_information_code.available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers":
          "Tillgänglig för Göteborgs universitet. Tillgänglig för alla från bibliotekens datorer",
        "shared.terms_of_use_code.print_article_chapter":
          "Skriva ut artikel eller kapitel",
        "shared.terms_of_use_code.download_article_chapter":
          "Ladda ner artikel eller kapitel",
        "shared.terms_of_use_code.course_pack_print": "Trycka kurskompendium",
        "shared.terms_of_use_code.gul_course_pack_electronic":
          "Ladda upp kurskompendium på lärplattform",
        "shared.terms_of_use_code.scholarly_sharing": "Scholarly sharing",
        "shared.terms_of_use_code.interlibrary_loan": "Fjärrlån",
        "shared.terms_of_use_code.ai_rules": "AI",

        "components.popular_db_list.title": "Populära databaser",

        "components.database_list_row.recommended": "Rekommenderad",
        "components.database_list_row.link_prefix": "Direkt till",
        "components.database_list_row.is_new": "Ny",
        "components.database_list_row.is_trial": "Test",

        "components.searchcount.meta": "Hittade {found} av {total} databaser:",

        "components.topics_filter.label_topic": "Ämnesområde",
        "components.topics_filter.label_sub_topics": "Ämne",
        "components.mediatype_filter.label": "Materialtyper och samlingar",
        "components.freely_accessible_filter.label": "Visa fritt tillgängliga",

        "components.search_bar.placeholder":
          "Databastitel, ämne, leverantör...",
        "components.search_bar.input_aria_label":
          "ange databastitel, ämne eller databasleverantör",
        "components.search_bar.submit": "Sök",

        "views.home.title": "Databaser och e-resurser",
        "views.home.desc":
          "Hitta databaser som biblioteket prenumererar på och fritt tillgängliga resurser utvalda av bibliotekarier. Resurserna leder dig till artiklar, statistik, företagsinformation, ljudupptagningar, noter, video och annat inom ditt ämnesområde.",
        "views.home.primo_link_text": "Prova att söka i Supersök istället",
        "views.home.no_result":
          "Ingen databas hittades. Försök med något av följande: <ul><li>Kontrollera stavningen </li><li>Använd färre eller mer allmänna söktermer</li><li>Töm sökrutan och använd ämnesnavigeringen för att hitta en databas</li></ul>",
        "views.home.pre_primo_link_text":
          "Det går inte att söka efter bok- eller artikeltitlar.",
        "views.home.show_all": "Visa alla",

        "views.database.title": "Databas",
        "views.database.backButton": "Tillbaka till resultatlistan",
        "views.database.homeButton": "Till lista över databaser",
        "views.database.subjects": "Ämnen",
        "views.database.mediatypes": "Materialtyper och samlingar",
        "views.database.vendor": "Leverantör",
        "views.database.alt_title": "Alternativ titel",
        "views.database.terms_of_use": "Användningsvillkor",
        "views.database.permitted": "Tillåtet",
        "views.database.prohibited": "Otillåtet",
        "views.database.link_prefix": "Till",
        "views.database.is_new": "Ny",
        "views.database.is_trial": "Test",

        "locale.other_lang": "English",
        "locale.other_locale_code": "en",
      },
    };
    let locale = fetchLocaleFromURL(data.localeURLname);
    if (!data[locale]) {
      locale = data.defaultLocale;
    }
    data["locale"] = locale;
    // console.log("Locale", data.locale)
    return data;
  },
  actions: {
    setLocale(locale) {
      if (this[locale]) {
        this.locale = locale;
      }
      return this.locale;
    },
  },
});

export const useI18n = () => {
  const locale = useLocaleStore();
  const route = useRoute();
  if (!locale.isWatched) {
    watchEffect(() => {
      if (
        !route.query[locale.localeURLname] &&
        route.query.lang !== locale.locale
      ) {
        const router = useRouter();
        let newQuery = {
          ...route.query,
          lang: locale.locale,
        };
        // console.log("watchEffect", route.path, newQuery)
        router.replace({ query: newQuery });
      }
    });
    locale.isWatched = true;
  }

  const interp = (text, args) => {
    if (text) {
      return text.replace(/{([^}]+)?}/gm, (match, p1) => {
        return args[p1] || "";
      });
    }
    return text;
  };

  const t = (code, args) => {
    const currentLocale = locale.locale || locale.defaultLocale;
    if (!currentLocale || !locale[currentLocale]) {
      return code;
    }
    const translation = locale[currentLocale][code] || code;
    return interp(translation, args);
  };

  const toggleLocale = () => {
    const newLocale = locale.locale == "sv" ? "en" : "sv";
    locale.setLocale(newLocale);
  };

  const setLocale = (newLocale) => {
    // console.log("setLocale", newLocale)
    return locale.setLocale(newLocale);
  };

  const getLocale = () => {
    // console.log("getLocale", locale.locale)
    return locale.locale;
  };

  return {
    t,
    toggleLocale,
    getLocale,
    setLocale,
  };
};

function fetchLocaleFromURL(localeURLname) {
  const route = useRoute();
  if (route.query[localeURLname]) {
    return route.query[localeURLname];
  } else {
    return null;
  }
}
