<template>
    <TopicForm :topic="topic" title="New topic" :errors="errors" @saveTopic="saveTopic" />
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import TopicForm from "../../components/TopicForm.vue"
import { useTopicsStore } from "../../stores/topics";
import { useMessage } from '../../plugins/message';
import { use } from 'chai';

export default {
    setup() {
        const store = useTopicsStore();
        const router = useRouter();
        const route = useRouter();
        const message = useMessage();
        let errors = ref(null);
        let topic = {
            id: null,
            name_sv: "",
            name_en: "",
            sub_topics: []
        };
        const saveTopic = async (item) => {
            const res = await store.updateTopic(item);
            errors.value = null;
            if (res.data.error) {
                errors.value = res.data.error;
            }
            if (errors.value && (errors.value.topic.length || errors.value.sub_topics && errors.value.sub_topics.length )) {
                message.set('error', "Errors in the form ")
            }
            if (!errors.value) {
                message.set("success", "New topic has been saved")
                router.push({name: 'TopicShow', params: {id: res.data.id }});
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