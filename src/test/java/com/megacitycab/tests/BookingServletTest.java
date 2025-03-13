package com.megacitycab.tests;

import com.megacitycab.servlets.BookingServlet;
import com.megacitycab.utils.DBConnection;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BookingServletTest {

    @InjectMocks
    private BookingServlet bookingServlet;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement preparedStatement;

    @Mock
    private RequestDispatcher dispatcher;

    private static MockedStatic<DBConnection> mockedDbConnection;

    @BeforeAll
    static void setupStaticMock() {
        // Initialize static mock for DBConnection
        mockedDbConnection = mockStatic(DBConnection.class);
    }

    @AfterAll
    static void closeStaticMock() {
        mockedDbConnection.close();
    }

    @BeforeEach
    void setup() throws Exception {
        lenient().when(DBConnection.getConnection()).thenReturn(connection);
        lenient().when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
        lenient().when(request.getSession()).thenReturn(session);

        // Lenient stubbing for request parameters to avoid strict stubbing issues
        lenient().when(request.getParameter("pickup_location")).thenReturn("Colombo");
        lenient().when(request.getParameter("dropoff_location")).thenReturn("Kandy");
        lenient().when(request.getParameter("booking_date")).thenReturn("2025-03-13T10:00");
        lenient().when(request.getParameter("vehicle_type")).thenReturn("Van");
    }

    @Test
    void testBookingSuccess() throws Exception {
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("pickup_location")).thenReturn("Colombo");
        when(request.getParameter("dropoff_location")).thenReturn("Kandy");
        when(request.getParameter("booking_date")).thenReturn("2025-03-13T10:00");
        when(request.getParameter("vehicle_type")).thenReturn("Van");
        when(preparedStatement.executeUpdate()).thenReturn(1);

        doNothing().when(response).sendRedirect("dashboard.jsp");

        bookingServlet.doPost(request, response);

        verify(preparedStatement, times(1)).executeUpdate();
        verify(response, times(1)).sendRedirect("dashboard.jsp");
    }

    @Test
    void testBookingFailure() throws Exception {
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("pickup_location")).thenReturn("Colombo");
        when(request.getParameter("dropoff_location")).thenReturn("Kandy");
        when(request.getParameter("booking_date")).thenReturn("2025-03-13T10:00");
        when(request.getParameter("vehicle_type")).thenReturn("Van");
        when(preparedStatement.executeUpdate()).thenReturn(0);

        StringWriter writer = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer));

        bookingServlet.doPost(request, response);

        assertTrue(writer.toString().contains("Error: Failed to book cab."));
    }

    @Test
    void testBookingMissingDate() throws Exception {
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("pickup_location")).thenReturn("Colombo");
        when(request.getParameter("dropoff_location")).thenReturn("Kandy");
        when(request.getParameter("booking_date")).thenReturn(""); // Missing Date Scenario
        when(request.getParameter("vehicle_type")).thenReturn("Van");

        StringWriter writer = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer));

        bookingServlet.doPost(request, response);

        assertTrue(writer.toString().contains("Error: Booking Date is required."));
    }

    @Test
    void testNoUserInSession() throws Exception {
        when(session.getAttribute("userId")).thenReturn(null);

        StringWriter writer = new StringWriter();
        when(response.getWriter()).thenReturn(new PrintWriter(writer));

        bookingServlet.doPost(request, response);

        assertTrue(writer.toString().contains("Error: You must be logged in to book a cab."));
    }
}
