<template>
  <div class="question-list-body">
    <div class="page-title">
      <h1>メッセージを見る</h1>
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
    </div>
    <div v-if="isLoggedIn()">
      <p class="post-msg">
        <router-link to="question/create">
          メッセージを投稿する
        </router-link>
      </p>
      <p class="post-qes">
        <a href="https://ja.stackoverflow.com/questions/ask">
          質問したい方はこちら
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
    <div v-else-if="resultBody!=[]&&errorMsg==''">
      <div
        v-for="ques in resultBody"
        :key="ques.id"
        class="question-list"
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
.title {
  text-overflow: ellipsis;
  overflow: hidden;
}
.error-message {
  color: red;
}
</style>
