<template>
<div class="topic-list">
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'TopicNew'}">New topic +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div v-if="topics.length" class="row">
      <div class="col-3">
        <FormKit 
          outer-class="topic-filter mb-4"
          id="topic_filter"
          type="text"
          :classes="{
            input: 'form-control'
          }"
          name="topic_filter"
          v-model="searchTerm"
          placeholder="Filter topics"
        >
          <template #prefix="context">
            <span class="search-icon">
              <font-awesome-icon icon="search" />
            </span>
          </template>
          <template #suffix="context">
            <a href="javascript:void()" class="resetBtn" v-if="isClearVisible" @click="resetSearch"><font-awesome-icon icon="times" /></a>
          </template>
        </FormKit>
        <ul class="list-unstyled">
          <li v-for="topic in topicsFiltered" :key="topic.id">
            <router-link :to="{ name: 'TopicShow', params: { id: topic.id }}"><span v-html="highlight(topic.name_en)"></span></router-link>
            <ul>
              <li v-for="sub_topic in topic.sub_topics" :key="sub_topic.id">
                <span v-html="highlight(sub_topic.name_en)"></span>
              </li>
            </ul>
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
    const searchTerm = ref('');
    const topicStore = useTopicsStore();
    const route = useRoute();
    const topicsFiltered = computed(() => {
      return topicStore.topics.filter((topic) => {
          const foundInSubTopic = (topic) => {
            const found = topic.sub_topics.filter((sub_topic) => {if (sub_topic.name_en.toLowerCase().includes(searchTerm.value.toLowerCase())) return sub_topic});
            if (found.length) {
              return true;
            }
            return false;
          } 
          if (topic.name_en.toLowerCase().includes(searchTerm.value.toLowerCase()) || foundInSubTopic(topic)) {
            return topic;
          } 
      });
    })
    const resetSearch = () => {
      searchTerm.value = "";
    }
    const highlight = (str) => {
      const reg = new RegExp(searchTerm.value, 'gi'); 
      return str.replace(reg, '<span class="highlight">$&</span>');
    }

    return {
      highlight,
      searchTerm,
      resetSearch, 
      topicsFiltered,
      topics: computed(() => topicStore.topics), 
      isClearVisible: computed(() => {
        if (searchTerm.value.length) return true;
        return false;
      }),
      isNewVisible: computed(() => route.name != 'TopicNew')
    }

  }
}
</script>

<style lang="scss">

.topic-list {
  .highlight {
    background: yellow;
  }
  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }
  h1 {
    margin-bottom: 40px;
  }

  .topic-filter {
    #topic_filter {
      padding-left: 35px;
      padding-right: 35px;
    }
    position: relative;
    .resetBtn {
      position: absolute;
      right: 10px;
      top:7px;
    }
    .search-icon {
      position: absolute;
      left:10px;
      top: 7px;
    }
  }

  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }
}



</style>