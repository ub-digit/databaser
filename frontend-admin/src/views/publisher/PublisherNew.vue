<template>
    <PublisherForm :publisher="publisher" title="New publisher" :errors="errors" @savePublisher="savePublisher" />
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import PublisherForm from "../../components/PublisherForm.vue"
import { usePublishersStore } from "../../stores/publishers";
import { useMessage } from '../../plugins/message';

export default {

    setup() {
        const store = usePublishersStore();
        const router = useRouter();
        const route = useRouter();
        const message = useMessage();
        let errors = ref(null);
        let publisher = {
            id: null,
            title: ""
        };
        const savePublisher = async (item) => {
            errors.value = null;
            const res = await store.updatePublisher(item);
            if (res.data.error) {
                errors.value = res.data.error;
            }
            if (errors.value && (errors.value.publisher.length)) {
                message.set('error', "Errors in the form ")
            }
            if (!errors.value) {
                message.set("success", `New publisher ${item.name} has been created`)
                router.push({name: 'PublisherShow', params: {id: res.data.publisher.id }});
            }
        }
        return {
            publisher, 
            errors,
            savePublisher
        }


    },
    components: { 
        PublisherForm
    }

}
</script>

<style>

</style>