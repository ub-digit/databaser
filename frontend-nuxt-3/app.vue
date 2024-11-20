<template>
  <Title>{{ t("seo.application_title") }}</Title>
  <div>
    <AppHeader />
    <NuxtPage />
    <AppFooter />
  </div>
</template>

<script setup>
const { t, getLocale } = useI18n();
useHead({
  htmlAttrs: {
    lang: getLocale(),
    title: t("seo.application_title"),
  },
});
</script>
