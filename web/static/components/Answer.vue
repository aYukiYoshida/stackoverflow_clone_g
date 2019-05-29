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
        <div class="balloon-set-box left">
          <div class="author">
            <router-link
              :to="{ name: 'UserDetailPage', params: { id:
                answer.userId }}"
            >
              名無しさん@{{ answer.userId }}
            </router-link>
          </div>
          <div class="body balloon">
            {{ answer.body }}
            <span v-if="!answerEditing&&hasValidAnsAuthorization">
              <button
                type="button"
                class="edit-button btn btn-link"
                @click="startEdit"
              >
                更新する
              </button>
            </span>
          </div>
        </div>
        <div class="date-left">
          <p>Answer at {{ answer.createdAt }}</p>
        </div>
      </div>
    </div>
    <div
      v-for="comment in answer.comments"
      :key="comment.id"
    >
      <comment
        :comment="comment"
        @update="updateAnsComment"
      />
    </div>
    <!-- 回答へコメント投稿するとき、「回答コメント追加」を押すと、入力箱が出る -->
    <div v-if="commentEditing">
      <form
        class="comment-form"
        @submit.prevent="submit"
      >
        <div class="form-group">
          <label for="form-body">名無しさん@{{ answer.userId }}さんの回答へのコメントを追加</label>
          <input
            id="form-body"
            v-model="commentBody"
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
            投稿
          </button>
          <button
            class="cancel-edit-button btn btn-outline-primary mb-2"
            type="submit"
            @click.prevent="cancelCommentEdit"
          >
            キャンセル
          </button>
          <!-- ログインしてない時、回答コメントを投稿すると、エラーを表示 -->
          <div class="animated infinite bounce">
            <div class="error-message">
              {{ ansComErrMsg }}
            </div>
          </div>
        </div>
      </form>
    </div>
    <div v-else>
      <div class="balloon-set-box right">
        <div
          v-if="!commentEditing"
          class="btn_3d_jumpback"
        >
          <button
            v-if="isLoggedIn()"
            type="button"
            class="edit-button btn btn-link"
            @click="startCommentEdit"
          >
            回答へのコメントを追加
          </button>
        </div>
      </div>
    </div>
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
      commentEditing: false,
      ansComErrMsg: '',
    };
  },
  computed: {
    hasValidAnsAuthorization() {
      return this.answer.userId === this.$store.state.id;
    },
    hasValidComAuthorization() {
      return this.comment.userId === this.$store.state.id;
    },
  },
  methods: {
    startCommentEdit() {
      this.commentEditing = true;
      this.commentBody = this.comment.body;
    },
    cancelCommentEdit() {
      this.commentEditing = false;
    },
    // 回答コメントの追加とエラー処理
    submit() {
      this.$store.dispatch('createAnswerComment', { questionId: this.$route.params.id, answerId: this.answer.id, body: this.commentBody })
        .then(() => {
          this.commentBody = '';
          this.commentEditing = false;
        })
        .catch(() => {
          this.ansComErrMsg = 'ログインしてください';
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
      this.$store.dispatch('updateAnswerComment', {
        questionId: this.$route.params.id, answerId: this.answer.id, id, body,
      });
    },
  },
};
</script>

<style scoped>
.error-message {
  color: red;
}
</style>
