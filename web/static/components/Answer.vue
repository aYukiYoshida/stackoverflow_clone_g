<template>
  <div>
    {{ answer.body }}<br>
    {{ answer.createdAt }}&nbsp;&nbsp; {{ answer.userId }}&nbsp;<br>
    <br>
    <form
      class="data-form"
      @submit.prevent="submit"
    >
      <div class="form-group">
          <label for="form-body">コメントを追加</label>
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
    };
  },
  methods: {
    submit() {
      this.$store.dispatch('createAnswerComment', { questionId: this.$route.params.id, answerId: this.answer.id, body: this.commentBody })
      .then(() => {
        location.reload();
      });
    },
  },
};
</script>

<style scoped>
</style>
