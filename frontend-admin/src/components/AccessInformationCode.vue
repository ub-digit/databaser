<template>
    <div>
        <FormKit
            :classes="{input: 'form-select'}"
            type="select"
            label="Select access information code"
            name="access_code"
            placeholder="Choose"
            v-model="selected"
            @change="updateAccessInformationCodeVal"
            :options="[
                { label: $t('access_information_codes.available_to_the_university_of_gothenburg'), value: 'available_to_the_university_of_gothenburg' },
                { label: $t('access_information_codes.freely_available'), value: 'freely_available' },
                { label: $t('access_information_codes.available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone'), value: 'available_to_the_university_of_gothenburg_on_campus_only_available_to_anyone' },
                { label: $t('access_information_codes.available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers'), value: 'available_to_the_university_of_gothenburg_available_to_anyone_using_the_libraries_computers' },
            ]"
        />
    </div>
</template>


<script>
import { computed, ref, watch } from 'vue'
export default {
    props: ['access_information_code'],
    emits: ['updateAccessInformationCode'],

    setup(props, ctx) {
        const selected = ref(null);
        selected.value = props.access_information_code;
        const updateAccessInformationCodeVal = (val) => {
            ctx.emit('updateAccessInformationCode', selected.value);
        }

        return {
            updateAccessInformationCodeVal,
            selected
        }
    }
}
</script>