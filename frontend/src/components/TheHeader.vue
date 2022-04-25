<template>
  <div>
    <header>
      <div class="container-md">
        <div class="row">
          <div class="col-auto">
            <a :href="getLogoURL"><div class="logo" :class="$i18n.locale"></div></a>
          </div>
          <div class="col align-self-center">
            <div class="header">
              <div class="header-level-1">
                <a :href="getHeaderURL">
                {{ $t("components.the_header.header_level1") }}
                </a>
              </div>
              <div class="header-level-2">
                {{ $t("components.the_header.header_level2") }}
              </div>
            </div>
          </div>
          <div class="col-auto align-self-top">
            <locale-toggler/>
          </div>
        </div>
      </div>
    </header>
  </div>
</template>

<script>
import LocaleToggler from "./LocaleToggler.vue";
export default {
  components: { LocaleToggler },
  name: "TheHeader",
  computed: {
    getHeaderURL: function () {
      return this.$t("components.the_header.header_level1_link");
    },
    getLogoURL: function() {
      return this.$t("components.the_header.logo_link");
    },
  },
};
</script>

<style lang="scss" scoped>
header {
  padding-bottom: 20px;
  border-bottom: 1px solid #ccc;
  margin-bottom: 30px;
  .header {
    text-transform: uppercase;
    .header-level-1 {
      font-family: NimbusSanNovCon-Bol, "Nimbus Sans Novus Cond Bold",
        Arial Narrow, Helvetica, Arial, "Lucida Grande", sans-serif;
      font-size: 1.2rem;
      line-height: 1.2;
      @media (min-width: 768px) {
        font-size: 2rem;  
      }

      a {
        text-decoration: none;
        color:#000000;
        &:hover {
          text-decoration: underline;
        }

      }
    }
    .header-level-2 {
      font-family: NimbusSanNovCon-SemBol, "Nimbus Sans Novus Cond SemiBold",
        Arial Narrow, Helvetica, Arial, "Lucida Grande", sans-serif;
    }
  }
  .logo {
    width: 64px;
    height: 65px;
    @media (min-width: 768px) {
      width: 127px;
      height: 129px;
    }
    background-size: 100%;
    &.en {
      background-image: url("../../public/gu_logo_en_high-faf63c23d8370f48fef9567491132726.png");
    }
    &.sv {
      background-image: url("../../public/gu_logo_sv_high-9dc5fa9d776aa37d0af5991c6abce041.png");
    }
  }
}
</style>
