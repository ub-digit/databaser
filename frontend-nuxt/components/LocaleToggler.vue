<template>
    <div>
      <div class="locale-toggler">
        <button class="btn nav-link" id="navbarLanguageToggle" @click="setLanguage($t('components.the_header.language_otherCode'))">
          <font-awesome-icon icon="globe" /> {{$t('components.the_header.language_otherName')}}  
        </button>
      </div>
    </div>
</template>
  
<script>
export default {
    methods: {
        setLanguage(locale) {
            this.$i18n.setLocale(locale);
        }
    }
}
</script>
  
  <style lang="scss" scoped>
    .locale-toggler {
      margin-top:10px;
    }
  </style>
  