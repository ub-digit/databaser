<template>
<div  v-if="database" class="topicshow-wrapper">
    <div class="row pb-4">
        <div class="col">
          <h1>{{database.title_en}} / {{database.title_sv}}</h1>
        </div>
    </div>
    <div class="row pb-4">
      <div class="col">
        <label class="db-property-header" for="desc_en">Description (en)</label>
        <div id="desc_en" v-html="desc_en_markdown_output"></div>
      </div>
      <div class="col">
        <label class="db-property-header" for="desc_en">Description (sv)</label>
        <div id="desc_sv" v-html="desc_sv_markdown_output"></div>
      </div>
    </div>
    <div class="row pb-4">
      <div class="col-6">
        <h3>Subject</h3>
        <ul class="list-unstyled" v-if="database.topics">
          <li v-for="topic in database.topics" :key="topic.id">
            <div v-if="topic.selected">{{topic.name_en}} / {{topic.name_sv}}</div>
            <ul v-if="topic.sub_topics.length">
              <div v-for="subtopic in topic.sub_topics" :key="subtopic.id">
                <li v-if="subtopic.selected">
                    <div v-if="subtopic.selected">{{subtopic.name_sv}} / {{subtopic.name_en}}</div>
                </li>
              </div>
            </ul>
          </li>
        </ul>
      </div>
      <div class="col-6">
        <h3>Recommended in</h3>
        <ul class="list-unstyled" v-if="database.topics">
          <li v-for="topic in database.topics" :key="topic.id">
            <div v-if="topic.recommended">{{topic.name_en}} / {{topic.name_sv}}</div>
            <ul v-if="topic.sub_topics.length">
              <div v-for="subtopic in topic.sub_topics" :key="subtopic.id">
                <li v-if="subtopic.recommended">
                    <div v-if="subtopic.recommended">{{subtopic.name_sv}} / {{subtopic.name_en}}</div>
                </li>
              </div>
            </ul>
          </li>
        </ul>
      </div>
    </div> <!-- end row -->
    <div class="row pb-4">
      <div class="col">
        <h3>Media type</h3>
        <ul class="list-unstyled" v-if="database.mediatypes">
          <div v-for="mediatype in database.mediatypes" :key="mediatype.id">
            <li v-if="mediatype.selected">
              {{mediatype.name_en}} / {{mediatype.name_sv}}
            </li>
          </div>
        </ul>
      </div>
    </div> <!-- end row -->
    <div class="row pb-4">
      <div class="col">
        <h3>Publisher</h3>
        <ul class="list-unstyled" v-if="database.publishers">
          <div v-for="publisher in database.publishers" :key="publisher.id">
            <li v-if="publisher.selected">
              {{publisher.name}}
            </li>
          </div>
        </ul>
      </div>
    </div>
    <router-link class="btn btn-primary me-1" :to="{name: 'DatabaseEdit', params:{ id: database.id }}">Edit</router-link>
    <a href="#" @click.prevent="removeDatabase(publisher)" class="btn btn-danger" >Remove</a>
</div>
</template>

<script>
import { useRoute, useRouter } from 'vue-router'
import { useDatabasesStore } from "@/stores/databases"
import { computed } from 'vue'
import { marked } from 'marked'

export default {
  name: 'TopicShow',

  setup() {
    const route = useRoute();
    const router = useRouter();
    const store = useDatabasesStore();
    const database = computed(() => store.getDatabaseById(route.params.id));
    const desc_en_markdown_output = computed(() => marked(database.value.desc_en))
    const desc_sv_markdown_output = computed(() => marked(database.value.desc_sv))
    const removeDatabase = (database) => {
      if (confirm("Are you sure?")) {
        store.removeDatabase(database);
        router.push({name:'databaseindex'});
      }
    }

    

    return {
      database, 
      desc_en_markdown_output,
      desc_sv_markdown_output,
      removeDatabase
    }

  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style  lang="scss">
.db-property-header {
  font-weight: bold;
}
</style>
