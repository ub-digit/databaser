<template>
    <TopicForm :topic="topic" :errors="errors" title="Edit topic" @saveTopic="saveTopic" />
</template>

<script>
import TopicForm from "../../components/TopicForm.vue"
import {useTopicsStore} from '@/stores/topics'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'TopicEdit',
    setup() {
        const store = useTopicsStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const topic = store.getTopicById(route.params.id);
        let errors = ref(null);

        const saveTopic = async (topic) => {
            errors.value = await store.updateTopic(topic);
            if (errors.value && (errors.value.topic.length || errors.value.sub_topics.length)) {
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

<style>

</style>