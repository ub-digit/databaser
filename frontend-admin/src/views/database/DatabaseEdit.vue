<template>
    <DatabaseForm :database="database" :errors="errors" title="Edit database" @saveDatabase="saveDatabase" />
</template>

<script>
import DatabaseForm from "../../components/DatabaseForm.vue"
import {useDatabasesStore} from '@/stores/databases'
import {useRoute, useRouter} from 'vue-router'
import _ from 'underscore'
import {ref} from 'vue'
import {useMessage} from '@/plugins/message'

export default {
    name: 'DatabaseEdit',
    setup() {
        const store = useDatabasesStore();
        const route = useRoute();
        const router = useRouter();
        const message = useMessage();
        const database = store.getDatabaseById(route.params.id);
        let errors = ref(null);

        const saveDatabase = async (database) => {
            errors.value = await store.updateDatabase(database);
            if (errors.value && (errors.value.database.length)) {
                message.set('error', "Errors in the form")
            }
            if (!errors.value) {
                message.set("success", "database has been saved")
                router.push({name: 'DatabaseShow', params: {id: database.id }});
            }
        }

        return {
            database,
            errors,
            saveDatabase
        }
    },
    components: { DatabaseForm }

}
</script>

<style>

</style>