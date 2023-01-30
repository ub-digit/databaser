<template>
  <div>
    <Head>
      <title>{{t('seo.application_title')}}</title>
    </Head>
    <AppHeader />
    <NuxtPage />
  </div>
</template>

<script setup>
  const { t } = useI18n()
</script>