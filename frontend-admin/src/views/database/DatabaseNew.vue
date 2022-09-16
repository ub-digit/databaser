<template>
    <div v-if="database">
        <DatabaseForm :database="database" title="New database" :errors="errors" @saveDatabase="saveDatabase" />
    </div>
</template>

<script>
import { ref, computed, onMounted } from 'vue';
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
        let database = ref(null);

        onMounted(async () => {
            const res = await store.newDatabase();
            database.value = res.data;
        })
        const saveDatabase = async (database) => {
            const res = await store.updateDatabase(database);

            if (errors.value && errors.value.database && (errors.value.database.length)) {
                message.set('error', "Errors in the form")
            }
            if (!errors.value) {
                message.set("success", "database has been saved")
                router.push({name: 'DatabaseShow', params: {id: res.data.id }});
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