<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question"/>
    </div>
    <br>
    <h4>ツッコミ:</h4>
    <div v-for="comment in question.comments" :key="comment.id">
      <comment :comment="comment"/>
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
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },

    question() {
      return this.$store.state.question;
    }
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {      
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id});    
    },
  },
};
</script>

<style scoped>
</style>
