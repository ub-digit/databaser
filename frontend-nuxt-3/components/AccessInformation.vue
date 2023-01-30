<template>
    <div>
        <div class="access-information mb-2">
            <font-awesome-icon v-if="db.public_access" icon="lock-open"/><font-awesome-icon v-else icon="lock"/>
            {{getAccessInformationString}}
        </div>
    </div>
</template>

<script setup>
const props = defineProps(['db'])
const {t} = useI18n();

const getAccessInformationString = computed(() => {
    return t("shared.access_information_code." + props.db.access_information_code);
})
</script>

<style lang="scss" scoped>
.access-information {
    color: #555555;
    font-size: 0.8rem;
}
</style>