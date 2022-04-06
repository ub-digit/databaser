<template>
  <div>
    <div class="row justify-content-sm-center">
      <div class="col col-md-8 col-lg-6">
        <div class="row">
          <div class="col-auto mb-4">
              <a href="#" @click="goBack"><span class="icon"><font-awesome-icon icon="arrow-left"/></span>{{$t("views.database.backButton")}}</a>
          </div>
        </div>
        <div v-if="database.title" class="row">
          <div class="col">
            <h1>{{ database.title }}</h1>
          </div>
        </div>
        <div v-if="database.description" class="row">
          <div class="col">
            <p v-html="desc_markdown_output">

            </p>
          </div>
        </div>
        <div v-if="database.access_information_code" class="row">
          <div class="access-info col">
            <p v-if="database.id">
              <AccessInformation :database="database" />
            </p>
          </div>
        </div>
        <div v-if="database.urls && database.urls.length > 0" class="row">
          <div class="col">
              <ul class="list-unstyled" style="margin-bottom:0;">
                <li v-for="url in database.urls" :key="url.url" >
                  <a :href="url.url">{{$t("views.database.link_prefix")}} {{url.title}} <font-awesome-icon icon="arrow-right"/></a>
                </li>
              </ul>
          </div>
        </div>
        <div class="divider"></div>
        <div v-if="database.topics && database.topics.length > 0" class="row">
          <div class="col">
            <p>
              <strong>{{$t("views.database.subjects")}}:</strong>
              <ul class="list-unstyled">
                <li v-for="(topic, index) in database.topics" :key="topic.id" >
                  <router-link class="underlined" :to="{path: '/', query: {topic: topic.id}}">{{topic.name}}</router-link>
                  <ul v-if="topic.sub_topics">
                    <li v-for="sub_topic in topic.sub_topics" :key="sub_topic.id">
                     <router-link class="underlined" :to="{path: '/', query: {topic: topic.id, sub_topics: sub_topic.id}}" >{{sub_topic.name}}</router-link> 
                    </li>
                  </ul>
                 <!-- <a :href="topic.id">{{topic.name}}</a><span v-if="index+1 < database.topics.length">, </span> -->
                </li>
              </ul>
            </p>
          </div>
        </div>
        <div v-if="database.media_types && database.media_types.length > 0" class="row">
          <div class="col">
            <p>
              <strong>{{$t("views.database.mediatypes")}}:</strong>
              <ul class="list-inline">
                <li class="list-inline-item" v-for="(media_type, index) in database.media_types" :key="media_type.id" >
                  <router-link class="underlined" :to="{ path: '/', query: { mediatype: media_type.id }}">{{media_type.name}}</router-link><span v-if="index+1 < database.media_types.length">, </span>
                </li>
              </ul>
            </p>
          </div>
        </div>
        <div v-if="database.publishers && database.publishers.length > 0" class="row">
          <div class="col">
            <p>
              <strong>{{$t("views.database.vendor")}}:</strong>
              <ul class="list-inline">
                <li class="list-inline-item" v-for="(publisher, index) in database.publishers" :key="publisher.id" >
                    {{publisher.name}}<span v-if="index+1 < database.publishers.length">, </span>
                </li>
              </ul>
            </p>
          </div>
        </div>
        <div v-if="database.alternative_titles && database.alternative_titles.length > 0" class="row">
          <div class="col">
            <p>
              <strong>{{$t("views.database.alt_title")}}:</strong>
              <ul class="list-inline">
                <li class="list-inline-item" v-for="(alternative_title, index) in database.alternative_titles" :key="alternative_title" >
                    {{alternative_title}}<span v-if="index+1 < database.alternative_titles.length">, </span>
                </li>
              </ul>
            </p>
          </div>
        </div>
        <div v-if="database.terms_of_use && database.terms_of_use.length > 0" class="row">
          <div class="col">
            <p>
              <strong>{{$t("views.database.terms_of_use")}}</strong>
                <ul class="terms-of-use-list list-unstyled">
                  <li v-for="(terms_of_use, index) in database.terms_of_use" :key="terms_of_use.code">
                    <div class="row">
                      <div class="col-9">
                        {{getTermsOfUseString(terms_of_use.code)}}
                      </div>
                      <div class="col-auto">
                        <strong>
                          <span  v-if="terms_of_use.permitted">{{$t("views.database.permitted")}}</span><span v-else>{{$t("views.database.prohibited")}}</span>
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
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>



<script>
import AccessInformation from "../components/AccessInformation.vue";
import { useStore } from '@/pinia/store';
import { mapActions } from "pinia";
import { marked } from 'marked';
import { tsMethodSignature } from "@babel/types";

export default {
  name: "Database",
  components: {
    AccessInformation
  },

  props: {
  },
  computed: {
  },
  async mounted() {
    const id = this.$route.params.id;
    this.database = await this.fetchDatabase(id);
  },
  computed: {
      desc_markdown_output() {
        return marked(this.database.description)
      }
  },
  methods: {
    ...mapActions(useStore, ['fetchDatabase']),
    getTermsOfUseString: function (code) {
        return this.$t("shared.terms_of_use_code." + code);
    },
    goBack() {
      window.history.length > 1 ? this.$router.go(-1) : this.$router.push("/");
    },
  },
  data() {
    return {
      database: {},
    };
  },
};
</script>

<style lang="scss" scoped>

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
