<template>
  <div>
    <router-link
      class="database-link"
      :to="{ name: 'Database', params: { id: database.id } }"
      >{{ database.title }}</router-link
    >
    <div class="database-body">
      <p>{{ database.description.substr(0, 199) }}...</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "DatabaseListRow",
  props: {
    database: Object,
  },
};
</script>

<style lang="scss" scoped></style>
