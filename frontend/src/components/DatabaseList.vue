<template>
  <div class="mb-4">
    <div class="row mb-4">
      <div class="col"><strong>{{ $t('components.database_list.meta', { found: databases._meta.found, total: databases._meta.total }) }}</strong>
      <p></p>
      </div>
      <div class="col-auto">
        <select class="form-select" v-model="selected">
          <option v-for="sortOrder in sortOrders" :value="sortOrder.id" :key="sortOrder.id">{{sortOrder.text}}</option>
        </select>

      </div>
    </div>
    <ul class="list-unstyled" id="database-list">
      <li v-for="(database) in database_list_to_render" :key="database.id">
        <DatabaseListRow :database="database" />
      </li>
    </ul>
    <div class="d-grid">
      <button class="btn btn-primary" v-if="paginated" @click="toggleShowAll">{{ $t('components.database_list.show_all')}}</button>
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
      this.paginated = false;
    }
  },
  computed: {
    database_list_to_render: function() {
      if (this.paginated) {
        return this.databases.data.slice(0,20);
      }
      return this.databases.data;
    }
  },
  data() {
    return {
      selected: this.sort_order,
      paginated: true
    }
  },
};
</script>

<style lang="scss" scoped></style>
