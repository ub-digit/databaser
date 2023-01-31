export default defineEventHandler(async (event) => {
    const config = useRuntimeConfig();
    const query = getQuery(event);
    const res = await $fetch(config.public.API_BASE_URL + 'alert/', {
        params: query
    })
    return res;
})