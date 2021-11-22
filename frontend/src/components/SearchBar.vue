<template>
  <div id="searchBar" class="row justify-content-center">
    <div class="col-md-6">
      <form class="input-group">
        <a v-if="clearIsVisible" href="javascript:" id="btn-clear-input" @click.prevent="clearSearch"><font-awesome-icon icon="times"/></a>
        <input class="form-control" :placeholder="$t('components.search_bar.placeholder')"  v-model="searchStr">
        <input class="btn btn-outline-primary" type="submit" @click.prevent="updateSearch" :value="$t('components.search_bar.submit')">
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
      this.updateSearch();
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
  margin-bottom: 20px;
  #btn-clear-input {
    position: absolute;
    top: 7px;
    right:90px;
    z-index: 100;
    color: black;
  }
}
</style>
