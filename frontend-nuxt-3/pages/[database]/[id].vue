<template>
  <Head>
    <title>{{t('seo.application_title')}} - {{ database.title }}</title>
    <Meta name="description" :content="database.title" />
  </Head>
  <div v-if="database" class="container">
    <div class="row justify-content-sm-center">
      <div class="col col-md-8 col-lg-6">
        <div class="row">
          <div class="col-auto mb-4">
              <a href="javascript:void(0)" @click.prevent="goBack"><span class="icon"><font-awesome-icon icon="arrow-left"/></span><span v-if="display_back_url">{{t("views.database.backButton")}}</span> <span v-else>{{t("views.database.homeButton")}}</span></a>
          </div>
        </div>
        <div v-if="database.title" class="row">
          <div class="col">
            <h1>
              {{ database.title }}
            </h1>
          </div>
        </div>
        <div v-if="database.malfunction_message_active" class="row mb-4">
          <div class="col">
            <div class="alert alert-warning" role="alert"><font-awesome-icon class="text-danger" icon="triangle-exclamation"/> <span class="malfunction-message" v-html="malfunction_message_markdown_output"></span></div>
          </div>
        </div>
        <div v-if="database.description" class="row">
          <div class="col">
            <div v-html="desc_markdown_output"></div>
          </div>
        </div>
        <div class="row mb-4">
          <div v-if="(database.is_trial || database.is_new)" class="col-auto">
            <span  v-if="database.is_trial" class="badge text-bg-warning">{{t("components.database_list_row.is_trial")}}</span>
            <span  v-if="database.is_new" class="badge text-bg-success">{{t("components.database_list_row.is_new")}}</span>
          </div>
        </div>
        <div v-if="database.access_information_code" class="row">
          <div class="access-info col">
            <div v-if="database.id">
              <AccessInformation :db="database" />
            </div>
          </div>
        </div>
        <div v-if="database.urls && database.urls.length > 0" class="row">
          <div class="col">
              <ul class="list-unstyled" style="margin-bottom:0;">
                <li v-for="url in database.urls" :key="url.url" >
                  <a :href="url.url">{{t("views.database.link_prefix")}} {{url.title}} <font-awesome-icon icon="arrow-right"/></a>
                </li>
              </ul>
          </div>
        </div>
        <div class="divider"></div>
        <div v-if="database.topics && database.topics.length > 0" class="row">
          <div class="col">
              <strong>{{t("views.database.subjects")}}:</strong>
              <ul class="list-unstyled">
                <li v-for="(topic) in database.topics" :key="topic.id" >
                  <LangLink class="underlined" :to="{path: '/', query: {topic: topic.id}}">{{topic.name}}</LangLink>
                  <ul v-if="topic.sub_topics">
                    <li v-for="sub_topic in topic.sub_topics" :key="sub_topic.id">
                     <LangLink class="underlined" :to="{path: '/', query: {topic: topic.id, sub_topics: sub_topic.id}}" >{{sub_topic.name}}</LangLink> 
                    </li>
                  </ul>
                 <!-- <a :href="topic.id">{{topic.name}}</a><span v-if="index+1 < database.topics.length">, </span> -->
                </li>
              </ul>
          </div>
        </div>
        <div v-if="database.media_types && database.media_types.length > 0" class="row">
          <div class="col">
            <div>
              <strong>{{t("views.database.mediatypes")}}:</strong>
              <ul class="list-inline">
                <li class="list-inline-item" v-for="(media_type, index) in database.media_types" :key="media_type.id" >
                  <LangLink class="underlined" :to="{ path: '/', query: { mediatype: media_type.id }}">{{media_type.name}}</LangLink><span v-if="index+1 < database.media_types.length">, </span>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div v-if="database.publishers && database.publishers.length > 0" class="row">
          <div class="col">
              <strong>{{t("views.database.vendor")}}:</strong>
              <ul class="list-inline">
                <li class="list-inline-item" v-for="(publisher, index) in database.publishers" :key="publisher.id" >
                    {{publisher.name}}<span v-if="index+1 < database.publishers.length">, </span>
                </li>
              </ul>
          </div>
        </div>
        <div v-if="database.alternative_titles && database.alternative_titles.length > 0" class="row">
          <div class="col">
            <div>
              <strong>{{t("views.database.alt_title")}}:</strong>
              <ul class="list-inline">
                <li class="list-inline-item" v-for="(alternative_title, index) in database.alternative_titles" :key="index" >
                    {{alternative_title.title}}<span v-if="index+1 < database.alternative_titles.length">, </span>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div v-if="database.terms_of_use && database.terms_of_use.length > 0" class="row">
          <div class="col">
            <div>
              <strong>{{t("views.database.terms_of_use")}}</strong>
                <ul class="terms-of-use-list list-unstyled">
                  <li v-for="(terms_of_use) in database.terms_of_use" :key="terms_of_use.code">
                    <div class="row">
                      <div class="col-9">
                        {{getTermsOfUseString(terms_of_use.code)}}
                      </div>
                      <div class="col-auto">
                        <strong>
                          <span  v-if="terms_of_use.permitted">{{t("views.database.permitted")}}</span><span v-else>{{t("views.database.prohibited")}}</span>
                        </strong>
                      </div>
                    </div>
                    <div v-if="terms_of_use.description" class="row">
                      <div class="col">
                        <div class="terms-of-use-desc">
                          {{terms_of_use.description}}
                        </div>
                      </div>
                    </div>
                  </li>
                </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
    import { marked } from 'marked';
    const config = useRuntimeConfig();
    const route = useRoute();
    const router = useRouter();
    const {t, getLocale} = useI18n();
    const payload = reactive({lang: getLocale()})
    const display_back_url = router.options.history.state.back ? true : false;
    const { data: database, pending, error, refresh } = await useFetch(`${'/api/database/'}${route.params.id}`, {params: payload})

    const desc_markdown_output = computed (() => {
        return marked(database.value.description)
    })
    const malfunction_message_markdown_output = computed (() => {
        return marked(database.value.malfunction_message)
    })

    watch(
      () => route.query.lang,
      () => {
        payload.lang = getLocale();
      }
    )

    function getTermsOfUseString(code) {
        return t("shared.terms_of_use_code." + code);
    }
    function goBack() {
        display_back_url ? router.go(-1) : router.push({ path: '/', query: {lang: route.query.lang} });
    }

</script>

<style lang="scss" scoped>
    .alert-warning {
      .fa-triangle-exclamation {
        margin-right: 10px;
      }
    }
    .malfunction-message {
      p {
        display: inline-block;
      }
    }
    a {
      &.underlined {
        text-decoration: underline;
      }
    }
    .divider {
        border-bottom: 1px solid #dbdbdb;
        margin: 0 auto;
        margin-top: 20px;
        margin-bottom: 20px;
    }
    .access-info {
      font-size: .8rem;
    }
    .terms-of-use-list {
      li {
        border-top: 1px solid #ccc;
        padding: 5px 0;
        &:last-of-type {
          border-bottom: 1px solid #ccc;
        }
        .terms-of-use-desc {
          font-style: italic;
          padding: 5px 0;
          padding-left: 10px;
        }
      }
    }
    .icon {
      margin-right: 10px;
    }
</style>