<template>
    <div class="mb-4">
      <div class="row mb-4">
        <div class="col"><strong>{{ $t('components.database_list.meta', { found: databases._meta.found, total: databases._meta.total }) }}</strong>
        <p></p>
        </div>
        <div v-if="false" class="col-auto">
          <select class="form-select" v-model="selected">
            <option v-for="sortOrder in sortOrders" :value="sortOrder.id" :key="sortOrder.id">{{sortOrder.text}}</option>
          </select>
  
        </div>
      </div>
      <ul class="list-unstyled" id="database-list">
        <li v-for="(database) in databaseListToRender" :key="database.id">
          <DatabaseListRow :database="database" />
        </li>
      </ul>
      <div v-if="showLoadMoreBtn" class="d-grid">
        <button class="btn btn-primary" :class="{disabled: loading}" v-if="paginated" @click="toggleShowAll">{{ $t('components.database_list.show_all')}}</button>
      </div>
    </div>
  </template>
  <script>
  import DatabaseListRow from "./DatabaseListRow.vue";
  export default {
    name: "DatabaseList",
    components: {
      DatabaseListRow,
    },
    props: {
      databases: Object,
      sortOrders: Array,
      sort_order: String,
    },
    watch: {
      sortOrder: function() {
        this.selected = this.sortOrder;
      },
      selected : function () {
        this.$emit('updateSortOrderSelected', this.selected);
      }
    },
      mounted() {
    },
  
    methods: {
      toggleShowAll() {
  
        this.loading = true;
        
        setTimeout(() => {
          this.paginated = false;
        },0)
       
      }
    },
    computed: {
      showLoadMoreBtn: function() {
        if (this.databases.data.length > this.NumberToDisplay) {
          return true;
        }
        return false;
      },
      databaseListToRender: function() {
        if (this.paginated) {
          return this.databases.data.slice(0,this.NumberToDisplay-1);
        }
        return this.databases.data;
      }
    },
    data() {
      return {
        selected: this.sort_order,
        paginated: true,
        loading: false,
        NumberToDisplay: 20
      }
    },
  };
  </script>
  
  <style lang="scss" scoped></style>
  