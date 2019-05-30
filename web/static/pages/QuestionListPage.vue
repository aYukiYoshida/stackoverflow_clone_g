<template>
  <div class="question-list-body">
    <div class="page-title">
      <h1>質問を見る</h1>
    </div>
    <div class="question-search">
      <form
        class="data-form"
        @submit.prevent="query"
      >
        <div class="form-group">
          <input
            id="form-body"
            v-model="queryBody"
            type="text"
            placeholder="検索したいキーワードを入力"
            class="body-edit form-control"
            minlength="1"
            maxlength="50"
            required
          >
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
    </div>
    <div v-if="isLoggedIn()">
      <p class="post-msg">
        <router-link to="question/create">
          質問を投稿する
        </router-link>
      </p>
      <p class="post-qes">
        <a href="https://ja.stackoverflow.com/questions/ask">
          本当に質問を投稿する
        </a>
      </p>
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
    <div v-if="resultBody.length==0&&errorMsg==''">
      <div
        v-for="question in questions"
        :key="question.id"
        class="question-list"
      >
        <div>
          <p class="title-list">
            <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
              {{ question.title }}
            </router-link>
          </p>
          <p class="author-list">
            <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
              名無しさん@{{ question.userId }}
            </router-link>
          </p>
        </div>
        <div class="additional">
          Posted at {{ question.createdAt }}
        </div>
        <hr>
      </div>
    </div>
    <div v-else-if="resultBody!=[]&&errorMsg==''">
      <div
        v-for="ques in resultBody"
        :key="ques.id"
        class="question-list"
      >
        <div>
          <p class="title-list">
            <router-link :to="{ name: 'QuestionDetailPage', params: { id: ques.id }}">
              {{ ques.title }}
            </router-link>
          </p>
          <p class="author-list">
            <router-link :to="{ name: 'UserDetailPage', params: { id: ques.userId }}">
              名無しさん@{{ ques.userId }}
            </router-link>
          </p>
        </div>
        <div class="additional">
          Posted at {{ ques.createdAt }}
        </div>
        <hr>
      </div>
    </div>
    <div>
      {{ errorMsg }}
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
      errorMsg: '',
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
      this.errorMsg = '';
      for (this.c = 0, this.l = (this.questions).length; this.c < this.l; this.c = this.c + 1) {
        if (this.questions[this.c].title.match(this.queryBody)) {
          this.resultBody.push(this.questions[this.c]);
        }
      }
      if (this.resultBody.length === 0) {
        this.errorMsg = '該当なし';
      }
      this.queryBody = '';
    },
    clear() {
      this.resultBody = [];
      this.errorMsg = '';
      this.queryBody = '';
    },
  },
};
</script>

<style scoped>
.error-message {
  color: red;
}
</style>
