package com.tap.model;
import java.util.Map;

public class StudentProgressSummary {
    private int studentId;
    private String studentName;
    private Map<String, Integer> courseWiseProgress; // The % (50/75/100)
    private Map<String, Integer> assessmentScores;    // Real Marks (e.g., 20 pts)
    private Map<String, Integer> assignmentScores;    // Real Marks (e.g., 15 pts)

    public StudentProgressSummary(int studentId, String studentName, 
                                 Map<String, Integer> progress, 
                                 Map<String, Integer> assessments, 
                                 Map<String, Integer> assignments) {
        this.studentId = studentId;
        this.studentName = studentName;
        this.courseWiseProgress = progress;
        this.assessmentScores = assessments;
        this.assignmentScores = assignments;
    }

    // Getters
    public int getStudentId() { return studentId; }
    public String getStudentName() { return studentName; }
    public Map<String, Integer> getCourseWiseProgress() { return courseWiseProgress; }
    public Map<String, Integer> getAssessmentScores() { return assessmentScores; }
    public Map<String, Integer> getAssignmentScores() { return assignmentScores; }
}