package com.tap.model;

public class QuestionResult {
    private String questionText;
    private String userAnswer;
    private String correctAnswer;
    private boolean isCorrect;

    // Constructor
    public QuestionResult(String questionText, String userAnswer, String correctAnswer, boolean isCorrect) {
        this.questionText = questionText;
        this.userAnswer = userAnswer;
        this.correctAnswer = correctAnswer;
        this.isCorrect = isCorrect;
    }

    // ==========================================
    // YOU MUST INCLUDE THESE GETTERS BELOW!
    // ==========================================

    public String getQuestionText() {
        return questionText;
    }

    public String getUserAnswer() {
        return userAnswer;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public boolean isCorrect() {
        return isCorrect;
    }
}