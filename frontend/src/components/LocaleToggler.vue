<template>
  <div>
    <div class="locale-toggler">
      <button class="btn nav-link" id="navbarLanguageToggle" @click="switchLocalePath($t('components.the_header.language_otherCode'))">
        <font-awesome-icon icon="globe" /> {{$t('components.the_header.language_otherName')}}  
      </button>
    </div>
  </div>
</template>

<script>
export default {
}
</script>

<style lang="scss" scoped>
  .locale-toggler {
    margin-top:10px;
  }
</style>
