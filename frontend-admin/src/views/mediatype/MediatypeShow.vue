<template>
<div  v-if="mediatype && mediatype.id" class="topicshow-wrapper">
    <div class="row">
        <div class="col">
          <h1>{{mediatype.name_en}} / {{mediatype.name_sv}}</h1>
        </div>
    </div>
    <router-link class="btn btn-primary me-1" :to="{name: 'MediatypeEdit', params:{ id: mediatype.id }}">Edit</router-link>
    <a href="#" @click.prevent="removeMediatype(mediatype)" class="btn btn-danger" >Remove</a>
</div>

</template>

<script>
import { useRoute, useRouter } from 'vue-router'
import { useMediatypesStore } from "@/stores/mediatypes"
import { computed, onMounted, ref } from 'vue'
import { useMessage } from '../../plugins/message'

export default {
  name: 'TopicShow',
  setup() {
    const message = useMessage();
    const route = useRoute();
    const router = useRouter();
    const mediatypesStore = useMediatypesStore();
    const mediatype = ref({});
    onMounted(async () => {
      const res = await mediatypesStore.getMediatypeById(route.params.id);
      mediatype.value = res;
      window.scrollTo(0,0);
    })
    const removeMediatype = async (mediatype) => {
      if (confirm("Are you sure?")) {
        const res = await mediatypesStore.removeMediatype(mediatype);
        if (res.data && res.data.status === "deleted") {
          message.set("success", "Mediatype has been deleted")
        }
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
