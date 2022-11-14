<template>
    <div class="facet-filter" v-if="mediatypes.length > 0">
        <div class="d-grid gap-2">
            <button role="button" class="facet-header d-flex justify-content-between" :class="{active: mediatype}" @click="setMediatypeSelected()" v-if="mediatype">
                <span class="facet-header-text">{{
                    selectedMediatypeFull.name
                }}</span>
                <span class="facet-header-action-indicator"
                    ><font-awesome-icon icon="xmark"
                /></span>
            </button>
            <button role="button" class="facet-header d-flex justify-content-between" @click="toggleMediatypeExpanded(null)" v-else>
                <span class="facet-header-text">{{$t('components.mediatype_filter.label')}}</span>
                <span class="facet-header-action-indicator">
                    <font-awesome-icon v-if="mediatypeExpanded" icon="chevron-up"/>
                    <font-awesome-icon v-else icon="chevron-down"/>
                </span>
            </button>
        </div>
        <ul class="list-unstyled mediatype-list" v-if="mediatypeExpanded">
            <li v-for="mediatype in mediatypes" :key="mediatype.id">
                <a href="javascript:" @click.prevent="setMediatypeSelected(mediatype.id)">
                    {{ mediatype.name }}
                </a>({{mediatype.count}})
            </li>
        </ul>
    </div>
</template>

<script>
export default {
    name: 'MediatypeFilter',
    props: {
        mediatypes: Array,
        mediatype: Number,
    },
    data() {
        return {
            mediatypeExpanded: false,
        }
    },
    watch: {
    },
    computed: {
        selectedMediatypeFull: function() {
            if (this.mediatypes) {
                return this.mediatypes.find((mediatype) => mediatype.id === this.mediatype);
            }
        },
    },
    mounted() {

    },
    methods: {
        toggleMediatypeExpanded: function(open) {
            if (!open) {
                this.mediatypeExpanded = !this.mediatypeExpanded;
            }
            else {
                this.mediatypeExpanded = open;
            }
        },
        setMediatypeSelected: function (mediatype) {
            if (mediatype) {
                this.toggleMediatypeExpanded(false);
            }
            this.$emit("updateFilterMediatype", mediatype);
        }
    },
}
</script>

<style lang="scss" scoped>

ul {
    &.mediatype-list  {
        padding: 5px 10px;
        li {
            padding-bottom: 10px;
            &:last-child {
            padding-bottom: 0;
            }
        }
    }
}
</style>