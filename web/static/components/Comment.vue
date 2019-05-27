<template>
  <div>
    {{ comment.body }}<br>
    {{ comment.createAt }}&nbsp;&nbsp; {{ comment.userId }}&nbsp;<br>
    <br>
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
