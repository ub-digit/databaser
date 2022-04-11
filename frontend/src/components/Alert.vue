<template>
    <div class="alert alert-warning" v-if="messageToDisplay" v-html="messageToDisplay"></div>
</template>

<script>
import { ref, computed } from 'vue'
import { useIntervalFn } from '@vueuse/core'
import axios from 'axios'
import { useI18n } from 'vue-i18n'
import { marked } from 'marked'

export default {
  props: ['url', 'interval'],
  setup(props) {
    const interval = props.interval ? props.interval * 1000 : 60000;
    const message = ref();
    const i18n = useI18n({ useScope: 'global' });
    const messageToDisplay = computed(() => {
        return marked(message.value[i18n.locale.value]);
    });
    fetchAlert(props.url);
    
    useIntervalFn(() => {
      fetchAlert(props.url)
    }, interval)
    async function fetchAlert(url) {
        if (!url) {
            message.value = {en: '<div><strong>Ebsqo</strong></div> Just nu är det problem med att hitta peer-review-artiklar i flera databaser från Ebsco, exempelvis i Cinahl, Business source premier, Education research complete och SportDiscus. Filtrering på peer-review ger felaktigt 0 träffar i dessa databaser. Problemet är felanmält till Ebsco.', sv: 'test sv'}
        } else {
            try {
              let result = await axios.get(url)
              message.value = result.data
            } catch {
              message.value = {}
            }
        }
    }
    return {
      messageToDisplay
    }
  },
}
</script>