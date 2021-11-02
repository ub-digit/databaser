<template>
  <div class="facet-filter">
    <div class="facet-header d-flex justify-content-between" :class="{active: showFree}" @click="toggleFree">
      <span class="facet-header-text">Show freely accessible </span>
      <span class="facet-header-action-indicator">
        <span v-if="showFree"><font-awesome-icon :icon="['far', 'check-square']"/></span>
        <span v-else><font-awesome-icon :icon="['far', 'square']"/></span>
      </span>
    </div>
  </div>
</template>

<script>
export default {
  name: "FreelyAccessibleFilter",
  props: {
    showFree: Boolean
  },
  data() {
    return {
    };
  },

  watch: {
    
  },
  computed: {
    
  },
  mounted() {
    
  },
  methods: {
    toggleFree: function () {
      this.$emit("updateShowFreeFilter");
    }
  },
}
</script>

<style lang="scss" scoped>

a {
  svg {
    margin-right: 10px;
    color: #000;
    font-size: .8rem;
  }
}
</style>