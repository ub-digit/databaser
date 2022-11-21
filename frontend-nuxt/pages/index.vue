<template>
  <div class="container">
    <div class="page-info">
      <div class="row justify-content-lg-center">
        <div class="col-lg-10 col-xl-6">
          <h1 class="page-title">{{ $t("views.home.title") }}</h1>
          <p class="lead">{{ $t("views.home.desc") }}</p>
        </div>
      </div>
    </div>
    <Alert :url="alertURL"/>
    <div v-if="popularDatabases" class="popular">
      <PopularDBList :databases="popularDatabases" />
    </div>
    <div class="searchbar">
      <SearchBar :search="search" @updateSearch="updateSearch" />
    </div>

    <div class="row">
      <div class="col-12 col-lg-4">
        <aside v-if="databases && databases._meta" class="facet-filter-area">
          <TopicsFilter
            :topics="databases.filters.topics"
            :topic="topic"
            :sub_topics="sub_topics"
            @updateFilterSubTopics="updateFilterSubTopics"
            @updateFilterTopic="updateFilterTopic"
            @clearAllSelected="clearAllSelected"
          />
          <mediatypeFilter :mediatypes="databases.filters.mediatypes" :mediatype="mediatype" @updateFilterMediatype="updateFilterMediatype"/>
          <FreelyAccessibleFilter v-if="databases.filters.show_freely_available" :show_free="show_free" @updateShowFreeFilter="updateShowFreeFilter"/>
        </aside>
      </div>  
      <div class="col">
        <main v-if="databases && databases.data && databases.data.length && databases._meta"> <!--- todo: fix zero state inside component -->
            <DatabaseList :databases="databases" :sort_order="sort_order" :sortOrders="sortOrders" @updateSortOrderSelected="updateSortOrderSelected"/>
        </main>
        <main v-else>
          <div v-if="databases && databases.data && databases.data.length === 0" class="col no-result">
            {{ $t("views.home.no_result") }}
          </div>
        </main>
      </div>
    </div>
  </div>
</template>

<router lang="js">
{
  props: function(route) {
    return {
      sort_order: route.query.sort_order ? route.query.sort_order : undefined,
      topic: route.query.topic ? parseInt(route.query.topic) : undefined,
      sub_topics: (() => {
        let sub_topics = [];
        if (route.query.sub_topics) {
          if (Array.isArray(route.query.sub_topics)) {
            sub_topics = [...route.query.sub_topics].map(Number);
          } else {
            sub_topics.push(parseInt(route.query.sub_topics));
          }
        }
        return sub_topics;
      })(),
      mediatype: route.query.mediatype ? parseInt(route.query.mediatype) : undefined,
      show_free: (() => {
        if (route.query.show_free === "true") { 
          return true 
        } 
        else { 
          return false
        }
      })(), 
      search: route.query.search ? route.query.search : undefined,

    };
  },
}  
</router>
<script>
export default {
  layout: 'default',
  name: 'IndexPage',
  props: {
    sort_order: {
      default: "asc",
      type: String
    },
    topic: {
      type: Number,
      default: null
    }, 
    sub_topics: {
      type: Array,
      default: function () {
        return []
      }
    },
    mediatype: {
      type: Number,
      default: null
    },
    show_free: {
      type: Boolean,
      default: false
    },
    search: {
      type: String,
      default: null
    }
  },
  data() {
    return {
      popularDatabases: [],
      databases: {},
      sortOrders: [
        {id:'asc', text: this.$i18n.t('components.sortorders.asc')}, 
        {id:'desc', text: this.$i18n.t('components.sortorders.desc')}, 
        {id:'rel', text: this.$i18n.t('components.sortorders.rel') }
      ],
    };
  },

  computed: {
    alertURL() {
          return this.$store.state.alertURL
      },
  },
  async fetch() {
    this.popularDatabases = await this.$store.dispatch('fetchPopularDatabases', {lang: this.$i18n.locale})
    await this.fetchData();
  },
  head() {
    return {
        title: this.$i18n.t('seo.application_title')
    }
  },
  methods: {
    fetchData: async function() {
        let that = this;
        this.databases = await this.$store.dispatch('fetchDatabases', {
          topic: this.topic, 
          sub_topics: this.sub_topics,
          mediatype: this.mediatype, 
          show_free: this.show_free, 
          sort_order: this.sort_order,
          search: this.search,
          lang: this.$i18n.locale
      });
    },
    updateRouterParam: function(obj) {
      if (!obj) {
        obj = {};
      }
      const old_query = this.$route.query;
      const query = {...old_query, ...obj};
      this.$router.replace({query})
      setTimeout(() => {this.fetchData()}, 0);
    },
    updateSearch: function(search) {
      const settings = {
        search: search,
        topic: undefined,
        show_free: undefined,
        sub_topics: undefined,
        mediatype: undefined
      }
      this.updateRouterParam(settings)
    },
    updateSortOrderSelected: function (sort_order) {
      this.updateRouterParam({sort_order: sort_order});
    },
    clearAllSelected: function() {
      this.updateRouterParam({topic: undefined, sub_topics: undefined})
    },
    updateFilterTopic: function(topic) {
      this.updateRouterParam({topic: topic});
    },
    updateFilterSubTopics: function(topics) {
      let sub_topics = null; 
      if (topics) {
        sub_topics = [...topics]
      }
      this.updateRouterParam({sub_topics: sub_topics});
    },
    updateFilterMediatype: function (mediatype) {
      this.updateRouterParam({mediatype: mediatype});
    },
    updateShowFreeFilter: function (show) {
      let showFree = undefined;
      if (show) {
        showFree = true;
      }
      this.updateRouterParam({show_free: showFree });

    }
  },
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
        .facet-header {
          border-bottom: none;
        }
      }
    }
  }
  </style>
