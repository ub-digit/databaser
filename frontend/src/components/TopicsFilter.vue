<template>
  <div class="facet-filter">
    <div class="facet-header d-flex justify-content-between" :class="{active: topicFirstLevel}" @click="clearAllTopicLevelsSelected()" v-if="topicFirstLevel">
      <span class="facet-header-text">{{
        topicFirstLevelFull.name
      }}</span>
      <span class="facet-header-action-indicator"
        ><font-awesome-icon icon="times"
      /></span>
    </div>
    <div class="facet-header d-flex justify-content-between" @click="toggleSubjectExpanded()" v-else>
      <span class="facet-header-text">{{$t('components.topics_filter.label_first_level')}}</span>
      <span class="facet-header-action-indicator">
        <span v-if="subjectExpanded"
          ><font-awesome-icon icon="chevron-up"/></span
        ><span v-else><font-awesome-icon icon="chevron-down"/></span>
      </span>
    </div>

    <ul class="list-unstyled subject-list" v-if="subjectExpanded">
      <li v-for="topic in topics" :key="topic.id">
        <a href="javascript:" @click.prevent="setFirstLevelSelected(topic.id)">
          {{ topic.name }}
        </a>
      </li>
    </ul>
    <div v-if="topicFirstLevel">
      <div v-if="topicFirstLevelFull.topics">
        <div class="facet-header d-flex justify-content-between" :class="{active: topicsSecondLevel.length > 0 }" @click="toggleSubjectTermsExpanded()">
          <span class="facet-header-text">
            <span v-if="topicsSecondLevel.length <= 0">
              {{$t('components.topics_filter.label_second_level')}}
            </span>
            <ul id="second-level" class="list-inline" v-if="topicsSecondLevel.length > 0">
              <li class="list-inline-item" v-for="topic in topicsSecondLevelFull" :key="topic.id">
                {{ topic.name }}
              </li>
            </ul>
          </span>
          <span class="face-header-action-indicator">
            <span v-if="subjectTermsExpanded"
              ><font-awesome-icon icon="chevron-up"/></span
            ><span v-else><font-awesome-icon icon="chevron-down"/></span>
          </span>
        </div>
        <ul class="list-unstyled subject-terms-list" v-if="subjectTermsExpanded">
          <li v-for="topic in topicFirstLevelFull.topics" :key="topic.id">
            <a href="javascript:" @click.prevent="setSecondLevelSelected(topic)">
              <span v-if="isSecondLevelTopicSelected(topic)"><font-awesome-icon icon="minus"/></span
              ><span v-else><font-awesome-icon icon="plus"/></span>{{ topic.name }}
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "TopicsFilter.vue",
  props: ['topics', 'topicFirstLevel', 'topicsSecondLevel'],
  data() {
    return {
      subjectExpanded: false,
      subjectTermsExpanded: false,
    };
  },
  watch: {
  },
  computed: {
    topicFirstLevelFull: function() {
      if (this.topics) {
        const topic = this.topics.find(
          (topic) => topic.id === this.topicFirstLevel
        );
        return topic;
      }
    },
    topicsSecondLevelFull: function() {
      let res = [];
      this.topics.forEach((topic) => {
        if (topic.topics) {
          topic.topics.filter((topic) => {
            const found = this.topicsSecondLevel.includes(topic.id);
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
    isSecondLevelTopicSelected: function(topic) {
      const found = this.topicsSecondLevel.includes(topic.id);
      return found;
    },
    toggleSubjectExpanded: function(open) {
      if (open === undefined) {
        this.subjectExpanded = !this.subjectExpanded;
      }
      else {
        this.subjectExpanded = open;
      }

    },
    toggleSubjectTermsExpanded: function(open) {
      if (open === undefined) {
        this.subjectTermsExpanded = !this.subjectTermsExpanded;
      }
      else {
        this.subjectTermsExpanded = open;
      }
    },

    clearAllTopicLevelsSelected: function() {
      this.$emit("clearAllTopicLevelsSelected")
      this.toggleSubjectExpanded(false);
      this.toggleSubjectTermsExpanded(false);
    },

    setFirstLevelSelected: function(topic) {
      if (topic) {
        this.toggleSubjectExpanded(false);
      }
      this.$emit("updateFilterTopicsFirstLevel", topic.toString());
    },
    setSecondLevelSelected: function(topic) {
      let topicsSecondLevel = [...this.topicsSecondLevel];
      if (!topic) { // reset on null
        topicsSecondLevel = [];
      }
      else {
        const found = topicsSecondLevel.includes(topic.id);
        if (!found) {
          topicsSecondLevel.push(topic.id);
        } else {
          const index = topicsSecondLevel.indexOf(topic.id);
          if (index > -1) {
            topicsSecondLevel.splice(index, 1);
          }
        }
      }
      this.$emit("updateFilterTopicsSecondLevel",topicsSecondLevel);
      this.toggleSubjectTermsExpanded(false);
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