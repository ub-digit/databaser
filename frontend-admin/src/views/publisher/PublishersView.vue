<template>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'PublisherNew'}">New publisher +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="publishers.length" class="row">
      <div class="col-2">
        <ul class="list-unstyled">
          <li v-for="publisher in publishers" :key="publisher.id">
            <router-link :to="{ name: 'PublisherShow', params: { id: publisher.id }}">{{publisher.title}}</router-link>
          </li>
        </ul>
      </div>
      <div class="col">
        <router-view></router-view>
      </div>
    </div>
    <div v-else>
      No publishers created
    </div>
    
    
  </div>
</template>

<script>
import { usePublishersStore } from "@/stores/publishers"
import {computed } from 'vue'
import {useRoute} from 'vue-router'

export default {
  name: 'publishers',
  setup() {
    const publishersStore = usePublishersStore();
    const route = useRoute();
    return {
      publishers: computed(() => publishersStore.publishers), 
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
