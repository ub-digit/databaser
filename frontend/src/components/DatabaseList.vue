<template>
  <div>
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
      <li v-for="database in databases.data" :key="database.id">
        <DatabaseListRow :database="database" />
      </li>
    </ul>
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
  data() {
    return {
      selected: this.sort_order,
    }
  },
};
</script>

<style lang="scss" scoped></style>
