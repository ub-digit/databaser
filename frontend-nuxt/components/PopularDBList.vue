<template>
    <div v-show="hasPopular">
      <div class="popular-container row justify-content-center">
        <div class="col-md-auto">
          <strong>{{ $t("components.popular_db_list.title") }}:</strong>
        </div>
        <div class="col-md-auto">
          <ul class="list-unstyled">
            <li class="d-md-inline-block" v-for="db in databases" :key="db.id">
                <a :href="db.urls[0].url">{{db.title}}</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
</template>
  
  <script>
  export default {
    name: "PopularDBList",
    props: {
      databases: Array,
    },
    computed: {
      hasPopular() {
        return this.databases.length > 0;
      },
    },
  };
  </script>
  
  <style lang="scss" scoped>
  .popular-container {
    text-align: center;
  }
  @media (min-width: 768px) { 
    ul {
      li {
        margin-right: 20px;
      }
    }
  }
  </style>
  