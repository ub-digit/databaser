<template>
    <div class="facet-filter" v-if="mediatypes.length > 0">
        <div class="facet-header d-flex justify-content-between" :class="{active: selectedMediatype}" @click="resetSelectedMediatype" v-if="selectedMediatype">
            <span class="facet-header-text">{{
                selectedMediatypeFull.name
            }}</span>
            <span class="facet-header-action-indicator"
                ><font-awesome-icon icon="times"
            /></span>
        </div>
        <div class="facet-header d-flex justify-content-between" @click="toggleMediatypeExpanded" v-else>
            <span class="facet-header-text">Media type</span>
            <span class="facet-header-action-indicator">
                <font-awesome-icon v-if="mediatypeExpanded" icon="chevron-up"/>
                <font-awesome-icon v-else icon="chevron-down"/>
            </span>
        </div>

        <ul class="list-unstyled mediatype-list" v-if="mediatypeExpanded">
            <li v-for="mediatype in mediatypes" :key="mediatype.id">
                <a href="#" @click="setMediatypeSelected(mediatype)">
                    {{ mediatype.name }}
                </a>
            </li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: 'MediatypeFilter',
        props: {
            mediatypes: Array,
            selectedMediatypeProp: Number,
        },
        data() {
            return {
                selectedMediatype: null,
                mediatypeExpanded: false,
            }
        },
        watch: {
            selectedMediatype: function () {
                this.mediatypeExpanded = false;
                this.$emit("updateFilterMediatype", this.selectedMediatype);
            }
        },
        computed: {
            selectedMediatypeFull: function() {
                if (this.mediatypes) {
                    const mediatype = this.mediatypes.find((mediatype) => mediatype.id === this.selectedMediatype);
                    return mediatype;
                }
            },
        },
        mounted() {
            if (this.selectedMediatypeProp)  {
                this.selectedMediatype = this.selectedMediatypeProp;
            }
        },
        methods: {
            toggleMediatypeExpanded: function() {
                this.mediatypeExpanded = !this.mediatypeExpanded;
            },
            setMediatypeSelected: function (mediatype) {
                this.selectedMediatype = mediatype.id;
            },
            resetSelectedMediatype: function () {
                this.selectedMediatype = null;   
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