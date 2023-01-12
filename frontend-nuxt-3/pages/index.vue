<template>
    <div>
        <button @click="refreshData">reset</button>
        <button @click="updateQueryParams">update query</button>
        <button @click="updateFilters">update filters</button>

        <div class="filters">
            <div class="search">
                <form>
                    <input type="text" v-model="searchStr">
                    <input type="submit" value="submit" @click.prevent="submitSearch">
                </form>
            </div>
            <div v-if="databases.filters.topics" class="topics">
                <ul>
                    <li v-for="topic in databases.filters.topics" :key="topic.id">
                    <input type="checkbox" :id="'topic-'+topic.id" class="type">{{ topic.name }} ({{ topic.count }}) {{ topic.id }} <button @click="setTopic(topic.id)">Select topic</button>
                    </li>
                </ul>
            </div>
            <div  v-if="sub_topics" class="sub_topics">
                <ul>
                    <li v-for="sub_topic in sub_topics" :key="sub_topic.id">
                        {{ sub_topic.name }} ({{ sub_topic.count }}) {{ sub_topic.id }}
                    </li>
                </ul>
            </div>
            <div v-if="databases.filters.mediatypes" class="mediatypes">
                <ul>
                    <li v-for="mediatype in databases.filters.mediatypes" :key="mediatype.id">
                        {{ mediatype.name }}    {{ mediatype.id }}
                    </li>
                </ul>
            </div>
            <div class="free">
                <input v-model="filters.show_free" id="showfree" type="checkbox"><label for="showfree">Show free</label>
            </div>
        </div>

        <div class="meta">
            <div>
            Found <span>{{ databases._meta.found }}</span> of <span>{{ databases._meta.total }}</span>
            </div>
        </div>
        <ul v-if="databases">
            <li v-for="db in databases.data" :key="db.id">
                <nuxt-link :to="`${db.sanitized_title}/${db.id}`">{{ db.title }}</nuxt-link>
            </li>
        </ul>
    </div>
</template>

<script setup>
const route = useRoute();
const router = useRouter();
const filters = reactive({
        lang: 'sv',
        topic: undefined,
        sub_topics: [],
        mediatype: null,
        show_free: false,
        search: '' 
    })
const searchStr = ref('');


const config = useRuntimeConfig();
const { data: databases, pending, error, refresh } = await useFetch(config.public.API_BASE_URL, {params: filters})
console.log(databases.value.filters.topics)
const sub_topics = computed(() => {
    if (filters.topic) {
        databases.value.filters.topics.find((topic) => topic.id === filters.topic).sub_topics;
    }
})




//watch(() => route.query, () => refresh())
watch(() => filters, () => {
        console.log(filters);
    }, { deep: true })


function setTopic(id) {
    filters.topic = id;
}

function submitSearch() {
    console.log(searchStr)
    filters.search = searchStr.value;
    console.log(filters)
}
function updateFilters() {
    filters.lang = "sv";
    filters.sub_topics.push(444)
    console.log(filters)
}
function updateQueryParams() {
    console.log("updateqeuryparams")
    router.replace({query: {foo:"bar"}})
}
function refreshData() {
    refresh();
}
</script>

<style lang="scss" scoped>

</style>