import { defineStore } from 'pinia'

export const useLocaleStore = defineStore('locale', {
  state: () => {
    let data = {
      defaultLocale: "en",
      localeURLname: "lang",
      isWatched: false,
      en: {
        "seo.application_title": 'Databases - Gothenburg university library',
        "appheader.logo_link": "http://gu.se/en",
        "appheader.header_level1_link": "http://www.ub.gu.se/en",
        "appheader.header_level1": "Gothenburg University Library",
        "appheader.header_level2": "Database Search",

        "shared.access_information_code.freely_available": "Freely available",
        "shared.access_information_code.available_to_the_university_of_gothenburg": "Available to the University of Gothenburg",
        "shared.access_information_code.available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone": "Available to the University of Gothenburg, on campus only. Available to anyone using the libraries' computers",
        "shared.access_information_code.available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers": "Available to the University of Gothenburg. Available to anyone using the libraries' computers",
        "shared.terms_of_use_code.print_article_chapter": "Print article or chapter",
        "shared.terms_of_use_code.download_article_chapter": "Download article or chapter",
        "shared.terms_of_use_code.course_pack_print": "Print course pack",
        "shared.terms_of_use_code.gul_course_pack_electronic": "Upload course pack to learning management system",
        "shared.terms_of_use_code.scholarly_sharing": "Scholarly sharing",
        "shared.terms_of_use_code.interlibrary_loan": "Interlibrary loan",
        "components.popular_db_list.title": "Popular databases",

      
        "components.database_list_row.recommended": "Recommended",
        "components.database_list_row.link_prefix": "Directly to",
        "components.database_list_row.is_new": "new",
        "components.database_list_row.is_trial": "trial",

        "components.searchcount.meta": "Found {found} of {total} databases:",

        "components.topics_filter.label_topic": "Subject",
        "components.topics_filter.label_sub_topics": "Subject terms", 
        "components.mediatype_filter.label": "Media type",
        "components.freely_accessible_filter.label": "Show freely accessible",

        "components.search_bar.placeholder": "Title, subject, supplier...",
        "components.search_bar.submit": "Search",
         

        "views.home.title": "Database search",
        "views.home.desc": "Enter the database title to find the database you are looking for. Limit your search by subject, subject terms and media types to find databases within your subject area.",
        "views.home.no_result": "No database was found. Change your search and try again.",
        "views.home.show_all": "Show all",

        "views.database.title": "Database",
        "views.database.backButton": "Back to search result",
        "views.database.homeButton": "To list of databases",
        "views.database.subjects": "Subjects",
        "views.database.mediatypes": "Media types",
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
        "nav.appname": "Databaser | Göteborgs universitetsbibliotek",
        "nav.home": "Hem",
        "nav.about": "Om",
        "home.heading": "Hemsida",
        "about.heading": "Omsida",
        "home.paragraph.prelink": "Här är en",
        "home.paragraph.postlink": "i en paragraf",
        "home.paragraph.linktext": "länk till omsidan",
        "locale.other_lang": "English",
        "locale.other_locale_code": "en",
      }
    }
    let locale = fetchLocaleFromURL(data.localeURLname)
    if(!data[locale]) {
      locale = data.defaultLocale
    }
    data["locale"] = locale
    // console.log("Locale", data.locale)
    return data
  },
  actions: {
    setLocale(locale) {
      if(this[locale]) {
        this.locale = locale
      }
      return this.locale
    }
  }
})

export const useI18n = () => {
  const locale = useLocaleStore()
  const route = useRoute()
  if (!locale.isWatched) {
    watchEffect(() => {
      if(!route.query[locale.localeURLname] && route.query.lang !== locale.locale) {
        const router = useRouter()
        let newQuery = {
          ...route.query,
          lang: locale.locale
        }
        // console.log("watchEffect", route.path, newQuery)
        router.replace({query: newQuery})
       
      }
    })
    locale.isWatched = true;
  }


  const interp = (text, args) => {
    if(text) {
      return text.replace(/{([^}]+)?}/gm, (match, p1) => {
        return args[p1] || ""
      })
    }
    return text
  }

  const t = (code, args) => {
    const currentLocale = locale.locale || locale.defaultLocale
    if(!currentLocale || !locale[currentLocale]) { return code }
    const translation = locale[currentLocale][code] || code
    return interp(translation, args)
  }

  const toggleLocale = () => {
    const newLocale = locale.locale == "sv" ? "en" : "sv"
    locale.setLocale(newLocale)
  }

  const setLocale = (newLocale) => {
    // console.log("setLocale", newLocale)
    return locale.setLocale(newLocale)
  }

  const getLocale = () => {
    // console.log("getLocale", locale.locale)
    return locale.locale
  }

  return {
    t,
    toggleLocale,
    getLocale,
    setLocale
  }
}

function fetchLocaleFromURL(localeURLname) {
  const route = useRoute()
  if(route.query[localeURLname]) {
    return route.query[localeURLname]
  } else {
    return null
  }
}
