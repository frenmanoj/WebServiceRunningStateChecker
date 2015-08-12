<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<c:set var="context" value="${pageContext.request.contextPath}" />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Web Service Watchdog Agent</title>

<link rel="stylesheet" type="text/css"
	href="${context}/resources/css/style.css">

</head>
<body>
	<h2>Web Service Watchdog Agent</h2>
	<hr>
	<br>
	<input type="checkbox" id="monitoringActive" checked>Monitoring
	Active
	<br>
	<br>
	<div>
		<div class="form-group">
			<label for="input-uri">Enter URI of the Web Service:</label> <input
				class="form-control" id="input-uri">
		</div>
	</div>
	<br>
	<div>
		The status of the above service:
		<p id="status">Checking...</p>
	</div>



	<script src="${context}/resources/js/jquery-2.1.4.min.js"></script>

	<script type="text/javascript">
	
		var NOT_ACTIVE = "Monitoring not active!";
		var CHECKING = "Checking...";
		var NO_URI = "No URI found!!!";
		var RUNNING = "RUNNING";
		var FAILED = "FAILED!";
	
		// Shorthand for $( document ).ready()
		$(function() {

			setInterval(function() {
				checkStatus();
			}, 1000);

			monitoringState();
		});

		function checkStatus() {
			
			if ( $("#monitoringActive").is(":checked") == false) {
				
				updateStatus( NOT_ACTIVE, "red");
				return;
			}

			var uri = $("#input-uri").val();

			if (!uri) {

				updateStatus( NO_URI, "red");
				return;
			}

			$.ajax({
				url : "monitor",
				type : "get", // send it through get method
				data : {
					uri : uri
				},
				success : function(result) {

					if (result.isServerRunning == "true") {

						updateStatus( RUNNING , "green");
					} else {
						updateStatus( FAILED, "red");
					}
				}
			});
		}

		function updateStatus(status, statusClass) {

			var statusPara = $("p#status");

			statusPara.text(status);
			
			statusPara.removeClass()
			
			if ( statusClass ) {
				
				statusPara.addClass(statusClass);
			}
		}

		function monitoringState() {

			$("#monitoringActive").click(function() {
				if ($(this).is(":checked")) {
					updateStatus( CHECKING );
				} else {
					updateStatus( NOT_ACTIVE, "red");
				}
			});
		}
	</script>
</body>
</html>