<template>
    <div>
        <TheHeader/>
        <Nuxt />
    </div>
</template>

<script>
import TheHeader from '~/components/TheHeader.vue';
export default {
    head() {
        return {
            title: this.$i18n.t('seo.application_title')
        }
    },
    components: { TheHeader }
}

</script>