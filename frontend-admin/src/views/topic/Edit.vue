<template>
    <TopicForm v-if="topic" :topic="topic" :errors="errors" title="Edit topic" @saveTopic="saveTopic" />
</template>

<script>
import TopicForm from "../../components/TopicForm.vue"
import {useTopicsStore} from '@/stores/topics'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref, onMounted} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'TopicEdit',
    setup() {
        const topicsStore = useTopicsStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const topic = ref(null); 
        let errors = ref(null);
        onMounted(async () => {
            topic.value = await topicsStore.getTopicById(route.params.id);
        })   
        const saveTopic = async (topic) => {
            errors.value = null;
            const res = await topicsStore.updateTopic(topic);
            if (res.data.error) {
                errors.value = res.data.error;
            }
            if (errors.value && (errors.value.topic && errors.value.topic.length || errors.value.sub_topics && errors.value.sub_topics.length)) {
                message.set('error', "Errors in the form")
            }
            if (!errors.value) {
                message.set("success", "Topic has been saved")
                router.push({name: 'TopicShow', params: {id: topic.id }});
            }
        }
        return {
            topic,
            errors,
            saveTopic
        }
    },
    components: { TopicForm }
}
</script>

<style lang="scss">

</style>