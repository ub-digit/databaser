<template>
    <div>
        <h1 class="mb-4" >Edit general alert message</h1>
        <div v-if="alert_msg">
            <div class="row mb-4">
                <div class="col">
                    <div class="form-check">
                        <input type="checkbox" id="enabled" class="form-check-input" v-model="alert_msg.show_alert_message" />
                        <label class="form-check-label" for="enabled">Is enabled</label>
                    </div>
                </div>
            </div>
            <div class="row mb-4">
                <div class="col-6">
                    <textarea class="form-control" rows="5" id="alert_msg_en" v-model="alert_msg.en"></textarea>
                </div>            
                <div class="mute col-6">
                    <span v-html="marked(alert_msg.en)"></span>
                </div>
            </div>
            <div class="row mb-4">
                <div class="col-6">
                    <textarea class="form-control" rows="5" id="alert_msg_en" v-model="alert_msg.sv"></textarea>
                </div>            
                <div class="mute col-6">
                    <span v-html="marked(alert_msg.sv)"></span>
                </div>
            </div>

            <div class="row">
                <h3>Markdown</h3>
                <div class="col">
                    <ul>
                        <li>[link title](link url)</li>
                        <li>Two or more spaces at a line's end = Line break</li>
                        <li>Double returns = Paragraph</li>  
                        <li>*Single asterisks* or _single underscores_ = Emphasis</li>
                        <li>**Double** or __double__ = Strong</li>
                    </ul>
                    
                </div>
            </div>
            <div class="row mb-4">
                <div class="col">
                    <input type="submit" :disabled="!isDirty" class="btn btn-primary" @click.prevent="saveAlert()" value="save">
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
    import {useAlertStore} from '@/stores/alert'
    import {useRoute, useRouter, onBeforeRouteLeave} from 'vue-router'
    import _ from 'lodash'
    import {ref, onMounted, computed, nextTick} from 'vue'
    import {useMessage} from '@/plugins/message'
    import { marked } from 'marked'

    const store = useAlertStore();
    const route = useRoute();
    const router = useRouter();
    const message = useMessage();
    const alert_msg = ref(null);
    let alert_msg_initial_state = {}
    let errors = ref(null);

    const isDirty = computed(() => _.isEqual(alert_msg.value, alert_msg_initial_state) ? false: true);


    onBeforeRouteLeave(() => {
      if (isDirty.value) {
        const answer = window.confirm("It looks like you have been editing something. If you leave before saving, your changes will be lost.");
        if (!answer) return false;
      }
    })

    onMounted(async () => {
        fetchAlert();
    })


    const fetchAlert = async () => {
        const res = await store.getAlertMessage();
        alert_msg_initial_state = _.cloneDeep(res);
        alert_msg.value = res;
    }
    const saveAlert = async () => {
        try {
            const res = await store.saveAlertMessage(alert_msg.value);
            await fetchAlert();
            message.set("success", "Alert message has been saved")
        } catch (error) {
            console.log(error);
        }
    }

</script>

<style lang="scss" scoped>
.mute {
    opacity: .5;
}
</style>