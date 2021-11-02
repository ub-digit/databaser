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

    <div class="row">
      <div class="col-12 col-md-4">
        <aside v-if="topics.length > 0" class="facet-filter-area">
          <TopicsFilter
            :topics="topics"
            :firstLevelSelectedTopicProp="filterTopicsFirstLevel"
            :secondLevelSelectedTopicsProp="filterTopicsSecondLevel"
            @updateFilterTopicsSecondLevel="updateFilterTopicsSecondLevel"
            @updateFilterTopicsFirstLevel="updateFilterTopicsFirstLevel"
          />
          <mediatypeFilter :mediatypes="mediatypes" :selectedMediatypeProp="filterMediatype" @updateFilterMediatype="updateFilterMediatype"/>
          <FreelyAccessibleFilter :showFree="filterShowFree" @updateShowFreeFilter="updateShowFreeFilter"/>
        </aside>
      </div>
      <div class="col">
        <main v-if="databases._meta">
            <DatabaseList :databases="databases" :sortOrderSelected="sortOrderSelected" :sortOrders="sortOrders" @updateSortOrderSelected="updateSortOrderSelected"/>
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
export default {
  name: "Home",
  components: {
    PopularDBList,
    TopicsFilter,
    DatabaseList,
    MediatypeFilter,
    FreelyAccessibleFilter
  },
  data() {
    return {
      popularDatabases: [],
      databases: [],
      topics: [],
      mediatypes: [],
      filterTopicsFirstLevel: null,
      filterTopicsSecondLevel: [],
      filterMediatype: null,
      filterShowFree: false,
      sortOrders: [
        {id:'asc', text:"Ascending"}, 
        {id:'desc', text:"Decending"}, 
        {id:'rel', text:"Relevance"}
        ],
      sortOrderSelected: "asc"
    };
  },
  async created() {
    const filterTopicsFirstLevel = this.$route.query.filterTopicsFirstLevel;
    if (filterTopicsFirstLevel) {
      this.filterTopicsFirstLevel = parseInt(filterTopicsFirstLevel);
    }
    const filterTopicsSecondLevel = this.$route.query.filterTopicsSecondLevel;
    if (filterTopicsSecondLevel) {
      if (Array.isArray(filterTopicsSecondLevel)) {
        this.filterTopicsSecondLevel = [...filterTopicsSecondLevel].map(Number);
      } else {
        this.filterTopicsSecondLevel.push(parseInt(filterTopicsSecondLevel));
      }
    }
    const filterMediatype = this.$route.query.filterMediatype;
    if (filterMediatype) {
      this.filterMediatype = parseInt(filterMediatype);
    }
    const filterShowFree = this.$route.query.filterShowFree;
    if (filterShowFree) {
      this.filterShowFree = filterShowFree;
    }
    const sortOrderSelected = this.$route.query.sortOrder;
    if (sortOrderSelected) {
      this.sortOrderSelected = sortOrderSelected;
    }

    this.databases = await this.$store.dispatch("fetchDatabases");
    this.topics = await this.$store.dispatch("fetchTopics");
    this.mediatypes = await this.$store.dispatch("fetchMediatypes");
    this.popularDatabases = await this.$store.dispatch("fetchPopularDatabases");

  },
  watch: {
    sortOrderSelected: function () {
      this.updateRouterParam();
      this.getDatabases();
    },
    filterTopicsFirstLevel: function() {
      this.updateRouterParam();
      this.getDatabases();
    },
    filterTopicsSecondLevel: function() {
      this.updateRouterParam();
      this.getDatabases();
    },
    filterMediatype: function () {
      this.updateRouterParam();
      this.getDatabases();
    },
    filterShowFree: function () {
      this.updateRouterParam();
      this.getDatabases();
    }
  },

  async mounted() {},
  methods: {
    getDatabases: async function() {
      this.databases = await this.$store.dispatch("fetchDatabases", this.allTopics);
    },
    updateRouterParam: function() {
      this.$router.replace({ query: {} });
      const query = {};
      if (this.sortOrderSelected) {
        query.sortOrder = this.sortOrderSelected;
      }
      if (this.filterTopicsFirstLevel) {
          query.filterTopicsFirstLevel = this.filterTopicsFirstLevel;
      }
      if (this.filterTopicsSecondLevel.length) {
          query.filterTopicsSecondLevel =  this.filterTopicsSecondLevel;
      } 
      if (this.filterMediatype) {
          query.filterMediatype = this.filterMediatype;
      }
      if (this.filterShowFree) {
        query.filterShowFree = this.filterShowFree;
      }
      this.$router.replace({
        query
      })
    },
    updateSortOrderSelected: function (sortOrder) {
      this.sortOrderSelected = sortOrder;
    },
    updateFilterTopicsSecondLevel: function(topics) {
      this.filterTopicsSecondLevel = [...topics];
    },
    updateFilterTopicsFirstLevel: function(topic) {
      this.filterTopicsFirstLevel = topic;
    },

    updateFilterMediatype: function (mediatype) {
      this.filterMediatype = mediatype;
    },
    updateShowFreeFilter: function () {
      this.filterShowFree = !this.filterShowFree;
    }
  },
  computed: {
    allTopics: function() {
      let topics = [...this.filterTopicsSecondLevel];
      if (this.filterTopicsFirstLevel) {
        topics.push(this.filterTopicsFirstLevel);
      }
      return topics;
    },
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
