<template>
  <div class="home">
    <div class="page-info">
      <div class="row justify-content-md-center">
        <div class="col-md-10 col-lg-6">
          <h1 class="page-title">{{ $t("views.home.title") }}</h1>
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
          <FreelyAccessibleFilter :show_free="show_free" @updateShowFreeFilter="updateShowFreeFilter"/>
        </aside>
      </div>  
      <div class="col">
        <main v-if="databases._meta"> <!--- todo: fix zero state inside component -->
            <DatabaseList :databases="databases" :sort_order="sort_order" :sortOrders="sortOrders" @updateSortOrderSelected="updateSortOrderSelected"/>
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
import { useStore } from '@/pinia/store';
import { mapActions } from "pinia";

export default {
  name: "Home",
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
      default: []
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
  components: {
    PopularDBList,
    TopicsFilter,
    DatabaseList,
    MediatypeFilter,
    FreelyAccessibleFilter,
    SearchBar
  },
  watch: {
    async '$route.query'(params) {
    },
  },
  data() {
    return {
      popularDatabases: [],
      databases: [],
      sortOrders: [
        {id:'asc', text: this.$i18n.t('components.sortorders.asc')}, 
        {id:'desc', text: this.$i18n.t('components.sortorders.desc')}, 
        {id:'rel', text: this.$i18n.t('components.sortorders.rel') }
      ],
    };
  },
  async created() {
  },

  async updated() {
  },
  async mounted() {
    this.fetchData();
  },
  computed: {
    
  },
  methods: {
    ...mapActions(useStore, ['fetchDatabases', 'fetchPopularDatabases']),
    fetchData: async function() {
      this.databases = await this.fetchDatabases({
          topic: this.topic, 
          sub_topics: this.sub_topics,
          mediatype: this.mediatype, 
          show_free: this.show_free, 
          sort_order: this.sort_order,
          search: this.search,
          lang: this.$i18n.locale
      });
      this.popularDatabases = await this.fetchPopularDatabases({lang: this.$i18n.locale});
    },
    updateRouterParam: function(obj) {
      if (!obj) {
        obj = {};
      }
      const old_query = this.$route.query;
      const query = {...old_query, ...obj};
      this.$router.push({query})
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
};
</script>

<style lang="scss">

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
