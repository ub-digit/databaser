<template>
    <div v-if="topics">
        <div class="facet-filter">
            <div class="d-grid gap-2">
                <button v-if="filters.topic" role="button" class="facet-header d-flex justify-content-between" :class="{active: filters.topic}" @click="$emit('clearAllTopicsAndSubTopics')" >
                    <span class="facet-header-text">{{topicFull.name}}</span>
                    <span class="facet-header-action-indicator"><font-awesome-icon icon="xmark"/></span>
                </button>
                <button  v-else role="button" class="facet-header d-flex justify-content-between" @click="toggleTopicExpanded()">
                    <span class="facet-header-text">{{t('components.topics_filter.label_topic')}}</span>
                    <span class="facet-header-action-indicator"><span v-if="topicExpanded"><font-awesome-icon icon="chevron-up"/></span><span v-else><font-awesome-icon icon="chevron-down"/></span>
                    </span>
                </button>
            </div>
            <ul class="list-unstyled subject-list" v-if="topicExpanded">
                <li v-for="topic in topics" :key="topic.id">
                <a href="javascript:void()" @click.prevent="$emit('setTopic',topic.id)">
                    {{ topic.name }} 
                </a>
                ({{topic.count}})
                </li>
            </ul>

            <!-- sub topics --> 
            <div v-if="filters.topic">
                <div v-if="topicFull.sub_topics && topicFull.sub_topics.length">
                    <div class="d-grid gap-2">
                    <button role="button" class="facet-header d-flex justify-content-between" :class="{active: filters.sub_topics.length > 0 }" @click="toggleSubTopicsExpanded()">
                        <span class="facet-header-text">
                            <span v-if="filters.sub_topics.length < 1">
                                {{t('components.topics_filter.label_sub_topics')}}
                            </span>
                            <ul id="second-level" class="list-inline" v-if="sub_topics.length > 0">
                                <li class="list-inline-item" v-for="topic in subTopicsFull" :key="topic.id">
                                {{ topic.name }}
                                </li>
                            </ul>
                        </span>
                        <span class="face-header-action-indicator">
                        <span v-if="subTopicsExpanded"
                            ><font-awesome-icon icon="chevron-up"/></span
                        ><span v-else><font-awesome-icon icon="chevron-down"/></span>
                        </span>
                    </button>
                    </div>
                    <ul class="list-unstyled subject-terms-list" v-if="subTopicsExpanded">
                        <li v-for="topic in topicFull.sub_topics" :key="topic.id">
                            <a href="javascript:" @click.prevent="$emit('toggleSubTopic', topic.id); toggleSubTopicsExpanded()">
                                <span v-if="filters.sub_topics.includes(topic.id)"><font-awesome-icon icon="minus"/></span
                                ><span v-else><font-awesome-icon icon="plus"/></span>{{ topic.name }}
                            </a> ({{topic.count}})
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>

const props = defineProps(['topics', 'filters'])
const {t} = useI18n();
const emit = defineEmits(['setTopic', 'toggleSubTopic', 'clearAllTopicsAndSubTopics'])
const topicExpanded = ref(false);
const subTopicsExpanded = ref(false);

const isSubTopicSelected = (topic) => {
    const found = this.sub_topics.includes(topic.id);
    return found;
}

const topicFull = computed (() => {
    if (props.topics) {
        const topic = props.topics.find(
            (topic) => topic.id === props.filters.topic
        );
        return topic;
    }
})

const subTopicsFull = computed(() => {
    let res = [];
    props.topics.forEach((topic) => {
        if (topic.sub_topics) {
        topic.sub_topics.filter((topic) => {
            const found = props.filters.sub_topics.includes(topic.id);
            if (found) {
                res.push(topic);
            }
        });
        }
    });
    return res;
})

const toggleTopicExpanded = () => {
    topicExpanded.value = !topicExpanded.value;
}

const toggleSubTopicsExpanded = () => {
    subTopicsExpanded.value = !subTopicsExpanded.value;
}

watch(() => props.filters.topic, (before, after) => {
  if (props.filters.topic) {
    topicExpanded.value = false;
  }
})


const clearAllSelected = () => {
    emit("setTopic", undefined)
    toggleTopicExpanded();
    //this.toggleSubTopicsExpanded(false);
}


const sub_topics = computed(() => {
  if (props.filters && props.filters.topic) {
    return props.topics.find((topic) => topic.id === props.filters.topic)
      .sub_topics;
  }
});

</script>

<style lang="scss" scoped>
    .facet-filter {
        button {
            text-align: left;
        }
    }
  .list-inline {
    .list-inline-item:not(:last-child) {
      &:after {
        content: " + ";
      }
    }
  }
  
  ul {
    &.subject-terms-list, &.subject-list  {
      padding: 5px 10px;
      li {
          padding-bottom: 10px;
          &:last-child {
            padding-bottom: 0;
          }
      }
  
    }
    &#second-level {
      margin-bottom: 0;
    }
  }
  a {
    svg {
      color: #000;
      margin-right: 10px;
      font-size: .8rem;
    }
  }
</style>