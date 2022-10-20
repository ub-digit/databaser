<template>
    <div class="access-information mb-2">
        <font-awesome-icon v-if="database.public_access" icon="lock-open"/><font-awesome-icon v-else icon="lock"/>
        {{getAccessInformationString}}
    </div>
</template>

<script>
export default {
    name: 'AccessInformation',
    props: {
        database: Object
    },
    computed: {
        getAccessInformationString: function () {
            return this.$t("shared.access_information_code." + this.database.access_information_code);
        }
    },
}
</script>

<style lang="scss" scoped>
.access-information {
    color: #555555;
    font-size: 0.875em;
}
</style>