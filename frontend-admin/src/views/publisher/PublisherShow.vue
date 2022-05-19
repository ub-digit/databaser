<template>
<div  v-if="publisher" class="topicshow-wrapper">
    <div class="row">
        <div class="col">
          <h1>{{publisher.title}}</h1>
        </div>
    </div>
    <router-link class="btn btn-primary me-1" :to="{name: 'PublisherEdit', params:{ id: publisher.id }}">Edit</router-link>
    <a href="#" @click.prevent="removePublisher(publisher)" class="btn btn-danger" >Remove</a>
</div>

</template>

<script>
import { useRoute, useRouter } from 'vue-router'
import { usePublishersStore } from "@/stores/publishers"
import { computed } from 'vue'

export default {
  name: 'TopicShow',

  setup() {
    const route = useRoute();
    const router = useRouter();
    const publishersStore = usePublishersStore();
    const publisher = computed(() => publishersStore.getPublisherById(route.params.id));

    const removePublisher = (publisher) => {
      if (confirm("Are you sure?")) {
        publishersStore.removePublisher(publisher);
        router.push({name:'publisherindex'});
      }
    }

    

    return {
      publisher, 
      removePublisher
    }

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">

</style>
