<template>
    <div class="facet-filter">
      <div class="d-grid gap-2">
        <button role="button" class="facet-header d-flex justify-content-between" :class="{active: topic}" @click="clearAllSelected()" v-if="topic">
          <span class="facet-header-text">{{
            topicFull.name
          }}</span>
          <span class="facet-header-action-indicator"
            ><font-awesome-icon icon="xmark"
          /></span>
        </button>
        <button role="button" class="facet-header d-flex justify-content-between" @click="toggleTopicExpanded()" v-else>
          <span class="facet-header-text">{{$t('components.topics_filter.label_topic')}}</span>
          <span class="facet-header-action-indicator">
            <span v-if="topicExpanded"
              ><font-awesome-icon icon="chevron-up"/></span
            ><span v-else><font-awesome-icon icon="chevron-down"/></span>
          </span>
        </button>
      </div>
  
      <ul class="list-unstyled subject-list" v-if="topicExpanded">
        <li v-for="topic in topics" :key="topic.id">
          <a href="javascript:" @click.prevent="setTopicSelected(topic.id)">
            {{ topic.name }} 
          </a>
          ({{topic.count}})
        </li>
      </ul>
      <div v-if="topic">
        <div v-if="topicFull.sub_topics && topicFull.sub_topics.length">
          <div class="d-grid gap-2">
          <button role="button" class="facet-header d-flex justify-content-between" :class="{active: sub_topics.length > 0 }" @click="toggleSubTopicsExpanded()">
            <span class="facet-header-text">
              <span v-if="sub_topics.length <= 0">
                {{$t('components.topics_filter.label_sub_topics')}}
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
              <a href="javascript:" @click.prevent="setSubTopicslSelected(topic)">
                <span v-if="isSubTopicSelected(topic)"><font-awesome-icon icon="minus"/></span
                ><span v-else><font-awesome-icon icon="plus"/></span>{{ topic.name }}
              </a>({{topic.count}})
            </li>
          </ul>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: "TopicsFilter.vue",
    props: ['topics', 'topic', 'sub_topics'],
    data() {
      return {
        topicExpanded: false,
        subTopicsExpanded: false,
      };
    },
    watch: {
    },
    computed: {
      topicFull: function() {
        if (this.topics) {
          const topic = this.topics.find(
            (topic) => topic.id === this.topic
          );
          return topic;
        }
      },
      subTopicsFull: function() {
        let res = [];
        this.topics.forEach((topic) => {
          if (topic.sub_topics) {
            topic.sub_topics.filter((topic) => {
              const found = this.sub_topics.includes(topic.id);
              if (found) {
                res.push(topic);
              }
            });
          }
        });
        return res;
      },
    },
  
    mounted() {
    },
    methods: {
      isSubTopicSelected: function(topic) {
        const found = this.sub_topics.includes(topic.id);
        return found;
      },
      toggleTopicExpanded: function(open) {
        if (open === undefined) {
          this.topicExpanded = !this.topicExpanded;
        }
        else {
          this.topicExpanded = open;
        }
  
      },
      toggleSubTopicsExpanded: function(open) {
        if (open === undefined) {
          this.subTopicsExpanded = !this.subTopicsExpanded;
        }
        else {
          this.subTopicsExpanded = open;
        }
      },
  
      clearAllSelected: function() {
        this.$emit("clearAllSelected")
        this.toggleTopicExpanded(false);
        this.toggleSubTopicsExpanded(false);
      },
  
      setTopicSelected: function(topic) {
        if (topic) {
          this.toggleTopicExpanded(false);
        }
        this.$emit("updateFilterTopic", topic.toString());
      },
      setSubTopicslSelected: function(topic) {
        let sub_topics = [...this.sub_topics];
        if (!topic) { // reset on null
          sub_topics = [];
        }
        else {
          const found = sub_topics.includes(topic.id);
          if (!found) {
            sub_topics.push(topic.id);
          } else {
            const index = sub_topics.indexOf(topic.id);
            if (index > -1) {
              sub_topics.splice(index, 1);
            }
          }
        }
        this.$emit("updateFilterSubTopics", sub_topics);
        this.toggleSubTopicsExpanded(false);
      },
    }, 
  };
  </script>
  
  <style lang="scss" scoped>
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