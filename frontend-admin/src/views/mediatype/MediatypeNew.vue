<template>
    <MediatypeForm :mediatype="mediatype" title="New mediatype" :errors="errors" @saveMediatype="saveMediatype" />
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import MediatypeForm from "../../components/MediatypeForm.vue"
import { useMediatypesStore } from "../../stores/mediatypes";
import { useMessage } from '../../plugins/message';

export default {

    setup() {
        const store = useMediatypesStore();
        const router = useRouter();
        const route = useRouter();
        const message = useMessage();
        let errors = ref(null);
        let mediatype = {
            id: null,
            title_sv: "",
            title_en: "",
        };
        const saveMediatype = async (item) => {
            errors.value = await store.newMediatype(item);
            if (errors.value && (errors.value.mediatype.length)) {
                message.set('error', "Errors in the form ")
            }
            if (!errors.value) {
                mediatype = store.getMediatypeById(item.id);
                message.set("success", "New mediatype has been saved")
                router.push({name: 'MediatypeShow', params: {id: item.id }});
            }
        }
        return {
            mediatype, 
            errors,
            saveMediatype
        }


    },
    components: { 
        MediatypeForm
    }

}
</script>

<style>

</style>