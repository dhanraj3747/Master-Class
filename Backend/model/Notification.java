package com.tap.model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private int studentId;
    private String fileName;
    private String uploadType;
    private String topicFolder;
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {}

    // Ensure this EXACT constructor exists
    public Notification(int id, int studentId, String fileName, String uploadType, String topicFolder, boolean isRead, Timestamp createdAt) {
        this.id = id;
        this.studentId = studentId;
        this.fileName = fileName;
        this.uploadType = uploadType;
        this.topicFolder = topicFolder;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    // Getters and Setters...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }
    public String getUploadType() { return uploadType; }
    public void setUploadType(String uploadType) { this.uploadType = uploadType; }
    public String getTopicFolder() { return topicFolder; }
    public void setTopicFolder(String topicFolder) { this.topicFolder = topicFolder; }
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}