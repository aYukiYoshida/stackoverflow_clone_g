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
      <h1 class="question-title">
        {{ question.title }}
      </h1>
    </div>
    <hr>
    <div class="main-area">
      <div class="content-area">
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
            質問者ID:&ensp;{{ question.userId }}&ensp;/&ensp;投稿日時:&ensp;{{ question.createdAt }}
            <span v-if="!editing">
              <button type="button" class="edit-button btn btn-link"
                @click="startEdit"
              >
                更新する
              </button>
            </span>
          </div>
          <div class="question-body">
            {{ question.body }}
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
    };
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
  },
};
</script>

<style scoped>
</style>
