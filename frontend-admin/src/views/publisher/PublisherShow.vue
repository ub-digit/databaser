<template>
<div  v-if="publisher && publisher.id" class="publisher-wrapper">
    <div class="row">
      <div class="col">
        <div v-show="!publisher.can_be_deleted" class="alert alert-warning" role="alert">
          This publisher is connected to at least one database. First remove all connected databases before you can delete this mediatype.
        </div>
      </div>
    </div>
    <div class="row">
        <div class="col">
          <h1>{{publisher.name}}</h1>
        </div>
    </div>
    <router-link class="btn btn-primary me-1" :to="{name: 'PublisherEdit', params:{ id: publisher.id }}">Edit</router-link>
    <button :disabled="!publisher.can_be_deleted" @click.prevent="removePublisher(publisher)" class="btn btn-danger" >Remove</button>
</div>

</template>

<script>
import { useRoute, useRouter } from 'vue-router'
import { usePublishersStore } from "@/stores/publishers"
import { computed, onMounted, ref } from 'vue'
import { useMessage } from '../../plugins/message';

export default {
  name: 'DatabaseShow',

  setup() {
    const route = useRoute();
    const router = useRouter();
    const publishersStore = usePublishersStore();
    const publisher = ref({});
    const message = useMessage();
    const errors = ref(null)

    onMounted(async () => {
      const res = await publishersStore.getPublisherById(route.params.id);
      publisher.value = res;
      window.scrollTo(0,0);
    })

    const removePublisher = async (publisher) => {  
      if (confirm("Are you sure?")) {
        errors.value = null; 
        const res = await publishersStore.removePublisher(publisher);
        if (res.data.status === "deleted") {
          message.set("success", `Publisher has been removed`)
          router.push({name:'publisherindex'});
        }
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
