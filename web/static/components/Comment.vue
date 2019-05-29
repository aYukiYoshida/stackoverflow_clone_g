<template>
  <div>
    <div v-if="editing">
      <form
        class="comment-form"
        @submit.prevent="update"
      >
        <div class="form-group">
          <label for="form-body">コメント</label>
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
      <div class="balloon-set-box right">
        <div class="author">
          <router-link
            :to="{ name: 'UserDetailPage', params: { id:
              comment.userId }}"
          >
            名無しさん@{{ comment.userId }}
          </router-link>
        </div>
        <div class="body balloon">
          {{ comment.body }}
          <span v-if="!editing&&hasValidComAuthorization">
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
      <div class="date">
        <p>Comment at {{ comment.createAt }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Comment',
  props: {
    comment: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      newCommentauthor: '',
      editing: false,
      editingBody: '',
    };
  },
  computed: {
    hasValidComAuthorization() {
      return this.comment.userId === this.$store.state.id;
    },
  },
  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.comment.body;
      this.editingId = this.comment.id;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { id: this.editingId, body: this.editingBody });
      this.editing = false;
    },
  },
};
</script>

<style scoped>
</style>
