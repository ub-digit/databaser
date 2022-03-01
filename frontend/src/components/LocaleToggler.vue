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
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
export default {
  setup() {
    const i18n = useI18n({ useScope: 'global' })
    const router = useRouter()
    function setLanguage(locale) {
      i18n.locale.value = locale
    }
    return {
      setLanguage
    }
  }
}
</script>

<style lang="scss" scoped>
  .locale-toggler {
    margin-top:10px;
  }
</style>
