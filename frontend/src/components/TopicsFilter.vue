<template>
  <div class="facet-filter">
    <div class="facet-header d-flex justify-content-between" :class="{active: firstLevelSelectedTopic}" @click="resetFirstLevelSelected" v-if="firstLevelSelectedTopic">
      <span class="facet-header-text">{{
        firstLevelSelectedTopicFull.name
      }}</span>
      <span class="facet-header-action-indicator"
        ><font-awesome-icon icon="times"
      /></span>
    </div>
    <div class="facet-header d-flex justify-content-between" @click="toggleSubjectExpanded" v-else>
      <span class="facet-header-text">Subject</span>
      <span class="facet-header-action-indicator">
        <span v-if="subjectExpanded"
          ><font-awesome-icon icon="chevron-up"/></span
        ><span v-else><font-awesome-icon icon="chevron-down"/></span>
      </span>
    </div>

    <ul class="list-unstyled subject-list" v-if="subjectExpanded">
      <li v-for="topic in topics" :key="topic.id">
        <a href="#" @click="setFirstLevelSelected(topic)">
          {{ topic.name }}
        </a>
      </li>
    </ul>
    <div v-if="firstLevelSelectedTopic">
      <div v-if="firstLevelSelectedTopicFull.topics">
        <div
          class="facet-header d-flex justify-content-between" :class="{active: secondLevelSelectedTopics.length > 0 }" @click="toggleSubjectTermsExpanded">
          <span class="facet-header-text">
            <span v-if="secondLevelSelectedTopics.length <= 0">
              Subject terms
            </span>
            <ul id="second-level" class="list-inline" v-if="secondLevelSelectedTopics.length > 0">
              <li
                class="list-inline-item"
                v-for="topic in secondLevelSelectedTopicsFull"
                :key="topic.id"
              >
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
          <li
            v-for="topic in firstLevelSelectedTopicFull.topics"
            :key="topic.id"
          >
            <a href="#" @click="setSecondLevelSelected(topic)">
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
  props: {
    topics: Array,
    firstLevelSelectedTopicProp: Number,
    secondLevelSelectedTopicsProp: Array,
  },
  data() {
    return {
      firstLevelSelectedTopic: null,
      secondLevelSelectedTopics: [],
      subjectExpanded: false,
      subjectTermsExpanded: false,
    };
  },

  watch: {
    firstLevelSelectedTopic: {
      deep: true,
      handler() {
        if (!this.firstLevelSelectedTopic) {
          this.secondLevelSelectedTopics = [];
          this.subjectTermsExpanded = false;
        }
        this.$emit(
          "updateFilterTopicsFirstLevel",
          this.firstLevelSelectedTopic
        );
      },
    },
    secondLevelSelectedTopics: {
      deep: true,
      handler() {
        this.$emit(
          "updateFilterTopicsSecondLevel",
          this.secondLevelSelectedTopics
        );
      },
    },
  },
  computed: {
    firstLevelSelectedTopicFull: function() {
      if (this.topics) {
        const topic = this.topics.find(
          (topic) => topic.id === this.firstLevelSelectedTopic
        );
        return topic;
      }
    },
    secondLevelSelectedTopicsFull: function() {
      let res = [];
      this.topics.forEach((topic) => {
        if (topic.topics) {
          topic.topics.filter((topic) => {
            const found = this.secondLevelSelectedTopics.includes(topic.id);
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
    if (this.firstLevelSelectedTopicProp) {
      this.firstLevelSelectedTopic = this.firstLevelSelectedTopicProp;
    }
    if (this.secondLevelSelectedTopicsProp) {
      this.secondLevelSelectedTopics = [...this.secondLevelSelectedTopicsProp];
    }
  },
  methods: {
    isSecondLevelTopicSelected: function(topic) {
      const found = this.secondLevelSelectedTopics.includes(topic.id);
      return found;
    },
    toggleSubjectExpanded: function() {
      this.subjectExpanded = !this.subjectExpanded;
    },
    toggleSubjectTermsExpanded: function() {
      this.subjectTermsExpanded = !this.subjectTermsExpanded;
    },
    setFirstLevelSelected: function(topic) {
      this.firstLevelSelectedTopic = topic.id;
      this.toggleSubjectExpanded();
    },
    setSecondLevelSelected: function(topic) {
      const found = this.secondLevelSelectedTopics.includes(topic.id);
      if (!found) {
        this.secondLevelSelectedTopics.push(topic.id);
      } else {
        const index = this.secondLevelSelectedTopics.indexOf(topic.id);
        if (index > -1) {
          this.secondLevelSelectedTopics.splice(index, 1);
        }
      }
      this.toggleSubjectTermsExpanded();
    },
    resetFirstLevelSelected: function() {
      this.firstLevelSelectedTopic = null;
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