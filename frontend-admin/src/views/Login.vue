<template>
  <div class="login-wrapper">
    <div class="container">
      <div v-if="state.form.code || state.validating" class="spinner">
        Loading login...
      </div>
      <div v-else>
        <div class="koha-login">
          <div class="row justify-content-center">
            <div class="col col-md-8 col-lg-4">
              <div class="login-header mb-3">Login</div>
              <div
                v-if="state.form.error"
                class="alert alert-danger"
                role="alert"
              >
                Error logging in. Try again.
              </div>
              <form class="d-grid gap-3" @submit.prevent="sendLogin">
                <div>
                  <label class="form-label" for="userid">User</label>
                  <input
                    type="text"
                    class="form-control"
                    id="userid"
                    name="userid"
                    v-model="state.form.data.username"
                  />
                </div>
                <div>
                  <label class="form-label" for="password">Password</label>
                  <input
                    type="password"
                    class="form-control"
                    id="password"
                    name="password"
                    v-model="state.form.data.password"
                  />
                </div>
                <div class="d-grid">
                  <button type="submit" class="btn btn-primary">Send</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { watch } from "vue";
import { reactive } from "vue";
import { onMounted } from "vue";
import { useRoute } from "vue-router";
import { useAuth } from "@websanova/vue-auth/src/v3.js";
export default {
  setup() {
    const auth = useAuth();
    const route = useRoute();
    const state = reactive({
      validating: false,
      form: {
        error: false,
        body: {},
        data: {},
        code: false,
        params: {
          state: {
            remember: false,
            staySignedIn: true,
            fetchUser: false,
          },
        },
      },
    });
    watch(() => {
      return route.params.type;
    }, reset);
    onMounted(() => {
      reset();
      if (route.params.type == "cas") {
        authCAS();
      } else if (state.form.code) {
        oauth2Default(route.params.type);
      }
    });
    function reset() {
      delete state.form.url;
      delete state.form.state;
      state.form.body = {};
      state.form.data = {};
      state.form.code = route.query.code ? true : false;
      if (state.form.code) {
        state.form.url = `${process.env["VUE_APP_BACKEND_BASE_URL"]}/auth/${route.params.type}`;
        state.form.state = route.query.state;
        state.form.data.code = route.query.code;
      }
    }
    async function sendLogin() {
      state.form.data.provider = "databaser";
      try {
        await auth.login({
          data: state.form.data,
          remember: state.form.remember ? '{"name": "Default"}' : null,
          fetchUser: false,
          staySignedIn: true,
          redirect: "/",
        });
      } catch (_) {
        state.form.error = true;
      }
    }

    return {
      state,
      sendLogin,
    };
  },
};
</script>

<style lang="scss" scoped>
.login-wrapper {
  .cas-login {
    a {
      .logo {
        img {
          width: 193px;
          height: 30;
        }
      }
      color: black;
      text-decoration: none;
      &:hover {
        text-decoration: underline;
      }
      .card {
        text-decoration: none;
        .login-header {
          text-decoration: none;
        }
      }
    }
  }
  .login-header {
    font-size: 1.3rem;
    font-weight: 700;
  }
  .divider {
    font-size: 1rem;
    color: #767676;
    border-bottom: 2px solid #767676;
    margin-top: 10px;
    .text {
      font-weight: 700;
      position: relative;
      top: 12px;
      background-color: white;
    }
  }
  .error {
    border: 1px solid red;
    display: inline-block;
    padding: 5px;
    padding-top: 5px;
    margin-top: 10px;
    border-radius: 5px;
    padding-top: 7px;
    background-color: #f99;
    font-weight: bold;
    width: 20em;
  }
}
</style>
