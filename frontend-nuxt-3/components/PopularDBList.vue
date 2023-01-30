<template>
    <div v-if="databases && databases.length">
    <div class="popular-container row justify-content-center">
        <div class="col-md-auto">
        <strong>{{ t("components.popular_db_list.title") }}:</strong>
        </div>
        <div class="col-md-auto">
        <ul class="list-unstyled">
            <li class="d-md-inline-block" v-for="db in databases" :key="db.id">
                <a :href="db.urls[0].url">{{db.title}}</a>
            </li>
        </ul>
        </div>
    </div>
    </div>
</template>

<script setup>
const props = defineProps(['lang'])
const config = useRuntimeConfig();
const route = useRoute();
const {t, getLocale} = useI18n();
// const { data: databases, pending, error, refresh } = await useFetch(config.public.API_BASE_URL + 'databases/popular/?' + "lang=" + getLocale())
const { data: databases, pending, error, refresh } = await useFetch('/api/popular/?' + "lang=" + getLocale())

</script>

<style lang="scss" scoped>
  .popular-container {
    text-align: center;
  }
  @media (min-width: 768px) { 
    ul {
      li {
        margin-right: 20px;
      }
    }
}
</style>