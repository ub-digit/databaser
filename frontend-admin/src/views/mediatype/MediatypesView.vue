<template>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'MediatypeNew'}">New mediatype +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="mediatypes.length" class="row">
      <div class="col-2">
        <ul class="list-unstyled">
          <li v-for="mediatype in mediatypes" :key="mediatype.id">
            <router-link :to="{ name: 'MediatypeShow', params: { id: mediatype.id }}">{{mediatype.title_en}}</router-link>
          </li>
        </ul>
      </div>
      <div class="col">
        <router-view></router-view>
      </div>
    </div>
    <div v-else>
      No mediatypes created
    </div>
    
    
  </div>
</template>

<script>
import { useMediatypesStore } from "@/stores/mediatypes"
import {computed } from 'vue'
import {useRoute} from 'vue-router'

export default {
  name: 'Mediatypes',
  setup() {
    const mediatypesStore = useMediatypesStore();
    const route = useRoute();
    return {
      mediatypes: computed(() => mediatypesStore.mediatypes), 
      isNewVisible: computed(() => route.name != 'MediatypeNew')
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
