<template>
  <div>
    <div class="page-title">
      <h1>質問を見る</h1>
    </div>
    <div class="question-search">
      <p>検索したいキーワードを入力してください。</p>
      <input type="search" name="search" placeholder="タイトルを入力">
      <input type="search" name="search" placeholder="質問内容を入力">
      <input type="submit" name="submit" value="Search">
    </div>
    <div v-if="isLoggedIn()">
      <router-link to="question/create">
        質問する
      </router-link>
    </div>
    <div v-if="!isLoggedIn()" class="animated infinite bounce">
      <router-link 
        to="/login"
        class="error-message"
      >
        質問するにはログインしてください
      </router-link>
    </div>
    <hr>
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
</template>

<script>

export default {
  name: 'QuestionListPage',
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
