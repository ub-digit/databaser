export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'frontend-nuxt',
    htmlAttrs: {
      lang: 'en',
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: ['~assets/scss/main.scss'],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    '@nuxtjs/style-resources',
    '@nuxtjs/fontawesome',
    '@nuxtjs/router-extras',
  ],

  fontawesome: {
    icons: {
      solid: true, // loads all solid - not recomended of course
      regular: true, // Todo: specify icons
    }
  },

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://i18n.nuxtjs.org/setup
    '@nuxtjs/i18n',
  ],

  styleResources: {
    scss: '@/assets/scss/_variables.scss'
  },
  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    // Workaround to avoid enforcing hard-coded localhost:3000: https://github.com/nuxt-community/axios-module/issues/308
    baseURL: 'http://localhost:4000',
  },

  i18n: {
    /* module options */
    baseUrl: 'http://localhost:3000',
    strategy: 'prefix_and_default',
    defaultLocale: 'sv',
    locales: [
      {
        code: 'en',
        iso: 'en-US'
      }, 
      {
        code: 'sv',
        iso: 'sv'
      } 
    ],
    vueI18n: {
      fallbackLocale: 'sv',
      messages: {
        en: {
          seo: {
            application_title: 'Databases - Gothenburg university library',
          },
          shared: {
            access_information_code: {
              freely_available: "Freely available",
              available_to_the_university_of_gothenburg: "Available to the University of Gothenburg",
              available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone: "Available to the University of Gothenburg, on campus only. Available to anyone using the libraries' computers",
              available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers: "Available to the University of Gothenburg. Available to anyone using the libraries' computers"
            },
            terms_of_use_code: {
              print_article_chapter: "Print article chapter",
              download_article_chapter: "Download article chapter",
              course_pack_print: "Course packprint",
              gul_course_pack_electronic: "Gul course pack electronic",
              scholarly_sharing: "Scholarly sharing",
              interlibrary_loan: "Interlibrary loan"
            }
          },
          components: {
            database_list: {
              meta: 'Found {found} of {total} databases:',
              show_all: 'Show all'
            },
            database_list_row: {
              recommended: "Recommended",
              link_prefix: "Directly to"
            },
            search_bar: {
              placeholder: "Title, subject, supplier...",
              submit: "Search"
            },
            the_header: {
              logo_link: "http://gu.se/en",
              header_level1_link: "http://www.ub.gu.se/en",
              header_level1: "Gothenburg University Library",
              header_level2: "Database Search",
              language_otherCode: "sv",
              language_otherName: "Svenska"
            },
            the_footer: {},
            popular_db_list: {
              title: "Popular databases",
            },
            topics_filter: {
              label_topic: "Subject",
              label_sub_topics: "Subject terms"
            },
            mediatype_filter: {
              label: "Media type"
            },
            freely_accessible_filter: {
              label: "Show freely accessible"
            },
            sortorders: {
              asc: 'Ascending',
              desc: 'Descending',
              rel: 'Relevance'
            },
            the_nav: {
              nav1: {
                title: "Homepage",
                alt: "Take me to home",
              },
              nav2: {
                title: "About page",
                alt: "Take me to about",
              },
            },
          },
          views: {
            about: {
              title: "About page",
            },
            database: {
              title: "Database",
              backButton: "Back to search result",
              subjects: "Subjects",
              mediatypes: "Media types",
              vendor: "Vendor",
              alt_title: "Alternative title",
              terms_of_use: "Terms of use",
              permitted: "Permitted",
              prohibited: "Prohibited",
              link_prefix: "To",
        
            },
            home: {
              title: "Database search",
              desc: "Enter the database title to find the database you are looking for. Limit your search by subject, subject terms and media types to find databases within your subject area.",
              no_result: "No database was found. Change your search and try again."
            },
        
          },
        
        },
        sv: {
          seo: {
            application_title: 'Databaser - Gothenburg university library',
          },
          shared: {
            access_information_code: {
              freely_available: "Freely available",
              available_to_the_university_of_gothenburg: "Available to the University of Gothenburg",
              available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone: "Available to the University of Gothenburg, on campus only. Available to anyone using the libraries' computers",
              available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers: "Available to the University of Gothenburg. Available to anyone using the libraries' computers"
            },
            terms_of_use_code: {
              print_article_chapter: "Print article chapter",
              download_article_chapter: "Download article chapter",
              course_pack_print: "Course packprint",
              gul_course_pack_electronic: "Gul course pack electronic",
              scholarly_sharing: "Scholarly sharing",
              interlibrary_loan: "Interlibrary loan"
            }
          },
          components: {
            database_list: {
              meta: 'Found {found} of {total} databases:',
              show_all: 'Show all'
            },
            database_list_row: {
              recommended: "Recommended",
              link_prefix: "Directly to"
            },
            search_bar: {
              placeholder: "Title, subject, supplier...",
              submit: "Search"
            },
            the_header: {
              logo_link: "http://gu.se/en",
              header_level1_link: "http://www.ub.gu.se/en",
              header_level1: "Gothenburg University Library",
              header_level2: "Database Search",
              language_otherCode: "en",
              language_otherName: "English"
            },
            the_footer: {},
            popular_db_list: {
              title: "Popular databases",
            },
            topics_filter: {
              label_topic: "Subject",
              label_sub_topics: "Subject terms"
            },
            mediatype_filter: {
              label: "Media type"
            },
            freely_accessible_filter: {
              label: "Show freely accessible"
            },
            sortorders: {
              asc: 'Ascending',
              desc: 'Descending',
              rel: 'Relevance'
            },
            the_nav: {
              nav1: {
                title: "Homepage",
                alt: "Take me to home",
              },
              nav2: {
                title: "About page",
                alt: "Take me to about",
              },
            },
          },
          views: {
            about: {
              title: "About page",
            },
            database: {
              title: "Database",
              backButton: "Back to search result",
              subjects: "Subjects",
              mediatypes: "Media types",
              vendor: "Vendor",
              alt_title: "Alternative title",
              terms_of_use: "Terms of use",
              permitted: "Permitted",
              prohibited: "Prohibited",
              link_prefix: "To",
        
            },
            home: {
              title: "Database search",
              desc: "Enter the database title to find the database you are looking for. Limit your search by subject, subject terms and media types to find databases within your subject area.",
              no_result: "No database was found. Change your search and try again."
            },
        
        
          },
        
        },
      }
    }
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
  }
}
