export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig();
  const query = getQuery(event);

  try {
    const res = await $fetch(config.API_BASE_URL + "databases/", {
      params: query,
    });
    return res;
  } catch (error) {
    console.error(error);
  }
});
