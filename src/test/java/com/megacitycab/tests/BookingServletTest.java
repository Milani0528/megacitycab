package com.megacitycab.tests;

import com.megacitycab.servlets.BookingServlet;
import com.megacitycab.utils.DBConnection;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class BookingServletTest {

    @InjectMocks
    private BookingServlet bookingServlet;

    @Mock private HttpServletRequest request;
    @Mock private HttpServletResponse response;
    @Mock private HttpSession session;
    @Mock private Connection connection;
    @Mock private PreparedStatement preparedStatement;

    private StringWriter stringWriter;
    private PrintWriter writer;

    @BeforeEach
    void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);

        when(request.getSession()).thenReturn(session);
        when(session.getAttribute("userId")).thenReturn(1);  // Mock logged-in user

        // **FIX: Ensure parameter names match servlet**
        lenient().when(request.getParameter("pickup_location")).thenReturn("Colombo");
        lenient().when(request.getParameter("dropoff_location")).thenReturn("Matara");
        lenient().when(request.getParameter("booking_date")).thenReturn("2025-03-01T12:30");

        // Mock HttpServletResponse output
        stringWriter = new StringWriter();
        writer = new PrintWriter(stringWriter);
        lenient().when(response.getWriter()).thenReturn(writer);
    }

    @Test
    void testSuccessfulBooking() throws Exception {
        try (MockedStatic<DBConnection> dbConnectionMockedStatic = Mockito.mockStatic(DBConnection.class)) {
            dbConnectionMockedStatic.when(DBConnection::getConnection).thenReturn(connection);
            when(connection.prepareStatement(any(String.class))).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1);  // Ensure DB update is simulated

            bookingServlet.doPost(request, response);

            // Verify response.sendRedirect() is called
            verify(response, times(1)).sendRedirect("dashboard.jsp");

            // Alternative: Check if response's writer is used incorrectly
            verify(response, never()).getWriter();
        }
    }


    @Test
    void testBookingWithNoUserSession() throws Exception {
        when(session.getAttribute("userId")).thenReturn(null);
        bookingServlet.doPost(request, response);
        writer.flush();

        assertTrue(stringWriter.toString().contains("Error: You must be logged in to book a cab."));
    }
}
