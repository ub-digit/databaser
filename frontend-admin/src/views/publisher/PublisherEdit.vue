<template>
    <PublisherForm :publisher="publisher" :errors="errors" title="Edit publisher" @savePublisher="savePublisher" />
</template>

<script>
import PublisherForm from "../../components/PublisherForm.vue"
import {usePublishersStore} from '@/stores/publishers'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'TopicEdit',
    setup() {
        const store = usePublishersStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const publisher = store.getPublisherById(route.params.id);
        let errors = ref(null);

        const savePublisher = async (publisher) => {
            errors.value = await store.updatePublisher(publisher);
            if (errors.value && (errors.value.publisher.length)) {
                message.set('error', "Errors in the form")
            }
            if (!errors.value) {
                message.set("success", "Publisher has been saved")
                router.push({name: 'PublisherShow', params: {id: publisher.id }});
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