<template>
    <span v-if="publisher">
        <PublisherForm :publisher="publisher" :errors="errors" title="Edit publisher" @savePublisher="savePublisher" />
    </span>
</template>

<script>
import PublisherForm from "../../components/PublisherForm.vue"
import {usePublishersStore} from '@/stores/publishers'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref, onMounted} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'TopicEdit',
    setup() {
        const store = usePublishersStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const publisher = ref(null)
        let errors = ref(null);

        onMounted(async () => {
            publisher.value = await store.getPublisherById(route.params.id);
        }) 
        const savePublisher = async (publisher) => {
            errors.value = null; 
            const res = await store.updatePublisher(publisher);
            if (res.data.error) {
                errors.value = res.data.error;
            }
            if (errors.value && (errors.value.publisher.length)) {
                message.set('error', "Errors in the form")
            }
            if (!errors.value) {
                message.set("success", "Publisher has been saved")
                router.push({name: 'PublisherShow', params: {id: res.data.publisher.id }});
            }
        }

        return {
            publisher,
            errors,
            savePublisher
        }
    },
    components: { PublisherForm }

}
</script>

<style>

</style>