<template>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'PublisherNew'}">New publisher +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="publishers" class="row">
      <div class="col-3">
        <ul class="list-unstyled left-nav">
          <li v-for="publisher in publishers" :key="publisher.id">
            <router-link :to="{ name: 'PublisherShow', params: { id: publisher.id }}">{{publisher.name}}</router-link>
          </li>
        </ul>
      </div>
      <div class="col">
        <router-view :key="$route.fullPath"></router-view>
      </div>
    </div>
    <div v-else>
      No publisher was found
    </div>
  </div>
</template>

<script>
import { usePublishersStore } from "@/stores/publishers"
import {computed, onMounted, ref } from 'vue'
import {useRoute} from 'vue-router'

export default {
  name: 'publishers',
  setup() {
    const publishersStore = usePublishersStore();
    const route = useRoute();
    const publishers = computed(() => {
      return publishersStore.publishers;
    })
    onMounted(async () => {
      const res = await publishersStore.fetchPublishers();
    })
    return {
      publishers, 
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
