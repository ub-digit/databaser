<template>
    <div class="facet-filter">
      <div class="d-grid gap-2">
        <button role="button" class="facet-header d-flex justify-content-between" :class="{active: show_free}" @click="toggleFree">
          <span class="facet-header-text">{{$t('components.freely_accessible_filter.label')}} </span>
          <span class="facet-header-action-indicator">
            <span v-if="show_free"><font-awesome-icon :icon="['far', 'square-check']"/></span>
            <span v-else><font-awesome-icon :icon="['far', 'square']"/></span>
          </span>
        </button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "FreelyAccessibleFilter",
    props: {
      show_free: Boolean
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
    updated() {
   
    },
    methods: {
      toggleFree: function () {
        const show = this.show_free ? false : true; 
        this.$emit("updateShowFreeFilter", show);
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