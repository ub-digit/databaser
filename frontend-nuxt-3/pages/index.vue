<template>
  <div class="container">
    <div class="page-info">
      <div class="row justify-content-md-center">
        <div class="col-md-8 col-lg-6">
          <h1 class="page-title">{{ t("views.home.title") }}</h1>
          <p class="lead">{{ t("views.home.desc") }}</p>
        </div>
      </div>
    </div>

    <div class="alertbox">
      <Alert :url="alertURL"/> 
    </div>
    <div class="popular">
      <PopularDBList :key="getLocale()"/>
    </div>
    <div class="search">
      <Searchbox v-model="searchStr" @clearSearch="clearSearch" @submitSearch="submitSearch" />
    </div>

    <div class="row">
      <div class="col-12 col-md-4">
        <aside v-if="databases && databases._meta" class="facet-filter-area">
          <div class="filters">
            <div class="topics">
              <div>
                <FilterTopics :filters="filters" :topics="databases.filters.topics" @setTopic="setTopic" @toggleSubTopic="toggleSubTopic" @clearAllTopicsAndSubTopics="clearAllTopicsAndSubTopics"/>
              </div>
            </div>

            <div class="mediatypes">
              <div>
                <FilterMediatypes @setMediatype="setMediatype" :filters="filters" :mediatypes="mediatypes"/>
              </div>
            </div>
            <div v-if="databases.filters.show_freely_available" class="show-free-only">
              <div>
                <FilterShowFree v-model="filters.show_free"/>
              </div>
            </div>
          </div>
        </aside>
      </div>
      <div class="col">
        <main>
          <div v-if="databases && databases.data && databases.data.length && databases._meta">
            <div class="meta">  
              <SearchCount :meta="databases._meta" />
            </div>

            <ul class="list-unstyled" v-if="databases && databases.data.length">
              <li v-for="db in database_list_to_render" :key="db.id">
                <DatabaseRow :db="db" />
              </li>
            </ul>
            <div v-if="databases.data.length > NumberToDisplay" class="d-grid">
              <button class="btn btn-primary" :class="{disabled: !paginated}" v-if="paginated" @click="paginated = false">{{ t('views.home.show_all')}}</button>
            </div>
          </div>
          <div v-else>
            {{ t("views.home.no_result") }}
          </div>
        </main>
      </div>
    </div>
</div>
</template>

<script setup>
import _ from "lodash"; 
const {t, getLocale} = useI18n();
const config = useRuntimeConfig();
const route = useRoute();
const router = useRouter();
const paginated = ref(true);
const NumberToDisplay = 20;
const alertURL = ref(config.public.API_BASE_URL + "alert?" + "lang=" + getLocale());

const getSubTopics = () => {
    if (route.query.sub_topics && Array.isArray(route.query.sub_topics)) {
      return route.query.sub_topics.map(Number)
    } else if (route.query.sub_topics) {
      let arr = [];
      arr.push(parseInt(route.query.sub_topics))
      return arr;
    } 
    return [];
  }
const getShowFree = () => {
  if (route.query.show_free === "false" || route.query.show_free === undefined) {
    return false;
  }
  return true;
  route.query.show_free ? route.query.show_free : undefined
}
const filters = reactive({
  topic: route.query.topic ? parseInt(route.query.topic) : undefined,
  sub_topics: getSubTopics(),
  mediatype: route.query.mediatype ? parseInt(route.query.mediatype) : undefined,
  show_free: getShowFree(),
  search: route.query.search ? route.query.search : undefined,
});
 const filters_for_api = computed(() => {
  const deepClone = _.cloneDeep(filters);
  deepClone.lang = getLocale();
  return deepClone;
}); 
const searchStr = ref(filters.search);
// const { data: databases, pending, error, refresh } = await useFetch(config.public.API_BASE_URL + 'databases/', {
//   params: filters_for_api,
//   onRequest({ request, options }) {
//     paramsSerializer(options.params);
//   }
// });

const { data: databases, pending, error, refresh } = await useFetch("/api/databases", {
  params: filters_for_api,
  onRequest({ request, options }) {
    paramsSerializer(options.params);
  }
});
// console.log(databases)

const database_list_to_render = computed(() => {
  if (paginated.value) {
    return databases.value.data.slice(0,NumberToDisplay-1);
  } 
  return databases.value.data;
});

const sub_topics = computed(() => {
  if (filters && filters.topic) {
    return databases.value.filters.topics.find((topic) => topic.id === filters.topic)
      .sub_topics;
  }
});

const mediatypes = computed(() => {
  if (!filters.mediatype) {
    return databases.value.filters.mediatypes;
  } else {
    return databases.value.filters.mediatypes.filter(
      (mediatype) => mediatype.id === filters.mediatype
    );
  }
});


watch(
  filters,
  () => {
    router.push({query: {...filters}})
  },
  { deep: true }    
);

function setTopic(id) {
  if (id === filters.topic) {
    filters.topic = undefined;
    filters.sub_topics = [];
  } else {
    filters.topic = id;
  }
}

function resetFilters() {
  //filters.lang = getLocale(); // TODO: connect to locale
  filters.topic = undefined;
  filters.sub_topics = [];
  filters.mediatype = undefined;
  filters.show_free = undefined;
  filters.search = undefined;
}

function clearSearch() {
  searchStr.value = undefined;
  submitSearch();
}

function clearAllTopicsAndSubTopics() {
  filters.topic = undefined;
  filters.sub_topics = [];
}

function toggleSubTopic(id) {
  if (filters.sub_topics.includes(id)) {
    let index = filters.sub_topics.findIndex((item) => id === item);
    filters.sub_topics.splice(index, 1);
  } else {
    filters.sub_topics.push(id);
  }
}

function setMediatype(id) {
  if (id === filters.mediatype) {
    filters.mediatype = undefined;
  } else {
    filters.mediatype = id;
  }
}
function submitSearch() {
  resetFilters();
  filters.search = searchStr.value;
}

function paramsSerializer(params) {
  //https://github.com/unjs/ufo/issues/62
  if (!params) {
    return;
  }
  Object.entries(params).forEach(([key, val]) => {
    if (typeof val === "object" && Array.isArray(val) && val !== null) {
      params[key + "[]"] = val.map((v) => JSON.stringify(v));
      delete params[key];
    } 
  });
}
</script>

<style lang="scss">
  .no-result {
    font-size: 1.2em;
    color: #757575;
  }
  
  .page-info {
    margin-bottom: 40px;
    h1 {
      &.page-title {
        margin-bottom: 10px;
      }
    }
    .lead {
      font-weight: bold;
    }
  }
  .popular {
    margin-bottom: 20px;
  }
  .facet-filter-area {
    border: 1px solid #eeeeee;
    border-bottom: none;
    overflow: hidden;
    border-radius: 4px;
    margin-bottom: 20px;
    .facet-header {
      &:focus-visible {
        border: 1px solid rgb(15, 15, 15);
      }
      &.active {
        background-color: #025da6;
        color: white;
      }
      &:last-of-type {
        /*border-bottom: none;*/
      }
      cursor: pointer;
      background: #f0f0f0;
      padding: 15px;
      border: none;
      border-bottom: 1px solid #cccccc;
    }
    .facet-filter {
      &:last-of-type {
        // .facet-header {
        //   border-bottom: none;
        // }
      }
    }
  }
</style>