<template>
    <DatabaseForm :database="database" title="New database" :errors="errors" @saveDatabase="saveDatabase" />
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import DatabaseForm from "../../components/DatabaseForm.vue"
import { useDatabasesStore } from "../../stores/databases";
import { useMessage } from '../../plugins/message';

export default {

    setup() {
        const store = useDatabasesStore();
        const router = useRouter();
        const route = useRouter();
        const message = useMessage();
        let errors = ref(null);
        let database = {
            id: null,
            title_sv: "",
            title_en: "",
            desc_sv: "",
            desc_en: ""
        };
        const saveDatabase = async (item) => {
            errors.value = await store.newDatabase(item);
            if (errors.value && (errors.value.database.length)) {
                message.set('error', "Errors in the form ")
            }
            if (!errors.value) {
                database = store.getDatabaseById(item.id);
                message.set("success", "New database has been created")
                router.push({name: 'DatabaseShow', params: {id: item.id }});
            }
        }
        return {
            database, 
            errors,
            saveDatabase
        }


    },
    components: { 
        DatabaseForm
    }

}
</script>

<style>

</style>