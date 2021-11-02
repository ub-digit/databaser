<template>
  <div>
    <div class="locale-toggler">
      <select class="form-select" v-model="$i18n.locale">
        <option
          v-for="locale in $i18n.availableLocales"
          :key="`locale-${locale}`"
          :value="locale"
          >{{ locale }}</option
        >
      </select>
    </div>
  </div>
</template>

<script>
export default {
  name: "LocaleToggler",
};
</script>

<style lang="scss" scoped>
  .locale-toggler {
    margin-top:10px;
  }
</style>
