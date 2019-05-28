<template>
  <div>
    <div v-if="hasValidQuestion">
      <question
        :question="question"
        @update="updateQuestion"
      />
    </div>
    <h2>質問へのコメント</h2>
    <hr>
    <div
      v-for="comment in question.comments"
      :key="comment.id"
    >
      <comment 
        :comment="comment"
        @update="updateQesComment" />
    </div>
    <form
      class="data-form"
      @submit.prevent="submitCommentQes"
    >
      <div class="form-group">
        <label for="form-body">質問へのツッコミを追加</label>
        <textarea
          id="form-body"
          v-model="QuestionCommentBody"
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
          質問コメント投稿
        </button>
      </div>
    </form>
    <h2>質問へのカイトウ</h2>
    <hr>
    <div
      v-for="answer in answers"
      :key="answer.id"
    >
      <answer
        :answer="answer"
        @update="updateAnswer"
      />
    </div>
    <form
      class="data-form"
      @submit.prevent="submitAnswer"
    >
      <div class="form-group">
        <label for="form-body">質問へのカイトウを追加</label>
        <textarea
          id="form-body"
          v-model="answerBody"
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
          回答
        </button>
      </div>
    </form>
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
      answerBody: '',
      QuestionCommentBody: '',
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },

    question() {
      return this.$store.state.question;
    },

    answers() {
      return this.sortBy(this.$store.state.answers, 'createdAt').reverse();
    },
  },
  mounted() {
    this.retrieveQuestion();
    this.retrieveAnswers();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body });
    },
    retrieveAnswers() {
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
    submitAnswer() {
      this.$store.dispatch('createAnswer', { body: this.answerBody, questionId: this.$route.params.id })
        .then(() => {
          this.answerBody = '';
        });
    },
    updateAnswer({ id, body }) {
      this.$store.dispatch('updateAnswer', { questionId: this.$route.params.id, id, body });
    },
    submitCommentQes() {
      this.$store.dispatch('createQuestionComment', { questionId: this.$route.params.id, body: this.QuestionCommentBody })
        .then(() => {
          this.QuestionCommentBody = '';
        });
    },
    updateQesComment({ id, body }) {
      this.$store.dispatch('updateQuestionComment', { questionId: this.$route.params.id, id, body});
    },
  },
};
</script>

<style scoped>
</style>
