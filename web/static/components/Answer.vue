<template>
  <div>
    {{ answer.body }}<br>
    {{ answer.createdAt }}&nbsp;&nbsp; {{ answer.userId }}&nbsp;<br>
    <br>
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
};
</script>

<style scoped>
</style>
