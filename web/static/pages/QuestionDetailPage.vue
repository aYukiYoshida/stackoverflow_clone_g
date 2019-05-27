<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question" 
      @update="updateQuestion"
      />
    </div>
    <br>
    <hr>
    <h1>ツッコミ</h1>
    <div
      v-for="comment in question.comments"
      :key="comment.id"
    >
      <comment :comment="comment" />
    </div>
    <hr>
    <router-link :to="{ name: 'QuestionListPage'}">
      一覧に戻る
    </router-link>
  </div>
</template>

<script>
import Question from '@/components/Question';
import Answer from '@/components/Answer';
import Comment from '@/components/Comment';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
    Comment,
  },
  data() {
    return {
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },

    question() {
      return this.$store.state.question;
    },
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body });
    },
  },
};
</script>

<style scoped>
</style>
