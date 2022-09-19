<template>
  <div class="row justify-content-end">
    <div class="col-auto m-4">
        <router-link v-if="isNewVisible" class="btn btn-light" :to="{name: 'PublisherNew'}">New publisher +</router-link>
    </div>
  </div>
  <div class="row subjects">
    <div class="row">
      <div class="col-3">
        <FormKit 
          outer-class="publisher-filter mb-4"
          id="publisher_filter"
          type="text"
          :classes="{
            input: 'form-control'
          }"
          name="publisher_filter"
          v-model="searchTerm"
          placeholder="Filter publishers"
        >
          <template #prefix="context">
            <span class="search-icon">
              <font-awesome-icon icon="search" />
            </span>
          </template>
          <template #suffix="context">
            <a href="javascript:void()" class="resetBtn" v-if="isClearVisible" @click.prevent="resetSearch"><font-awesome-icon icon="times" /></a>
          </template>
        </FormKit>
        <ul v-if="publishersFiltered && publishersFiltered.length" class="publisher-list left-nav">
          <li v-for="publisher in publishersFiltered" :key="publisher.id">
            <router-link :to="{ name: 'PublisherShow', params: { id: publisher.id }}">
              <span v-html="highlight(publisher.name)"></span>
            </router-link>
          </li>
        </ul>
        <div v-else>
          No publisher was found
        </div>
      </div>
      <div class="col">
        <router-view :key="$route.fullPath"></router-view>
      </div>
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
    const searchTerm = ref("");
    const publishers = computed(() => {
      return publishersStore.publishers;
    })
    onMounted(async () => {
      const el = document.getElementById('publisher_filter').focus();
      const res = await publishersStore.fetchPublishers();
    })

    const publishersFiltered = computed(() => {
      return publishers.value.filter((publisher) => {
          if (publisher.name.toLowerCase().includes(searchTerm.value.toLowerCase())) {
            return true;
          }
          return false;
      });
    })
    const isClearVisible = computed(() => {
        return searchTerm.value.length ?  true : false;
    })
    const resetSearch = () => {
      searchTerm.value = "";
    }
    const highlight = (str) => {
      const reg = new RegExp(searchTerm.value, 'gi'); 
      return str.replace(reg, '<span class="highlight">$&</span>');
    }
    return {
      isClearVisible,
      resetSearch,
      searchTerm,
      highlight,
      publishers, 
      publishersFiltered,
      isNewVisible: computed(() => route.name != 'PublisherNew')
    } 
  }
}
</script>

<style lang="scss" >
  h1 {
    margin-bottom: 40px;
  }
  .publisher-list {
    .highlight {
      background: yellow;
    }
  }
  a {
    text-decoration: none;
    &.router-link-active {
      text-decoration: underline;
    }
  }
  .publisher-filter {
    #publisher_filter {
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

</style>
