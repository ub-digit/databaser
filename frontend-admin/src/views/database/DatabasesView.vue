<template>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'DatabaseNew'}">New database +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="databases.length" class="row">
      <div class="col-2">
        <ul class="list-unstyled">
          <li v-for="database in databases" :key="database.id">
            <router-link :to="{ name: 'DatabaseShow', params: { id: database.id }}">{{database.title_en}}</router-link>
          </li>
        </ul>
      </div>
      <div class="col">
        <router-view></router-view>
      </div>
    </div>
    <div v-else>
      No databases created
    </div>
    
    
  </div>
</template>

<script>
import { useDatabasesStore } from "@/stores/databases"
import {computed } from 'vue'
import {useRoute} from 'vue-router'

export default {
  name: 'databases',
  setup() {
    const store = useDatabasesStore();
    const route = useRoute();
    return {
      databases: computed(() => store.databases), 
      isNewVisible: computed(() => route.name != 'PublisherNew')
    } 
  }
}
</script>

<style lang="scss" scoped>
  h1 {
    margin-bottom: 40px;
  }
  ul{
        border-right: 1px solid #000;
  }
  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }

</style>
