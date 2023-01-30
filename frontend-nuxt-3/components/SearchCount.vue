<template>
<div>

    <div class="row mb-4">
        <div class="col"><strong>{{ t('components.searchcount.meta', { found: meta.found, total: meta.total }) }}</strong>
        <p></p>
        </div>
    </div>
</div>
</template>

<script setup>
const {t} = useI18n();
const props = defineProps(['meta'])
</script>

<style lang="scss" scoped>

</style>