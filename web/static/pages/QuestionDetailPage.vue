<template>
  <div class="page-body">
    <div class="stackoverflow-body">
      <div v-if="hasValidQuestion">
        <question
          :question="question"
          @update="updateQuestion"
        />
      </div>
      <div
        v-for="comment in question.comments"
        :key="comment.id"
      >
        <comment
          :comment="comment"
          @update="updateQesComment"
        />
      </div>
      <!-- 質問へコメント投稿するとき、「質問コメント追加」を押すと、入力箱が出る -->
      <div v-if="commentEditing">
        <form
          class="comment-form"
          @submit.prevent="submitCommentQes"
        >
          <div class="form-group">
            <label for="form-body">質問へのコメントを追加</label>
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
              @click.prevent="cancelEdit"
            >
              キャンセル
            </button>
            <!-- ログインしてない時、質問へのコメントを投稿すると、エラーを表示 -->
            <div class="error-message">
              {{ comErrorMsg }}
            </div>
          </div>
        </form>
      </div>
      <div v-else>
        <div class="balloon-set-box right">
          <span v-if="!commentEditing">
            <button
              type="button"
              class="edit-button btn btn-link"
              @click="startEdit"
            >
              質問へのコメントを追加
            </button>
          </span>
        </div>
      </div>
      <!-- XX件の回答を表示 -->
      <h2 v-if="answers">{{ answers.length }}件の回答</h2>
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
          <label for="form-body">質問への回答を追加</label>
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
          <!-- ログインしてない時、回答を投稿すると、エラーを表示 -->
          <div class="error-message">
            {{ ansErrorMsg }}
          </div>
          </div>
        </div>
      </form>
      <router-link :to="{ name: 'QuestionListPage'}">
        一覧に戻る
      </router-link>
    </div>
    <div class="access-body">
      <div class="commercial">
        <div>
          <a href="https://www.access-company.com/">
            <img src="https://www.access-company.com/wp-content/themes/access_jp/img/logo.svg" width=500 alt="ACCESS">
          </a>
        </div>
        <a href="https://www.access-company.com/">
          <p class="commercial">世界生先端のソフトウェア技術はここに。<br>CONNECT YOUR DREAMS TO THE FUTURE</p>
        </a>
      </div>
      <div class="commercial">
        <div>
          <a href="https://www.access-company.com/news_event/archives/2018/1218/">
            <img src="https://www.access-company.com/files/2018/12/ACCESS_Twine4Car_Dashboard_B.jpg" alt="プレスリリース" width=500>
          </a>
        </div>
        <a href="https://www.access-company.com/news_event/archives/2018/1218/">
          <p class="commercial">注目の新商品 ACCESS Twine™ for Car 2.0とは！！</p>
        </a>
      </div>
      <div class="commercial">
        <div>
          <a href="https://publus.jp/">
            <img src="https://publus.jp/wp-content/themes/publus/img/cmn/logo01.png" alt="製品情報" width=500>
          </a>
        </div>
        <a href="https://publus.jp/">
          <p class="commercial">電子書籍ストアソリューション「PUBLUS（パブラス）」</p>
        </a>
      </div>


      
  </div>
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
      commentBody: '',
      commentEditing: false,
      ansErrorMsg: '',
      comErrorMsg: '',
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
      return this.sortBy(this.$store.state.answers, 'createdAt');
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
    // 質問の更新
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body });
    },
    retrieveAnswers() {
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
    // 回答の追加とエラー処理
    submitAnswer() {
      this.$store.dispatch('createAnswer', { body: this.answerBody, questionId: this.$route.params.id })
        .then(() => {
          this.answerBody = '';
        })
        .catch(() => {
          this.ansErrorMsg = 'ログインしてください';
        });
    },
    updateAnswer({ id, body }) {
      this.$store.dispatch('updateAnswer', { questionId: this.$route.params.id, id, body });
    },
    startEdit() {
      this.commentEditing = true;
      this.commentBody = this.comment.body;
    },
    cancelEdit() {
      this.commentEditing = false;
    },
    // 質問コメントの追加とエラー処理
    submitCommentQes() {
      this.$store.dispatch('createQuestionComment', { questionId: this.$route.params.id, body: this.commentBody })
        .then(() => {
          this.QuestionCommentBody = '';
          this.commentEditing = false;
        })
        .catch(() => {
          this.comErrorMsg = 'ログインしてください';
        });
    },
    updateQesComment({ id, body }) {
      this.$store.dispatch('updateQuestionComment', { questionId: this.$route.params.id, id, body });
    },
  },
};
</script>

<style scoped>
.error-message {
  color: red;
}
</style>
