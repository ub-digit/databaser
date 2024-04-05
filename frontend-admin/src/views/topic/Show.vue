<template>
  <div v-if="topic" class="topicshow-wrapper">
    <div class="row">
      <div class="col">
        <h1>{{ topic.name_en }} / {{ topic.name_sv }}</h1>

        <p v-if="topic.alternative_names_en || topic.alternative_names_sv">
          <strong>Alternative names:</strong>
          {{ topic.alternative_names_en }} / {{ topic.alternative_names_sv }}
        </p>
      </div>
    </div>
    <div class="row">
      <div class="col">
        <div v-show="cannotBeDeleted" class="alert alert-warning" role="alert">
          This topic has subtopics. First remove all subtopics before you can
          delete this topic.
        </div>
      </div>
    </div>
    <div class="row" v-if="topic.sub_topics && topic.sub_topics.length">
      <div class="col">
        <h2>Subtopics</h2>
        <ul>
          <li v-for="sub_topic in topic.sub_topics" :key="sub_topic.id">
            {{ sub_topic.name_en }} / {{ sub_topic.name_sv }}
            <span
              v-if="
                sub_topic.alternative_names_en || sub_topic.alternative_names_sv
              "
              >({{ sub_topic.alternative_names_en }} /
              {{ sub_topic.alternative_names_sv }})</span
            >
          </li>
        </ul>
      </div>
    </div>
    <router-link
      class="btn btn-primary me-1"
      :to="{ name: 'TopicEdit', params: { id: topic.id } }"
      >Edit</router-link
    >
    <a
      href="#"
      @click.prevent="removeTopic(topic)"
      class="btn btn-danger"
      :class="{ disabled: cannotBeDeleted }"
      >Remove</a
    >
  </div>
</template>

<script>
import { useRoute, useRouter } from "vue-router";
import { useTopicsStore } from "@/stores/topics";
import { computed, onMounted, ref } from "vue";
import { useMessage } from "../../plugins/message";

export default {
  name: "TopicShow",
  setup() {
    const route = useRoute();
    const router = useRouter();
    const topicsStore = useTopicsStore();
    const topic = ref(null);
    const message = useMessage();

    const removeTopic = async (topic) => {
      if (confirm("Are you sure?")) {
        await topicsStore.removeTopic(topic);
        message.set("success", "Topic has been deleted");
        router.push({ name: "index" });
      }
    };
    onMounted(async () => {
      topic.value = await topicsStore.getTopicById(route.params.id);
      window.scrollTo(0, 0);
    });
    const cannotBeDeleted = computed(() => {
      if (topic.value.sub_topics && topic.value.sub_topics.length) {
        return true;
      }
      return false;
    });
    return {
      topic,
      removeTopic,
      cannotBeDeleted,
    };
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss"></style>
