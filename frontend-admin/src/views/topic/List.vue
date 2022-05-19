<template>
<div>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'TopicNew'}">New topic +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="topics.length" class="row">
      <div class="col-3">
        <FormKit 
          id="topic_filter"
          type="text" 
          :classes="{
            input: 'form-control test'
          }"
          name="topic_filter"
          v-model="searchTerm"
          placeholder="Filter topics"
        />
        <ul class="list-unstyled">
          <li v-for="topic in topicsFiltered" :key="topic.id">
            <router-link :to="{ name: 'TopicShow', params: { id: topic.id }}">{{topic.name_en}}</router-link>
          </li>
        </ul>
      </div>
      <div class="col">
        <router-view></router-view>
      </div>
    </div>
    <div v-else>
      No topics created
    </div>
  </div>
</div>
</template>

<script>
import { useTopicsStore } from "@/stores/topics"
import { search } from "@formkit/inputs";
import {computed, ref, watch } from 'vue'
import {useRoute} from 'vue-router'

export default {
  name: 'Topics',
  setup() {
    const searchTerm = ref('t');
    const topicStore = useTopicsStore();
    const route = useRoute();
    const topicsFiltered = computed(() => {
      return topicStore.topics.filter((topic) => {
          if (topic.name_en.toLowerCase().includes(searchTerm.value.toLowerCase())) return topic;
      });
    })

    watch(searchTerm, function() {
     // alert("hello")
    })
    return {
      searchTerm,
      topicsFiltered,
      topics: computed(() => topicStore.topics), 
      isNewVisible: computed(() => route.name != 'TopicNew')
    }

  }
}
</script>

<style lang="scss" scoped>
  h1 {
    margin-bottom: 40px;
  }
  ul{
       // border-right: 1px solid #000;
  }
  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }

</style>
