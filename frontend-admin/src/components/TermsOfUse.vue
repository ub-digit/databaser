<template>
<div class="terms_of_use_wrapper">
    <div class="col">
        <h3>Terms of use</h3>
        <ul class="list-unstyled" v-if="props.terms_of_use && props.terms_of_use.length">
            <TermsOfUseRow 
                v-for="(term_of_use, index) in props.terms_of_use"
                :term_of_use="term_of_use"
                :index="index"
                :key="term_of_use.id"
                @updateTermOfUse="updateTermOfUse"
                @updateTermOfUseDescription="updateTermOfUseDescription"
            />
        </ul>
    </div>
</div>
</template>

<script>
import TermsOfUseRow from "./TermsOfUseRow.vue";
export default {
    props: ['terms_of_use'],
    emits: ['updateTermOfUse', 'updateTermOfUseDescription'],
    components: {
        TermsOfUseRow
    },

    setup(props, ctx) {
        const updateTermOfUse = (val, code) => {
            ctx.emit('updateTermOfUse', code, val);
        }
        const updateTermOfUseDescription = (val, code, lang) => {
            ctx.emit('updateTermOfUseDescription', val, code, lang);
        }
        return {
            updateTermOfUse,
            updateTermOfUseDescription,
            props
        }
    }
}
</script>