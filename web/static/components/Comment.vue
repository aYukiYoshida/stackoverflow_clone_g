<template>
  <div>
    <span>
      <p>{{ comment.userId }}さん</p>
      <p>{{ comment.body }}</p>
    </span>
    <span>
      <p>{{ comment.createAt }}</p>
    </span>
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
};
</script>

<style scoped>
</style>
