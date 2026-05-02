package com.tap.model;

public class QuestionResult {
    private String questionText;
    private String selectedOption;
    private String correctOption;
    private boolean isCorrect;

    public QuestionResult(String questionText, String selectedOption, String correctOption, boolean isCorrect) {
        this.questionText = questionText;
        this.selectedOption = selectedOption != null ? selectedOption : "Not Answered";
        this.correctOption = correctOption;
        this.isCorrect = isCorrect;
    }

    public String getQuestionText() { return questionText; }
    public String getSelectedOption() { return selectedOption; }
    public String getCorrectOption() { return correctOption; }
    public boolean isCorrect() { return isCorrect; }
}