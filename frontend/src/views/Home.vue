<template>
  <div class="home">
    <div class="page-info">
      <div class="row justify-content-md-center">
        <div class="col-md-10 col-lg-6">
          <h1>{{ $t("views.home.title") }}</h1>
          <p class="lead">{{ $t("views.home.desc") }}</p>
        </div>
      </div>
    </div>

    <div class="popular">
      <PopularDBList :databases="popularDatabases" />
    </div>

    <div class="searchbar">
      <SearchBar :search="search" @updateSearch="updateSearch" />
    </div>

    <div class="row">
      <div class="col-12 col-md-4">
        <aside v-if="databases._meta" class="facet-filter-area">
          <TopicsFilter
            :topics="databases.filters.topics"
            :topic="topic"
            :sub_topics="sub_topics"
            @updateFilterSubTopics="updateFilterSubTopics"
            @updateFilterTopic="updateFilterTopic"
            @clearAllSelected="clearAllSelected"
          />
          <mediatypeFilter :mediatypes="databases.filters.mediatypes" :mediatype="mediatype" @updateFilterMediatype="updateFilterMediatype"/>
          <FreelyAccessibleFilter :showFree="showFree" @updateShowFreeFilter="updateShowFreeFilter"/>
        </aside>
      </div>  
      <div class="col">
        <main v-if="databases._meta"> <!--- todo: fix zero state inside component -->
            <DatabaseList :databases="databases" :sortOrder="sortOrder" :sortOrders="sortOrders" @updateSortOrderSelected="updateSortOrderSelected"/>
        </main>
      </div>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import PopularDBList from "../components/PopularDBList.vue";
import TopicsFilter from "../components/TopicsFilter.vue";
import DatabaseList from "../components/DatabaseList.vue";
import MediatypeFilter from "../components/MediatypeFilter.vue";
import FreelyAccessibleFilter from "../components/FreelyAccessibleFilter.vue";
import SearchBar from "../components/SearchBar.vue";
export default {
  name: "Home",
  props: {
    lang: {
      default: 'en',
      type: String
    },
    sortOrder: {
      default: "asc",
      type: String
    },
    topic: {
      type: Number,
      default: null
    }, 
    sub_topics: {
      type: Array,
      default: []
    },
    mediatype: {
      type: Number,
      default: null
    },
    showFree: {
      type: Boolean,
      default: false
    },
    search: {
      type: String,
      default: null
    }
  },
  components: {
    PopularDBList,
    TopicsFilter,
    DatabaseList,
    MediatypeFilter,
    FreelyAccessibleFilter,
    SearchBar
  },
  watch: {
    '$i18n.locale'(lang) {
      this.updateRouterParam({lang: lang});
    },
    async '$route.query'(params) {
      const query = this.$route.query;
      this.databases = await this.$store.dispatch("fetchDatabases", {
          topic: params.topic, 
          sub_topics: params.sub_topics,
          mediatype: params.mediatype, 
          show_free: params.showFree, 
          sortOrder: params.sortOrder,
          search: params.search,
          lang: params.lang // this.$i18n.locale  
      });
    },


  },
  data() {
    return {
      popularDatabases: [],
      databases: [],
      sortOrders: [
        {id:'asc', text:"Ascending"}, 
        {id:'desc', text:"Descending"}, 
        {id:'rel', text:"Relevance"}
        ],
    };
  },
  async created() {
    this.$i18n.locale = this.lang;
  },

  async updated() {
  },
  async mounted() {
    this.databases = await this.$store.dispatch("fetchDatabases", {
      topic: this.topic, 
      sub_topics: this.sub_topics,
      mediatype: this.mediatype, 
      show_free: this.showFree, 
      sortOrder: this.sortOrder,
      search: this.search,
      lang: this.lang // this.$i18n.locale  
    });
    this.popularDatabases = await this.$store.dispatch("fetchPopularDatabases");
  },

  methods: {
    updateRouterParam: function(obj) {
      if (!obj) {
        obj = {};
      }
      const old_query = this.$route.query;
      const query = {...old_query, ...obj};
      this.$router.push({query})
    },
    updateSearch: function(search) {
      this.updateRouterParam({search: search})
    },
    updateSortOrderSelected: function (sortOrder) {
      this.updateRouterParam({sortOrder: sortOrder});
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
      this.updateRouterParam({showFree: showFree });

    }
  },
  computed: {

  },
};
</script>

<style lang="scss">
.page-info {
  margin-bottom: 40px;
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
