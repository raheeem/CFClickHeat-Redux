<cfoutput>
<html>
	<head>
		<title>ClickHeat Test Page</title>
		<link rel="stylesheet" type="text/css" href="css/style.css" />
		<script type="text/javascript" src="js/clickheat.js"></script>
		<script type="text/javascript">
		clickHeatSite = 'Test Bed'; clickHeatPage = '#cgi.script_name#?#cgi.query_string#'; clickHeatQuota = 10; initClickHeat();
		</script>
	</head>
	<body>
		<div id="header">
			<h1><a href="#cgi.script_name#">This is the header</a></h1>
		</div>
		<div id="menu">
			<ul>
				<li><a href="#cgi.script_name#">Home</a></li>
				<li><a href="?page=about">About</a></li>
				<li><a href="?page=blog">Blog</a></li>
				<li><a href="?page=news">News</a></li>
				<li><a href="?page=contact">Contact</a></li>
				<li><a href="?page=services">Services</a></li>
			</ul>
		</div>
		<div id="content">
			<p>This is some content</p>
		</div>
	</body>
</html>
</cfoutput>