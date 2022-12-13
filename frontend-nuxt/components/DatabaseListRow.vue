<template>
    <div>
        <div class="db-row">
            <div class="db-row-header mb-3">
            <div class="row">
                <div class="col-lg-auto">
                <span v-if="database.malfunction_message_active" class="db-malfunction-msg me-2">
                  <font-awesome-icon class="text-danger" icon="triangle-exclamation" :title="malfunction_message_markdown_output" />
                </span> 
                <nuxtLink
                    class="database-link"
                    :to="localePath(`/${database.sanitized_title}/${database.id}`)"
                    >{{ database.title }} <font-awesome-icon icon="arrow-right"/>
                </nuxtLink> 
                <span v-if="database.is_trial" class="badge text-bg-warning">{{$t("components.database_list_row.is_trial")}}</span>
                <span v-if="database.is_new" class="badge text-bg-success">{{$t("components.database_list_row.is_new")}}</span>
                </div>
                <div class="col-lg-auto">
                <span class="badge bg-dark ms-4-xl" v-if="database.is_recommended">{{$t("components.database_list_row.recommended")}}</span>
                </div>
            </div>
            </div>
            <div class="db-row-body">
            <div class="db-desc" v-html="database_desc">
            </div>
            </div>
            <div class="db-row-footer">
            <div class="access-info mb-3">
                <AccessInformation :database="database" />
            </div>
            <div v-if="!database.direct_link_is_hidden" class="direct-link">
                <a v-if="getDatabaseURL" :href="getDatabaseURL.url">{{$t("components.database_list_row.link_prefix")}} {{getDatabaseURL.title}} <font-awesome-icon icon="arrow-right"/></a>
            </div>
            </div>
        </div>
        <hr>
    </div>
</template>
  
  <script>
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
  
<style lang="scss" >
  .database-link {
    font-size: 18px;
  }
  .db-desc {
    p {
      margin-bottom: 5px;
    }
  }
</style>
  