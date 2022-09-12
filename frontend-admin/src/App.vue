<script setup>
import { RouterLink, RouterView } from "vue-router";
import Nav from './components/Nav.vue';
</script>

<template>
  <header>
    <Nav/>
  </header>
  <div class="container-fluid">
  <RouterView />
  </div>
</template>

<style lang="scss">
ul {
  &.left-nav {
    li {  
      margin-bottom: 8px;
      a {
        &:hover {
          background-color: #ccc;
        }
      }
    }
  }
}
</style>
