<script setup>
import { RouterLink, RouterView } from "vue-router";
import Nav from './components/Nav.vue';
</script>

<template>
  <header>
    <Nav/>
  </header>
  <div class="container">
  <RouterView :key="$route.fullPath" />
  </div>
</template>

<style lang="scss">

</style>
