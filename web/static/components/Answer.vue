<template>
  <div>
    <div class="main-area">
      <div v-if="answerEditing">
        <form
          class="answer-form"
          @submit.prevent="update"
        >
          <div class="form-group">
            <label for="form-answer-body">回答</label>
            <input
              id="form-answer-body"
              v-model="answerBody"
              :maxlength="authorMaxLength"
              class="body-edit form-control"
              type="text"
              minlength="1"
              required
            >
          </div>
          <div class="form-group">
            <button
              class="btn btn-primary mb-2"
              type="submit"
            >
              保存
            </button>
            <button
              class="cancel-edit-button btn btn-outline-primary mb-2"
              type="submit"
              @click.prevent="cancelEdit"
            >
              キャンセル
            </button>
          </div>
        </form>
      </div>
      <div v-else>
        <div class="author-date">
          回答者ID:&ensp;{{ answer.userId }}&ensp;/&ensp;投稿日時:&ensp;{{ answer.createdAt }}
          <span v-if="!answerEditing">
            <button
              type="button"
              class="edit-button btn btn-link"
              @click="startEdit"
            >
              回答を更新する
            </button>
          </span>
        </div>
        <div class="body">
          {{ answer.body }}
        </div>
      </div>
    </div>
    <h3>{{ answer.userId }}の回答へのコメント</h3>
    <hr>
    <div
      v-for="comment in answer.comments"
      :key="comment.id"
    >
      <comment
        :comment="comment"
        @update="updateAnsComment"
        />
    </div>
    <form
      class="data-form"
      @submit.prevent="submit"
    >
      <div class="form-group">
        <label for="form-body">{{ answer.userId }}さんの回答へのコメントを追加</label>
        <textarea
          id="form-body"
          v-model="commentBody"
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
          投稿
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Answer',
  components: {
    Comment,
  },
  props: {
    answer: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      commentBody: '',
      answerBody: '',
      answerEditing: false,
    };
  },
  methods: {
    submit() {
      this.$store.dispatch('createAnswerComment', { questionId: this.$route.params.id, answerId: this.answer.id, body: this.commentBody })
        .then(() => {
          this.commentBody = '';
        });
    },
    startEdit() {
      this.answerEditing = true;
      this.answerBody = this.answer.body;
      this.answerId = this.answer.id;
    },
    cancelEdit() {
      this.answerEditing = false;
    },
    update() {
      this.$emit('update', { id: this.answerId, body: this.answerBody });
      this.answerEditing = false;
    },
    updateAnsComment({ id, body }) {
      this.$store.dispatch('updateAnswerComment', { questionId: this.$route.params.id, answerId: this.answer.id, id, body});
    },
  },
};
</script>

<style scoped>
</style>
