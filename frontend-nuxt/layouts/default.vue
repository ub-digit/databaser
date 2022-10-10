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
        return this.$nuxtI18nHead({ addSeoAttributes: true });
    },
    components: { TheHeader }
}

</script>