<template>
  <div>
    <TheHeader />
    <div class="container">
      <router-view />
    </div>
  </div>
</template>

<script>
import TheHeader from "./components/TheHeader.vue";
import TheNav from "./components/TheNav.vue";
export default {
  components: {
    TheHeader,
    TheNav,
  },
};
</script>

<style lang="scss"></style>
