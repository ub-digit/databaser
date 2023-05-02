<template>
<div>
  <!-- use the modal component, pass in the prop -->
  <modal :show="showModal" :isIndexing="isIndexing" @success="handleSuccess" @close="showModal = false">
    <template #header>
      <h4>Indexing databases</h4>
    </template>
    <template #body>
      <p><span v-if="isIndexing">Indexing please wait...</span><span v-else>Done!</span></p>
    </template>
  </modal>

  <div class="navigation_wrapper">
    <div class="navbar navbar-dark bg-primary navbar-expand-sm">
      <div class="container-fluid">
        <a class="navbar-brand" href="/">
          <span class="logo"><img :src="'/img/gub-textlogo-en.svg'" alt="logo"></span> | Database admin
        </a>
        <div class="navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item">
              <router-link :to="{name: 'home'}" class="nav-link">Home</router-link>
            </li>
            <li class="nav-item" >
              <router-link :to="{name: 'alert'}" class="nav-link">Alert Message</router-link>
            </li>
            <li class="nav-item" >
              <router-link :to="{name: 'index'}" class="nav-link">Topics</router-link>
            </li>
            <li class="nav-item" >
              <router-link :to="{name: 'mediatypeindex'}" class="nav-link">Mediatypes</router-link>
            </li>
            <li class="nav-item" >
              <router-link :to="{name: 'publisherindex'}" class="nav-link">Publishers</router-link>
            </li>
            <li class="nav-item" >
              <router-link :to="{name: 'databaseindex'}" class="nav-link">Databases</router-link>
            </li>
        </ul>
          <ul class="navbar-nav ms-auto">
            <li class="nav-item dropdown" v-if="$auth.$vm.state.authenticated">
              <a class="nav-link  dropdown-toggle" href="javascript:void(0)" id="navbarLoginMenuLink" aria-label="Username" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                <span>Logged in user: {{$auth.$vm.state.data.name}}</span>
              </a>
              <ul class="dropdown-menu" aria-labelledby="navbarLoginMenuLink">
                <li class="text-md-center text-sm-start">
                  <a class="dropdown-item" @click="$auth.logout()" href="javascript:void(0)">Logout</a>
                </li>
                <li class="text-md-center text-sm-start">
                  <a class="dropdown-item" @click.prevent="updateIndex()" href="javascript:void(0)">Update index</a>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import {useDatabasesStore} from '@/stores/databases'
import {useMessage} from '@/plugins/message'
import modal from './MyModal.vue'
import { ref } from 'vue';
export default {
  components: {
    modal
  },
  setup() {

    const open = ref(false)
    const showModal = ref(false);
    const store = useDatabasesStore();
    const message = useMessage();
    const isIndexing = ref(false);

    async function updateIndex() {
      isIndexing.value = true;
      showModal.value = true;
      const res = await store.reIndexDatabase();
      if (res.status === "ok") {
        isIndexing.value = false;
        message.set("success", "databases successfully indexed")
      }
    }

    function handleSuccess() {
      showModal.value = false;
    }
    return {updateIndex, showModal, isIndexing, handleSuccess}
  }

}
</script>

<style lang="scss" >
.navigation_wrapper {
  .navbar {
    margin-bottom: 20px;
    .nav-item {
      a {
        text-decoration: none;
        &:hover, &:focus {
            background-color: transparent;
          
        }
        &.router-link-active {
          background: transparent;
          border-bottom: 2px solid white;
        }
      }
    }
  }

}
</style>