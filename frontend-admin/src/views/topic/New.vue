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
            errors.value = await store.newTopic(item);
            if (errors.value && (errors.value.topic.length || errors.value.sub_topics.length)) {
                message.set('error', "Errors in the form ")
            }
            if (!errors.value) {
                message.set("success", "New topic has been saved")
                router.push({name: 'TopicShow', params: {id: item.id }});
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