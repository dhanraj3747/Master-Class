package com.tap.model;

public class StudentScore {
    private int studentId;
    private int assessmentId;
    private int marksScored;

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getAssessmentId() { return assessmentId; }
    public void setAssessmentId(int assessmentId) { this.assessmentId = assessmentId; }
    public int getMarksScored() { return marksScored; }
    public void setMarksScored(int marksScored) { this.marksScored = marksScored; }
}