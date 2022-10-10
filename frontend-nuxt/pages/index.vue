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
    <div class="popular">
      <PopularDBList :databases="popularDatabases" />
    </div>
  </div>
</template>

<script>
export default {
  layout: 'default',
  name: 'IndexPage',
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

  computed: {
    alertURL() {
          return this.$store.state.alertURL
      },
  },
  async fetch() {
    this.popularDatabases = await this.$store.dispatch('fetchPopularDatabases', {lang: this.$i18n.locale})
  },
  head() {
    return {
        title: this.$i18n.t('seo.application_title')
    }
  }
}
</script>


<style lang="scss" >
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
