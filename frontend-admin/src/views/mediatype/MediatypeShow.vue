<template>
<div  v-if="mediatype" class="topicshow-wrapper">
    <div class="row">
        <div class="col">
          <h1>{{mediatype.title_en}} / {{mediatype.title_sv}}</h1>
        </div>
    </div>
    <router-link class="btn btn-primary me-1" :to="{name: 'MediatypeEdit', params:{ id: mediatype.id }}">Edit</router-link>
    <a href="#" @click.prevent="removeMediatype(mediatype)" class="btn btn-danger" >Remove</a>
</div>

</template>

<script>
import { useRoute, useRouter } from 'vue-router'
import { useMediatypesStore } from "@/stores/mediatypes"
import { computed } from 'vue'

export default {
  name: 'TopicShow',

  setup() {
    const route = useRoute();
    const router = useRouter();
    const mediatypesStore = useMediatypesStore();
    const mediatype = computed(() => mediatypesStore.getMediatypeById(route.params.id));

    const removeMediatype = (mediatype) => {
      if (confirm("Are you sure?")) {
        mediatypesStore.removeMediatype(mediatype);
        router.push({name:'mediatypeindex'});
      }
    }

    

    return {
      mediatype, 
      removeMediatype
    }

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">

</style>
