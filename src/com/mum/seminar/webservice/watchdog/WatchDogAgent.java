package com.mum.seminar.webservice.watchdog;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

public class WatchDogAgent extends HttpServlet {

	private static final long serialVersionUID = 4399565115384886562L;

	private static final int TIME_OUT = 2000;

	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String uri = request.getParameter("uri");

		Boolean isServerRunning = ping(uri, TIME_OUT);

		Map<String, String> result = new HashMap<String, String>();
		result.put("isServerRunning", isServerRunning.toString());

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(new Gson().toJson(result));
	}

	/**
	 * Pings a HTTP URL. This effectively sends a HEAD request and returns
	 * <code>true</code> if the response code is in the 200-399 range.
	 * 
	 * @param url
	 *            The HTTP URL to be pinged.
	 * @param timeout
	 *            The timeout in millis for both the connection timeout and the
	 *            response read timeout. Note that the total timeout is
	 *            effectively two times the given timeout.
	 * @return <code>true</code> if the given HTTP URL has returned response
	 *         code 200-399 on a HEAD request within the given timeout,
	 *         otherwise <code>false</code>.
	 */
	private boolean ping(String url, int timeout) {

		// Otherwise an exception may be thrown on invalid SSL certificates:
		url = url.replaceFirst("^https", "http");

		try {
			HttpURLConnection connection = (HttpURLConnection) new URL(url)
					.openConnection();
			connection.setConnectTimeout(timeout);
			connection.setReadTimeout(timeout);
			connection.setRequestMethod("HEAD");

			int responseCode = connection.getResponseCode();
			return (200 <= responseCode && responseCode <= 399);

		} catch (IOException exception) {
			return false;
		}
	}
}
