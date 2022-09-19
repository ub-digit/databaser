<template>
    <MediatypeForm v-if="mediatype" :mediatype="mediatype" :errors="errors" title="Edit mediatype" @saveMediatype="saveMediatype" />
</template>

<script>
import MediatypeForm from "../../components/MediatypeForm.vue"
import {useMediatypesStore} from '@/stores/mediatypes'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref, onMounted} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'TopicEdit',
    setup() {
        const store = useMediatypesStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const mediatype = ref(null);
        let errors = ref(null);

        onMounted(async () => {
            const res = await store.getMediatypeById(route.params.id);
            mediatype.value = res;
        })
        const saveMediatype = async (mediatype) => {
            errors.value = null; 
            const res = await store.updateMediatype(mediatype);
            if (res.data.error) {
                errors.value = res.data.error;
            }
            if (errors.value && (errors.value.media_type)) {
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

<style lang="scss">
</style>