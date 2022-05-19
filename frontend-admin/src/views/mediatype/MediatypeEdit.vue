<template>
    <MediatypeForm :mediatype="mediatype" :errors="errors" title="Edit mediatype" @saveMediatype="saveMediatype" />
</template>

<script>
import MediatypeForm from "../../components/MediatypeForm.vue"
import {useMediatypesStore} from '@/stores/mediatypes'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'TopicEdit',
    setup() {
        const store = useMediatypesStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const mediatype = store.getMediatypeById(route.params.id);
        let errors = ref(null);

        const saveMediatype = async (mediatype) => {
            errors.value = await store.updateMediatype(mediatype);
            if (errors.value && (errors.value.mediatype.length)) {
                message.set('error', "Errors in the form")
            }
            if (!errors.value) {
                message.set("success", "Mediatype has been saved")
                router.push({name: 'MediatypeShow', params: {id: mediatype.id }});
            }
        }

        return {
            mediatype,
            errors,
            saveMediatype
        }
    },
    components: { MediatypeForm }

}
</script>

<style>

</style>