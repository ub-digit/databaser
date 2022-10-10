<template>
    <div class="alert alert-warning" v-if="message" >
      <div class="row">
        <div class="col-auto">
          <font-awesome-icon icon="circle-info" />
        </div>
        <div class="col">
          <span v-html="message"></span>
        </div>
      </div>
    </div>
</template>

<script>
//import { ref, computed } from 'vue'

import axios from 'axios'
import {marked} from 'marked'

export default {
    props: ['url', 'interval'],
    data() {
        return {
            pollInterval: this.interval ? this.interval * 1000 : 60000,
            message: null,
            polling: null
        }
    },
    watch: {
        '$i18n.locale'() {
            this.$fetch();
        }
    // whenever question changes, this function will run

    },
    mounted() {
        this.updateMessageToDisplay();
    },
    async fetch() {
        try {
            if (this.url) {
                const res = await (await axios.get(this.url)).data
                this.message = marked(res[this.$i18n.locale]);
            }
        } catch (error) {
            console.log(error);
        }
    },
    methods: {
        updateMessageToDisplay() {
            this.polling = setInterval(() => {
                this.message = this.$fetch();
            }, this.pollInterval);
        }
    },
    beforeDestroy () {
        clearInterval(this.polling)
    },

    computed: {
    },
}
</script>