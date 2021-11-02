<template>
  <div>
    <nav id="nav">
      <router-link to="/">{{
        $t("components.the_nav.nav1.title")
      }}</router-link>
      |
      <router-link to="/about">{{
        $t("components.the_nav.nav2.title")
      }}</router-link>
    </nav>
  </div>
</template>

<script>
export default {
  name: "TheNav",
};
</script>

<style lang="scss" scoped></style>
