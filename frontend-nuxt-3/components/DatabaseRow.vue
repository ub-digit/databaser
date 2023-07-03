<template>
<div>
    <div class="db-row">
        <div class="db-row-header mb-3">
        <div class="row">
            <div class="col-lg-auto">
            <span v-if="db.malfunction_message_active" class="db-malfunction-msg me-2">
              <font-awesome-icon class="text-danger" icon="triangle-exclamation" :title="malfunction_message_markdown_output" />
            </span> 
            <LangLink class="database-link" :to="`/${db.sanitized_title}/${db.id}`">{{ db.title }} <font-awesome-icon class="fa-xs" icon="arrow-right"/></LangLink>&nbsp;
             <span v-if="db.is_trial" class="badge text-bg-warning">{{t("components.database_list_row.is_trial")}}</span>&nbsp;
             <span v-if="db.is_new" class="badge text-bg-success">{{t("components.database_list_row.is_new")}}</span>
            </div>
            <div class="col-lg-auto">
            <span class="badge bg-dark ms-4-xl" v-if="db.is_recommended">{{t("components.database_list_row.recommended")}}</span>
            </div>
        </div>
        </div>
        <div class="db-row-body">
        <div class="db-desc" v-html="database_desc">
        </div>
        </div>
        <div class="db-row-footer">
        <div class="access-info mb-3">
            <AccessInformation :db="db" />
        </div>
        <div v-if="db.urls && db.urls.length === 1">
          <div v-if="!db.direct_link_is_hidden" class="direct-link">
            <a v-if="(db.urls && db.urls.length)" :href="db.urls[0].url">{{t("components.database_list_row.link_prefix")}} {{db.urls[0].title}} <font-awesome-icon class="fa-xs" icon="arrow-right"/></a>
          </div>
        </div>
        </div>
    </div>
    <hr>
</div>
</template>

<script setup>
import { marked } from 'marked';
const {t} = useI18n();
const props = defineProps(['db'])

const database_desc = computed(() => {
  return marked(props.db.description.substr(0, 199) +  '...');
})
const malfunction_message_markdown_output = computed(() => {
  return marked(props.db.malfunction_message)
})

</script>

<style lang="scss" scoped>
    .fa-arrow-right {
      font-size: 12px !important;
    }
  .database-link {
    font-size: 18px;
  }
  .db-desc {
    p {
      margin-bottom: 5px;
    }
  }
</style>