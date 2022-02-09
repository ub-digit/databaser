<template>
  <div>
    <TheHeader/>
    <div class="container">
      <router-view />
    </div>
  </div>
</template>

<script>
import TheHeader from "../components/TheHeader.vue";
import TheNav from "../components/TheNav.vue";
export default {
  name: "Index",
  props: {
    lang: {
      type: String,
      default: 'en',
    }
  },
  components: {
    TheHeader,
    TheNav,
  },
  mounted() {
    document.title = this.$t('application_title');
    this.$i18n.locale = this.lang;
  },

  watch: {
    '$i18n.locale'(newVal, oldVal) {
      const old_query = this.$route.query;
      const query = {...old_query, ...{lang: newVal }};
      this.$router.replace({query})
    },
    '$route.query'(newVal, oldVal) {
      const old_query = this.$route.query;
      const query = {...old_query, ...{lang: this.$i18n.locale }};
      this.$router.replace({query})
    }
  }
};
</script>

<style lang="scss"></style>
