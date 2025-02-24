package com.megacitycab.models;

import java.sql.Timestamp;


public class Booking {

    private int id;
    private String customerName;
    private String phone;
    private String pickupLocation;
    private String dropoffLocation;
    private Timestamp bookingDate;
    private String status;


    public Booking(int id, String customerName, String phone, String pickupLocation, String dropoffLocation, Timestamp bookingDate, String status) {
        this.id = id;
        this.customerName = customerName;
        this.phone = phone;
        this.pickupLocation = pickupLocation;
        this.dropoffLocation = dropoffLocation;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public String getCustomerName() {
        return customerName;
    }

    public String getPhone() {
        return phone;
    }

    public String getPickupLocation() {
        return pickupLocation;
    }

    public String getDropoffLocation() {
        return dropoffLocation;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public String getStatus() {
        return status;
    }
}
