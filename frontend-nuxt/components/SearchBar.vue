<template>
    <div id="searchBar" class="row justify-content-center">
      <div class="col-lg-6">
        <form class="input-group">
          <a v-if="clearIsVisible" href="javascript:" aria-label="Clear search" id="btn-clear-input" @click.prevent="clearSearch"><font-awesome-icon icon="circle-xmark"/></a>
          <input class="form-control form-control-lg" :placeholder="$t('components.search_bar.placeholder')"  v-model="searchStr">
          <input class="btn btn-primary" type="submit" @click.prevent="updateSearch" :value="$t('components.search_bar.submit')">
        </form>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "SearchBar",
    props: ['search'],
    methods: {
      updateSearch: function() {
        if (!this.searchStr || this.searchStr.length === 0) {
          this.searchStr = undefined;
        }
    
        this.$emit("updateSearch", this.searchStr);
      },
      clearSearch: function() {
        this.searchStr = undefined;
        this.updateSearch(null);
      }
    },
    mounted() {
    },
    computed: {
      clearIsVisible: function() {
        if (this.searchStr && this.searchStr.length > 0) {
          return true;
        }
        return false;
      }
    },
    data() {
        return {
            searchStr: this.search,
        }
    },
  };
  </script>
  
  <style lang="scss" scoped>
  #searchBar {
    margin-bottom: 40px;
    #btn-clear-input {
      position: absolute;
      top: 12px;
      right:90px;
      z-index: 100;
      color: black;
    }
  }
  </style>
  