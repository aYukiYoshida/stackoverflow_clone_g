<template>
  <div>
    <div class="page-title">
      <h1>質問を見る</h1>
    </div>
    <form
      class="data-form"
      @submit.prevent="query"
    >
      <div class="form-group">
        <label for="form-body">質問タイトルを検索</label>
        <textarea
          id="form-body"
          v-model="queryBody"
          class="body-edit form-control"
          minlength="1"
          maxlength="50"
          required
        />
      </div>
      <div class="form-group">
        <button
          class="btn btn-primary mb-2"
          type="submit"
        >
          検索
        </button>
        <button
          class="btn btn-primary mb-2"
          type="submit"
          @click.prevent="clear"
        >
          クリア
        </button>
      </div>
    </form>
    <div v-if="isLoggedIn()">
      <router-link to="question/create">
        質問する
      </router-link>
    </div>
    <div
      v-if="!isLoggedIn()"
      class="animated infinite bounce"
    >
      <router-link
        to="/login"
        class="error-message"
      >
        質問するにはログインしてください
      </router-link>
    </div>
    <hr>
    <div v-if="resultBody==''">
      <div
        v-for="question in questions"
        :key="question.id"
      >
        <h5 class="title">
          <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
            {{ question.title }}
          </router-link>
        </h5>
        <div class="additional">
          Posted at {{ question.createdAt }}
          by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
            {{ question.userId }}
          </router-link>
        </div>
        <hr>
      </div>
    </div>
    <div v-else>
      <div
        v-for="ques in resultBody"
        :key="ques.id"
      >
        <h5 class="title">
          <router-link :to="{ name: 'QuestionDetailPage', params: { id: ques.id }}">
            {{ ques.title }}
          </router-link>
        </h5>
        <div class="additional">
          Posted at {{ ques.createdAt }}
          by <router-link :to="{ name: 'UserDetailPage', params: { id: ques.userId }}">
            {{ ques.userId }}
          </router-link>
        </div>
        <hr>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'QuestionListPage',
  data() {
    return {
      queryBody: '',
      resultBody: [],
      c: 0,
      l: 0,
    };
  },
  computed: {
    questions() {
      return this.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestions();
  },
  methods: {
    retrieveQuestions() {
      this.$store.dispatch('retrieveQuestions');
    },
    query() {
      this.resultBody = [];
      for (this.c = 0, this.l = (this.questions).length; this.c < this.l; this.c = this.c + 1) {
        if (this.questions[this.c].title.match(this.queryBody)) {
          this.resultBody.push(this.questions[this.c]);
        }
      }
    },
    clear() {
      this.resultBody = [];
    },
  },
};
</script>

<style scoped>
.title {
  text-overflow: ellipsis;
  overflow: hidden;
}
.error-message {
  color: red;
}
</style>
