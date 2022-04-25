<template>
  <div class="db-row">
    <div class="db-row-header mb-3">
      <div class="row">
        <div class="col-lg-auto">
          <span v-if="database.malfunction_message_active" class="db-malfunction-msg me-2">
            <font-awesome-icon class="text-danger" icon="exclamation-triangle" :title="malfunction_message_markdown_output"/>
          </span> 
          <router-link
            class="database-link"
            :to="{ name: 'Database', params: { id: database.id, title: database.sanitized_title }}"
            >{{ database.title }} <font-awesome-icon icon="arrow-right"/>
          </router-link> 
        </div>
        <div class="col-lg-auto">
          <span class="badge bg-dark ms-4-xl" v-if="database.is_recommended">{{$t("components.database_list_row.recommended")}}</span>
        </div>
      </div>
    </div>
    <div class="db-row-body">
      <div class="db-desc mb-2" v-html="database_desc">
      </div>
    </div>
    <div class="db-row-footer">
      <div class="access-info mb-2">
        <AccessInformation :database="database" />
      </div>
      <div class="direct-link">
        <a v-if="getDatabaseURL" :href="getDatabaseURL.url">{{$t("components.database_list_row.link_prefix")}} {{getDatabaseURL.title}} <font-awesome-icon icon="arrow-right"/></a>
      </div>
    </div>
  </div>
  <hr>
</template>

<script>
import { computed } from '@vue/reactivity';
import AccessInformation from "./AccessInformation.vue";
import { marked } from 'marked';
import { mark } from '@intlify/shared';
export default {
  name: "DatabaseListRow",
  props: {
    database: Object
  },
  components: {
    AccessInformation
  },
  computed:  {
    database_desc() {
      return marked(this.database.description.substr(0, 199) +  '...');
    },
    malfunction_message_markdown_output() {
      return marked(this.database.malfunction_message)
    },
    getDatabaseURL() {
      if (this.database.urls && this.database.urls.length) {
        if (this.database.urls.length === 1) {
          return {url: this.database.urls[0].url, title: this.database.urls[0].title}
        }
      }
      return null;
    }
  }
};
</script>

<style lang="scss" scoped></style>
