<template>
  <div>
    <div v-if="editing">
      <div class="form-group">
        <label for="form-title">タイトル</label>
        <input
          id="form-title"
          v-model="editingTitle"
          :maxlength="titleMaxLength"
          class="title-edit form-control"
          type="text"
          minlength="1"
          required
        >
      </div>
    </div>
    <div v-else>
      <div class="page-header">
        <h1 class="page-title">
          {{ question.title }}
        </h1>
      </div>
      <hr>
    </div>
    <div class="main-area">
      <div v-if="editing">
        <form
          class="question-form"
          @submit.prevent="update"
        >
          <div class="form-group">
            <label for="form-body">質問</label>
            <input
              id="form-body"
              v-model="editingBody"
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
              保存する
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
            <router-link :to="{ name: 'UserDetailPage', params: { id:   
              question.userId }}">名無しさん@{{ question.userId }}
            </router-link>
          </div>
          <div class="body balloon">
            {{ question.body }}
            <span v-if="!editing">
              <button
                type="button"
                class="edit-button btn btn-link"
                @click="startEdit"
              >
                更新する
              </button>
            </span>
          </div>
          <div class="date">
            <p>Question at {{ question.createdAt }}</p>
          </div>
        </div>
      </div>
      <!-- 投票ボタン -->
      <div class="form-group">
        <div v-if="question.likeVoterIds && question.dislikeVoterIds">
          <button
            class="btn btn-primary mb-2"
            type="submit"
            @click.prevent="createLikeVote"
          >
            いいね
          </button>
          {{ question.likeVoterIds.length - question.dislikeVoterIds.length }}
          <button
            class="btn btn-primary mb-2"
            type="submit"
            @click.prevent="createDislikeVote"
          >
            ディスる
          </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      newCommentauthor: '',
      editing: false,
      editingBody: '',
      editingTitle: '',
      likeVote: 'like_vote',
      dislikeVote: 'dislike_vote',
    };
  },
  mounted(){
    return
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.question.body;
      this.editingTitle = this.question.title;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { title: this.editingTitle, body: this.editingBody });
      this.editing = false;
    },
    createLikeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.$route.params.id, voteType: this.likeVote });
    },
    createDislikeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.$route.params.id, voteType: this.dislikeVote });
    },
  },
};
</script>

<style scoped>
</style>
