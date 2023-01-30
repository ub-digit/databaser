export default defineEventHandler(async (event) => {
    const config = useRuntimeConfig();
    const query = getQuery(event);
    const id = event.context.params.id;
    const res = await $fetch(config.public.API_BASE_URL + `databases/${id}`, {
        params: query
    })
    return res;
})