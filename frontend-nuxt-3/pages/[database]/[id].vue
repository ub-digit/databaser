<template>
    <div>
        <button @click="refreshData">reload</button>
        Database details
        <h1>{{ database.title }}</h1>
        {{ $route.params }}
    </div>
</template>

<script setup>
    const config = useRuntimeConfig();
    const route = useRoute();
    const payload = {id: route.params.id, lang: 'en'}
    const { data: database, pending, error, refresh } = await useFetch(`${config.public.API_BASE_URL}${route.params.id}`, {params: {payload: JSON.stringify(payload)}})
    console.log(database)

    function refreshData() {
        refresh();
    }
</script>

<style lang="scss" scoped>

</style>