<template>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'DatabaseNew'}">New database +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="databases.length" class="row">
      <div class="col-3">
        <ul class="list-unstyled left-nav">
          <li v-for="database in databases" :key="database.id">
            <router-link :to="{ name: 'DatabaseShow', params: { id: database.id }}">{{database.title_en}}</router-link>
          </li>
        </ul>
      </div>
      <div class="col">
        <router-view :key="$route.fullPath"></router-view>
      </div>
    </div>
    <div v-else>
      No databases created
    </div>
    
    
  </div>
</template>

<script>
import { useDatabasesStore } from "@/stores/databases"
import {computed, onMounted } from 'vue'
import {useRoute} from 'vue-router'

export default {
  name: 'databases',
  setup() {
    const store = useDatabasesStore();
    const route = useRoute();
    onMounted(async () => {
      const res = await store.fetchDatabases();
    })
    return {
      databases: computed(() => store.databases.slice(0,20)), 
      isNewVisible: computed(() => route.name != 'PublisherNew')
    } 
  }
}
</script>

<style lang="scss" scoped>
  h1 {
    margin-bottom: 40px;
  }
  
  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }

</style>
