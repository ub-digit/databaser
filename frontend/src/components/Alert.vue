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
        if (message.value) {
          return marked(message.value[i18n.locale.value]);
        }
        return null;
    });
    fetchAlert(props.url);
    
    useIntervalFn(() => {
      fetchAlert(props.url)
    }, interval)

    async function fetchAlert(url) {
        if (!url) {
            message.value = null;
        } else {
            try {
              let result = await axios.get(url)
              message.value = result.data
            } catch {
              message.value = null;
            }
        }
    }
    return {
      messageToDisplay
    }
  },
}
</script>