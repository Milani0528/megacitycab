package com.megacitycab.tests;

import com.megacitycab.servlets.RegisterServlet;
import com.megacitycab.utils.DBConnection;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RegisterServletTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement preparedStatement;

    @Mock
    private RequestDispatcher dispatcher;

    private RegisterServlet registerServlet;

    @BeforeEach
    void setUp() {
        registerServlet = new RegisterServlet();
    }

    @Test
    void testRegisterSuccess() throws Exception {
        // Mock DB Connection and static method
        try (MockedStatic<DBConnection> dbConnectionMock = Mockito.mockStatic(DBConnection.class)) {
            dbConnectionMock.when(DBConnection::getConnection).thenReturn(connection);

            // Mock request parameters
            when(request.getParameter("full_name")).thenReturn("John Doe");
            when(request.getParameter("phone")).thenReturn("123456789");
            when(request.getParameter("email")).thenReturn("john@example.com");
            when(request.getParameter("username")).thenReturn("john123");
            when(request.getParameter("password")).thenReturn("pass123");
            when(request.getParameter("role")).thenReturn("customer");

            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(1);

            when(request.getRequestDispatcher("register.jsp")).thenReturn(dispatcher);

            // Perform the servlet action
            registerServlet.doPost(request, response);

            // Verify behavior
            verify(request).setAttribute("success", true);
            verify(dispatcher).forward(request, response);
        }
    }

    @Test
    void testRegisterFailure() throws Exception {
        try (MockedStatic<DBConnection> dbConnectionMock = Mockito.mockStatic(DBConnection.class)) {
            dbConnectionMock.when(DBConnection::getConnection).thenReturn(connection);

            when(request.getParameter("full_name")).thenReturn("Jane Doe");
            when(request.getParameter("phone")).thenReturn("123456789");
            when(request.getParameter("email")).thenReturn("jane@example.com");
            when(request.getParameter("username")).thenReturn("jane123");
            when(request.getParameter("password")).thenReturn("pass123");
            when(request.getParameter("role")).thenReturn("customer");

            when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);
            when(preparedStatement.executeUpdate()).thenReturn(0);  // Simulate failure

            when(request.getRequestDispatcher("register.jsp")).thenReturn(dispatcher);

            registerServlet.doPost(request, response);

            // Should not set success if registration fails
            verify(request, never()).setAttribute(eq("success"), eq(true));
            verify(dispatcher).forward(request, response);
        }
    }

    @Test
    void testRegisterException() throws Exception {
        try (MockedStatic<DBConnection> dbConnectionMock = Mockito.mockStatic(DBConnection.class)) {

            // Mock successful DB Connection
            dbConnectionMock.when(DBConnection::getConnection).thenReturn(connection);

            // Mock the parameter retrieval normally
            when(request.getParameter("full_name")).thenReturn("John Doe");
            when(request.getParameter("phone")).thenReturn("123456789");
            when(request.getParameter("email")).thenReturn("john@example.com");
            when(request.getParameter("username")).thenReturn("john123");
            when(request.getParameter("password")).thenReturn("pass123");
            when(request.getParameter("role")).thenReturn("customer");

            // Mock exception when preparing statement (simulate DB failure)
            when(connection.prepareStatement(anyString())).thenThrow(new RuntimeException("DB Error"));

            // Mock response writer to capture servlet output
            PrintWriter writer = mock(PrintWriter.class);
            when(response.getWriter()).thenReturn(writer);

            // Execute the servlet logic
            registerServlet.doPost(request, response);

            // Verify the error message output
            verify(writer).println(contains("Error Registering User."));
        }
    }

}
