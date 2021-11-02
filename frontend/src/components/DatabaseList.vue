<template>
  <div>
    <div class="row">
      <div class="col"><strong>Found {{databases._meta.found}} of {{databases._meta.total}} databases:</strong></div>
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
    sortOrderSelected: String,
  },
  watch: {
    selected : function () {
      this.$emit('updateSortOrderSelected', this.selected);
    }
  },
  data() {
    return {
      selected: this.sortOrderSelected,
    }
  },
};
</script>

<style lang="scss" scoped></style>
