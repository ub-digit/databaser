<template>
  <div class="db-row">
    <div class="db-row-header mb-3">
      <router-link
        class="database-link"
        :to="{ name: 'Database', params: { id: database.id, title: database.title }}"
        >{{ database.title }} <font-awesome-icon icon="arrow-right"/></router-link> 
      <span class="badge bg-dark ms-4" v-if="database.is_recommended">{{$t("components.database_list_row.recommended")}}</span>
    </div>
    <div class="db-row-body">
      <div class="db-desc mb-2">
        {{ database.description.substr(0, 199) }}...
      </div>
      <div v-if="database.malfunction_message_active" class="db-malfunction-msg">
        <font-awesome-icon icon="exclamation" />
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
export default {
  name: "DatabaseListRow",
  props: {
    database: Object
  },
  components: {
    AccessInformation
  },
  computed:  {
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
